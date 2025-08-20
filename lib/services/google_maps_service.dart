import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';

class GoogleMapsService {
  static const double _defaultLatitude = 37.4979;
  static const double _defaultLongitude = 127.0276;
  
  // Get current location
  Future<LatLng?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (Env.enableLogging) print('Location services are disabled');
        return const LatLng(_defaultLatitude, _defaultLongitude);
      }
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (Env.enableLogging) print('Location permissions are denied');
          return const LatLng(_defaultLatitude, _defaultLongitude);
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        if (Env.enableLogging) print('Location permissions are permanently denied');
        return const LatLng(_defaultLatitude, _defaultLongitude);
      }
      
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      if (Env.enableLogging) print('Get current location error: $e');
      return const LatLng(_defaultLatitude, _defaultLongitude);
    }
  }
  
  // Geocoding: Convert address to coordinates
  Future<LatLng?> geocodeAddress(String address) async {
    try {
      final encodedAddress = Uri.encodeComponent(address);
      final url = 'https://maps.googleapis.com/maps/api/geocode/json'
          '?address=$encodedAddress'
          '&key=${Env.googleMapsApiKey}';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        }
      }
      
      return null;
    } catch (e) {
      if (Env.enableLogging) print('Geocode address error: $e');
      return null;
    }
  }
  
  // Reverse Geocoding: Convert coordinates to address
  Future<String?> reverseGeocode(LatLng position) async {
    try {
      final url = 'https://maps.googleapis.com/maps/api/geocode/json'
          '?latlng=${position.latitude},${position.longitude}'
          '&key=${Env.googleMapsApiKey}';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          return data['results'][0]['formatted_address'];
        }
      }
      
      return null;
    } catch (e) {
      if (Env.enableLogging) print('Reverse geocode error: $e');
      return null;
    }
  }
  
  // Calculate distance between two points
  double calculateDistance(LatLng point1, LatLng point2) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    ) / 1000; // Convert to kilometers
  }
  
  // Get nearby places
  Future<List<Map<String, dynamic>>> getNearbyPlaces(
    LatLng location,
    String type, {
    int radius = 1000,
  }) async {
    try {
      final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=${location.latitude},${location.longitude}'
          '&radius=$radius'
          '&type=$type'
          '&key=${Env.googleMapsApiKey}';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          return List<Map<String, dynamic>>.from(data['results']);
        }
      }
      
      return [];
    } catch (e) {
      if (Env.enableLogging) print('Get nearby places error: $e');
      return [];
    }
  }
  
  // Get directions between two points
  Future<Map<String, dynamic>?> getDirections(
    LatLng origin,
    LatLng destination,
  ) async {
    try {
      final url = 'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=${origin.latitude},${origin.longitude}'
          '&destination=${destination.latitude},${destination.longitude}'
          '&key=${Env.googleMapsApiKey}';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          return data['routes'][0];
        }
      }
      
      return null;
    } catch (e) {
      if (Env.enableLogging) print('Get directions error: $e');
      return null;
    }
  }
  
  // Create custom markers for items
  Set<Marker> createItemMarkers(
    List<Map<String, dynamic>> items,
    Function(String) onMarkerTap,
  ) {
    return items.map((item) {
      final LatLng position = item['position'] ?? 
          const LatLng(_defaultLatitude, _defaultLongitude);
      
      return Marker(
        markerId: MarkerId(item['id']),
        position: position,
        infoWindow: InfoWindow(
          title: item['title'],
          snippet: '${item['price']}원/일',
          onTap: () => onMarkerTap(item['id']),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          _getCategoryColor(item['category']),
        ),
      );
    }).toSet();
  }
  
  double _getCategoryColor(String category) {
    switch (category) {
      case '카메라':
        return BitmapDescriptor.hueBlue;
      case '스포츠':
        return BitmapDescriptor.hueGreen;
      case '도구':
        return BitmapDescriptor.hueOrange;
      case '주방용품':
        return BitmapDescriptor.hueRed;
      case '완구':
        return BitmapDescriptor.hueYellow;
      case '악기':
        return BitmapDescriptor.hueMagenta;
      default:
        return BitmapDescriptor.hueRed;
    }
  }
  
  // Get address suggestions (autocomplete)
  Future<List<Map<String, dynamic>>> getAddressSuggestions(String input) async {
    if (input.isEmpty) return [];
    
    try {
      final encodedInput = Uri.encodeComponent(input);
      final url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=$encodedInput'
          '&types=address'
          '&components=country:KR'
          '&key=${Env.googleMapsApiKey}';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          return List<Map<String, dynamic>>.from(data['predictions']);
        }
      }
      
      return [];
    } catch (e) {
      if (Env.enableLogging) print('Get address suggestions error: $e');
      return [];
    }
  }
}

// Location state management
class LocationState {
  final LatLng? currentLocation;
  final String? currentAddress;
  final bool isLoading;
  final String? error;
  
  const LocationState({
    this.currentLocation,
    this.currentAddress,
    this.isLoading = false,
    this.error,
  });
  
  LocationState copyWith({
    LatLng? currentLocation,
    String? currentAddress,
    bool? isLoading,
    String? error,
  }) {
    return LocationState(
      currentLocation: currentLocation ?? this.currentLocation,
      currentAddress: currentAddress ?? this.currentAddress,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  final GoogleMapsService _mapsService;
  
  LocationNotifier(this._mapsService) : super(const LocationState());
  
  Future<void> getCurrentLocation() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final location = await _mapsService.getCurrentLocation();
      if (location != null) {
        final address = await _mapsService.reverseGeocode(location);
        state = state.copyWith(
          currentLocation: location,
          currentAddress: address,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: '위치를 가져올 수 없습니다',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  Future<void> searchLocation(String address) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final location = await _mapsService.geocodeAddress(address);
      if (location != null) {
        state = state.copyWith(
          currentLocation: location,
          currentAddress: address,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: '주소를 찾을 수 없습니다',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

// Providers
final googleMapsServiceProvider = Provider<GoogleMapsService>((ref) {
  return GoogleMapsService();
});

final locationNotifierProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier(ref.read(googleMapsServiceProvider));
});