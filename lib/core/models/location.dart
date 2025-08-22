import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';

@freezed
class UserLocation with _$UserLocation {
  const factory UserLocation({
    required double latitude,
    required double longitude,
    double? accuracy,
  }) = _UserLocation;
}

@freezed
class LocationPermissionState with _$LocationPermissionState {
  const factory LocationPermissionState({
    required bool isGranted,
    required bool isServiceEnabled,
    required bool isPermanentlyDenied,
  }) = _LocationPermissionState;
}