import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/location.dart';
import '../services/location_service.dart';

final locationPermissionProvider = FutureProvider<LocationPermissionState>((ref) async {
  return await LocationService.checkPermissions();
});

final currentLocationProvider = FutureProvider<UserLocation?>((ref) async {
  return await LocationService.getCurrentLocation();
});

final locationStreamProvider = StreamProvider<UserLocation>((ref) {
  return LocationService.getLocationStream();
});

class LocationState {
  final UserLocation? userLocation;
  final LocationPermissionState? permissionState;
  final bool isLoading;
  final String? error;

  const LocationState({
    this.userLocation,
    this.permissionState,
    this.isLoading = false,
    this.error,
  });

  LocationState copyWith({
    UserLocation? userLocation,
    LocationPermissionState? permissionState,
    bool? isLoading,
    String? error,
  }) {
    return LocationState(
      userLocation: userLocation ?? this.userLocation,
      permissionState: permissionState ?? this.permissionState,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(const LocationState());

  Future<void> checkPermissions() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final permissions = await LocationService.checkPermissions();
      state = state.copyWith(permissionState: permissions, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> getCurrentLocation() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final location = await LocationService.getCurrentLocation();
      state = state.copyWith(userLocation: location, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> openLocationSettings() async {
    await LocationService.openLocationSettings();
  }

  Future<void> openAppSettings() async {
    await LocationService.openAppSettings();
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});