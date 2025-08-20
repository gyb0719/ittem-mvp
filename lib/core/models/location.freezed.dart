// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserLocation {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double? get accuracy => throw _privateConstructorUsedError;

  /// Create a copy of UserLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserLocationCopyWith<UserLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserLocationCopyWith<$Res> {
  factory $UserLocationCopyWith(
    UserLocation value,
    $Res Function(UserLocation) then,
  ) = _$UserLocationCopyWithImpl<$Res, UserLocation>;
  @useResult
  $Res call({double latitude, double longitude, double? accuracy});
}

/// @nodoc
class _$UserLocationCopyWithImpl<$Res, $Val extends UserLocation>
    implements $UserLocationCopyWith<$Res> {
  _$UserLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? accuracy = freezed,
  }) {
    return _then(
      _value.copyWith(
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            accuracy: freezed == accuracy
                ? _value.accuracy
                : accuracy // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserLocationImplCopyWith<$Res>
    implements $UserLocationCopyWith<$Res> {
  factory _$$UserLocationImplCopyWith(
    _$UserLocationImpl value,
    $Res Function(_$UserLocationImpl) then,
  ) = __$$UserLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double latitude, double longitude, double? accuracy});
}

/// @nodoc
class __$$UserLocationImplCopyWithImpl<$Res>
    extends _$UserLocationCopyWithImpl<$Res, _$UserLocationImpl>
    implements _$$UserLocationImplCopyWith<$Res> {
  __$$UserLocationImplCopyWithImpl(
    _$UserLocationImpl _value,
    $Res Function(_$UserLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? accuracy = freezed,
  }) {
    return _then(
      _$UserLocationImpl(
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        accuracy: freezed == accuracy
            ? _value.accuracy
            : accuracy // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc

class _$UserLocationImpl implements _UserLocation {
  const _$UserLocationImpl({
    required this.latitude,
    required this.longitude,
    this.accuracy,
  });

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double? accuracy;

  @override
  String toString() {
    return 'UserLocation(latitude: $latitude, longitude: $longitude, accuracy: $accuracy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserLocationImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude, accuracy);

  /// Create a copy of UserLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserLocationImplCopyWith<_$UserLocationImpl> get copyWith =>
      __$$UserLocationImplCopyWithImpl<_$UserLocationImpl>(this, _$identity);
}

abstract class _UserLocation implements UserLocation {
  const factory _UserLocation({
    required final double latitude,
    required final double longitude,
    final double? accuracy,
  }) = _$UserLocationImpl;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double? get accuracy;

  /// Create a copy of UserLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserLocationImplCopyWith<_$UserLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LocationPermissionState {
  bool get isGranted => throw _privateConstructorUsedError;
  bool get isServiceEnabled => throw _privateConstructorUsedError;
  bool get isPermanentlyDenied => throw _privateConstructorUsedError;

  /// Create a copy of LocationPermissionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationPermissionStateCopyWith<LocationPermissionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationPermissionStateCopyWith<$Res> {
  factory $LocationPermissionStateCopyWith(
    LocationPermissionState value,
    $Res Function(LocationPermissionState) then,
  ) = _$LocationPermissionStateCopyWithImpl<$Res, LocationPermissionState>;
  @useResult
  $Res call({bool isGranted, bool isServiceEnabled, bool isPermanentlyDenied});
}

/// @nodoc
class _$LocationPermissionStateCopyWithImpl<
  $Res,
  $Val extends LocationPermissionState
>
    implements $LocationPermissionStateCopyWith<$Res> {
  _$LocationPermissionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationPermissionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isGranted = null,
    Object? isServiceEnabled = null,
    Object? isPermanentlyDenied = null,
  }) {
    return _then(
      _value.copyWith(
            isGranted: null == isGranted
                ? _value.isGranted
                : isGranted // ignore: cast_nullable_to_non_nullable
                      as bool,
            isServiceEnabled: null == isServiceEnabled
                ? _value.isServiceEnabled
                : isServiceEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPermanentlyDenied: null == isPermanentlyDenied
                ? _value.isPermanentlyDenied
                : isPermanentlyDenied // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationPermissionStateImplCopyWith<$Res>
    implements $LocationPermissionStateCopyWith<$Res> {
  factory _$$LocationPermissionStateImplCopyWith(
    _$LocationPermissionStateImpl value,
    $Res Function(_$LocationPermissionStateImpl) then,
  ) = __$$LocationPermissionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isGranted, bool isServiceEnabled, bool isPermanentlyDenied});
}

/// @nodoc
class __$$LocationPermissionStateImplCopyWithImpl<$Res>
    extends
        _$LocationPermissionStateCopyWithImpl<
          $Res,
          _$LocationPermissionStateImpl
        >
    implements _$$LocationPermissionStateImplCopyWith<$Res> {
  __$$LocationPermissionStateImplCopyWithImpl(
    _$LocationPermissionStateImpl _value,
    $Res Function(_$LocationPermissionStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationPermissionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isGranted = null,
    Object? isServiceEnabled = null,
    Object? isPermanentlyDenied = null,
  }) {
    return _then(
      _$LocationPermissionStateImpl(
        isGranted: null == isGranted
            ? _value.isGranted
            : isGranted // ignore: cast_nullable_to_non_nullable
                  as bool,
        isServiceEnabled: null == isServiceEnabled
            ? _value.isServiceEnabled
            : isServiceEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPermanentlyDenied: null == isPermanentlyDenied
            ? _value.isPermanentlyDenied
            : isPermanentlyDenied // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$LocationPermissionStateImpl implements _LocationPermissionState {
  const _$LocationPermissionStateImpl({
    required this.isGranted,
    required this.isServiceEnabled,
    required this.isPermanentlyDenied,
  });

  @override
  final bool isGranted;
  @override
  final bool isServiceEnabled;
  @override
  final bool isPermanentlyDenied;

  @override
  String toString() {
    return 'LocationPermissionState(isGranted: $isGranted, isServiceEnabled: $isServiceEnabled, isPermanentlyDenied: $isPermanentlyDenied)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationPermissionStateImpl &&
            (identical(other.isGranted, isGranted) ||
                other.isGranted == isGranted) &&
            (identical(other.isServiceEnabled, isServiceEnabled) ||
                other.isServiceEnabled == isServiceEnabled) &&
            (identical(other.isPermanentlyDenied, isPermanentlyDenied) ||
                other.isPermanentlyDenied == isPermanentlyDenied));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isGranted,
    isServiceEnabled,
    isPermanentlyDenied,
  );

  /// Create a copy of LocationPermissionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationPermissionStateImplCopyWith<_$LocationPermissionStateImpl>
  get copyWith =>
      __$$LocationPermissionStateImplCopyWithImpl<
        _$LocationPermissionStateImpl
      >(this, _$identity);
}

abstract class _LocationPermissionState implements LocationPermissionState {
  const factory _LocationPermissionState({
    required final bool isGranted,
    required final bool isServiceEnabled,
    required final bool isPermanentlyDenied,
  }) = _$LocationPermissionStateImpl;

  @override
  bool get isGranted;
  @override
  bool get isServiceEnabled;
  @override
  bool get isPermanentlyDenied;

  /// Create a copy of LocationPermissionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationPermissionStateImplCopyWith<_$LocationPermissionStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
