import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import '../models/location.dart';

class LocationService {
  static final _logger = Logger();

  static Future<LocationPermissionState> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const LocationPermissionState(
        isGranted: false,
        isServiceEnabled: false,
        isPermanentlyDenied: false,
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const LocationPermissionState(
          isGranted: false,
          isServiceEnabled: true,
          isPermanentlyDenied: false,
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return const LocationPermissionState(
        isGranted: false,
        isServiceEnabled: true,
        isPermanentlyDenied: true,
      );
    }

    return const LocationPermissionState(
      isGranted: true,
      isServiceEnabled: true,
      isPermanentlyDenied: false,
    );
  }

  static Future<UserLocation?> getCurrentLocation() async {
    try {
      final permissionState = await checkPermissions();
      if (!permissionState.isGranted) {
        _logger.w('Location permission not granted');
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
      );
    } catch (e, stackTrace) {
      _logger.e('Failed to get current location', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  static Stream<UserLocation> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
        timeLimit: Duration(seconds: 10),
      ),
    ).map((position) => UserLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
    ));
  }

  static double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  static Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}