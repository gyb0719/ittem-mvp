// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SearchFilter _$SearchFilterFromJson(Map<String, dynamic> json) {
  return _SearchFilter.fromJson(json);
}

/// @nodoc
mixin _$SearchFilter {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  SearchFilterType get type => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  dynamic get value => throw _privateConstructorUsedError;
  List<SearchFilterOption>? get options => throw _privateConstructorUsedError;
  SearchFilterRange? get range => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this SearchFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchFilterCopyWith<SearchFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchFilterCopyWith<$Res> {
  factory $SearchFilterCopyWith(
    SearchFilter value,
    $Res Function(SearchFilter) then,
  ) = _$SearchFilterCopyWithImpl<$Res, SearchFilter>;
  @useResult
  $Res call({
    String id,
    String name,
    SearchFilterType type,
    bool isActive,
    dynamic value,
    List<SearchFilterOption>? options,
    SearchFilterRange? range,
    Map<String, dynamic>? metadata,
  });

  $SearchFilterRangeCopyWith<$Res>? get range;
}

/// @nodoc
class _$SearchFilterCopyWithImpl<$Res, $Val extends SearchFilter>
    implements $SearchFilterCopyWith<$Res> {
  _$SearchFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? isActive = null,
    Object? value = freezed,
    Object? options = freezed,
    Object? range = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as SearchFilterType,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            value: freezed == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            options: freezed == options
                ? _value.options
                : options // ignore: cast_nullable_to_non_nullable
                      as List<SearchFilterOption>?,
            range: freezed == range
                ? _value.range
                : range // ignore: cast_nullable_to_non_nullable
                      as SearchFilterRange?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchFilterRangeCopyWith<$Res>? get range {
    if (_value.range == null) {
      return null;
    }

    return $SearchFilterRangeCopyWith<$Res>(_value.range!, (value) {
      return _then(_value.copyWith(range: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SearchFilterImplCopyWith<$Res>
    implements $SearchFilterCopyWith<$Res> {
  factory _$$SearchFilterImplCopyWith(
    _$SearchFilterImpl value,
    $Res Function(_$SearchFilterImpl) then,
  ) = __$$SearchFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    SearchFilterType type,
    bool isActive,
    dynamic value,
    List<SearchFilterOption>? options,
    SearchFilterRange? range,
    Map<String, dynamic>? metadata,
  });

  @override
  $SearchFilterRangeCopyWith<$Res>? get range;
}

/// @nodoc
class __$$SearchFilterImplCopyWithImpl<$Res>
    extends _$SearchFilterCopyWithImpl<$Res, _$SearchFilterImpl>
    implements _$$SearchFilterImplCopyWith<$Res> {
  __$$SearchFilterImplCopyWithImpl(
    _$SearchFilterImpl _value,
    $Res Function(_$SearchFilterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? isActive = null,
    Object? value = freezed,
    Object? options = freezed,
    Object? range = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$SearchFilterImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as SearchFilterType,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        value: freezed == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        options: freezed == options
            ? _value._options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<SearchFilterOption>?,
        range: freezed == range
            ? _value.range
            : range // ignore: cast_nullable_to_non_nullable
                  as SearchFilterRange?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchFilterImpl implements _SearchFilter {
  const _$SearchFilterImpl({
    required this.id,
    required this.name,
    required this.type,
    this.isActive = false,
    this.value,
    final List<SearchFilterOption>? options,
    this.range,
    final Map<String, dynamic>? metadata,
  }) : _options = options,
       _metadata = metadata;

  factory _$SearchFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchFilterImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final SearchFilterType type;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final dynamic value;
  final List<SearchFilterOption>? _options;
  @override
  List<SearchFilterOption>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final SearchFilterRange? range;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'SearchFilter(id: $id, name: $name, type: $type, isActive: $isActive, value: $value, options: $options, range: $range, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchFilterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.range, range) || other.range == range) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    type,
    isActive,
    const DeepCollectionEquality().hash(value),
    const DeepCollectionEquality().hash(_options),
    range,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchFilterImplCopyWith<_$SearchFilterImpl> get copyWith =>
      __$$SearchFilterImplCopyWithImpl<_$SearchFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchFilterImplToJson(this);
  }
}

abstract class _SearchFilter implements SearchFilter {
  const factory _SearchFilter({
    required final String id,
    required final String name,
    required final SearchFilterType type,
    final bool isActive,
    final dynamic value,
    final List<SearchFilterOption>? options,
    final SearchFilterRange? range,
    final Map<String, dynamic>? metadata,
  }) = _$SearchFilterImpl;

  factory _SearchFilter.fromJson(Map<String, dynamic> json) =
      _$SearchFilterImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  SearchFilterType get type;
  @override
  bool get isActive;
  @override
  dynamic get value;
  @override
  List<SearchFilterOption>? get options;
  @override
  SearchFilterRange? get range;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchFilterImplCopyWith<_$SearchFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchFilterOption _$SearchFilterOptionFromJson(Map<String, dynamic> json) {
  return _SearchFilterOption.fromJson(json);
}

/// @nodoc
mixin _$SearchFilterOption {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  String? get iconUrl => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this SearchFilterOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchFilterOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchFilterOptionCopyWith<SearchFilterOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchFilterOptionCopyWith<$Res> {
  factory $SearchFilterOptionCopyWith(
    SearchFilterOption value,
    $Res Function(SearchFilterOption) then,
  ) = _$SearchFilterOptionCopyWithImpl<$Res, SearchFilterOption>;
  @useResult
  $Res call({
    String id,
    String label,
    bool isSelected,
    int count,
    String? iconUrl,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$SearchFilterOptionCopyWithImpl<$Res, $Val extends SearchFilterOption>
    implements $SearchFilterOptionCopyWith<$Res> {
  _$SearchFilterOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchFilterOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? isSelected = null,
    Object? count = null,
    Object? iconUrl = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            isSelected: null == isSelected
                ? _value.isSelected
                : isSelected // ignore: cast_nullable_to_non_nullable
                      as bool,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchFilterOptionImplCopyWith<$Res>
    implements $SearchFilterOptionCopyWith<$Res> {
  factory _$$SearchFilterOptionImplCopyWith(
    _$SearchFilterOptionImpl value,
    $Res Function(_$SearchFilterOptionImpl) then,
  ) = __$$SearchFilterOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String label,
    bool isSelected,
    int count,
    String? iconUrl,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$SearchFilterOptionImplCopyWithImpl<$Res>
    extends _$SearchFilterOptionCopyWithImpl<$Res, _$SearchFilterOptionImpl>
    implements _$$SearchFilterOptionImplCopyWith<$Res> {
  __$$SearchFilterOptionImplCopyWithImpl(
    _$SearchFilterOptionImpl _value,
    $Res Function(_$SearchFilterOptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchFilterOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? isSelected = null,
    Object? count = null,
    Object? iconUrl = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$SearchFilterOptionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        isSelected: null == isSelected
            ? _value.isSelected
            : isSelected // ignore: cast_nullable_to_non_nullable
                  as bool,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchFilterOptionImpl implements _SearchFilterOption {
  const _$SearchFilterOptionImpl({
    required this.id,
    required this.label,
    this.isSelected = false,
    this.count = 0,
    this.iconUrl,
    final Map<String, dynamic>? metadata,
  }) : _metadata = metadata;

  factory _$SearchFilterOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchFilterOptionImplFromJson(json);

  @override
  final String id;
  @override
  final String label;
  @override
  @JsonKey()
  final bool isSelected;
  @override
  @JsonKey()
  final int count;
  @override
  final String? iconUrl;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'SearchFilterOption(id: $id, label: $label, isSelected: $isSelected, count: $count, iconUrl: $iconUrl, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchFilterOptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    label,
    isSelected,
    count,
    iconUrl,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of SearchFilterOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchFilterOptionImplCopyWith<_$SearchFilterOptionImpl> get copyWith =>
      __$$SearchFilterOptionImplCopyWithImpl<_$SearchFilterOptionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchFilterOptionImplToJson(this);
  }
}

abstract class _SearchFilterOption implements SearchFilterOption {
  const factory _SearchFilterOption({
    required final String id,
    required final String label,
    final bool isSelected,
    final int count,
    final String? iconUrl,
    final Map<String, dynamic>? metadata,
  }) = _$SearchFilterOptionImpl;

  factory _SearchFilterOption.fromJson(Map<String, dynamic> json) =
      _$SearchFilterOptionImpl.fromJson;

  @override
  String get id;
  @override
  String get label;
  @override
  bool get isSelected;
  @override
  int get count;
  @override
  String? get iconUrl;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of SearchFilterOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchFilterOptionImplCopyWith<_$SearchFilterOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchFilterRange _$SearchFilterRangeFromJson(Map<String, dynamic> json) {
  return _SearchFilterRange.fromJson(json);
}

/// @nodoc
mixin _$SearchFilterRange {
  double get min => throw _privateConstructorUsedError;
  double get max => throw _privateConstructorUsedError;
  double get currentMin => throw _privateConstructorUsedError;
  double get currentMax => throw _privateConstructorUsedError;
  double get step => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  String? get formatter => throw _privateConstructorUsedError;

  /// Serializes this SearchFilterRange to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchFilterRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchFilterRangeCopyWith<SearchFilterRange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchFilterRangeCopyWith<$Res> {
  factory $SearchFilterRangeCopyWith(
    SearchFilterRange value,
    $Res Function(SearchFilterRange) then,
  ) = _$SearchFilterRangeCopyWithImpl<$Res, SearchFilterRange>;
  @useResult
  $Res call({
    double min,
    double max,
    double currentMin,
    double currentMax,
    double step,
    String? unit,
    String? formatter,
  });
}

/// @nodoc
class _$SearchFilterRangeCopyWithImpl<$Res, $Val extends SearchFilterRange>
    implements $SearchFilterRangeCopyWith<$Res> {
  _$SearchFilterRangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchFilterRange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? min = null,
    Object? max = null,
    Object? currentMin = null,
    Object? currentMax = null,
    Object? step = null,
    Object? unit = freezed,
    Object? formatter = freezed,
  }) {
    return _then(
      _value.copyWith(
            min: null == min
                ? _value.min
                : min // ignore: cast_nullable_to_non_nullable
                      as double,
            max: null == max
                ? _value.max
                : max // ignore: cast_nullable_to_non_nullable
                      as double,
            currentMin: null == currentMin
                ? _value.currentMin
                : currentMin // ignore: cast_nullable_to_non_nullable
                      as double,
            currentMax: null == currentMax
                ? _value.currentMax
                : currentMax // ignore: cast_nullable_to_non_nullable
                      as double,
            step: null == step
                ? _value.step
                : step // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: freezed == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String?,
            formatter: freezed == formatter
                ? _value.formatter
                : formatter // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchFilterRangeImplCopyWith<$Res>
    implements $SearchFilterRangeCopyWith<$Res> {
  factory _$$SearchFilterRangeImplCopyWith(
    _$SearchFilterRangeImpl value,
    $Res Function(_$SearchFilterRangeImpl) then,
  ) = __$$SearchFilterRangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double min,
    double max,
    double currentMin,
    double currentMax,
    double step,
    String? unit,
    String? formatter,
  });
}

/// @nodoc
class __$$SearchFilterRangeImplCopyWithImpl<$Res>
    extends _$SearchFilterRangeCopyWithImpl<$Res, _$SearchFilterRangeImpl>
    implements _$$SearchFilterRangeImplCopyWith<$Res> {
  __$$SearchFilterRangeImplCopyWithImpl(
    _$SearchFilterRangeImpl _value,
    $Res Function(_$SearchFilterRangeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchFilterRange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? min = null,
    Object? max = null,
    Object? currentMin = null,
    Object? currentMax = null,
    Object? step = null,
    Object? unit = freezed,
    Object? formatter = freezed,
  }) {
    return _then(
      _$SearchFilterRangeImpl(
        min: null == min
            ? _value.min
            : min // ignore: cast_nullable_to_non_nullable
                  as double,
        max: null == max
            ? _value.max
            : max // ignore: cast_nullable_to_non_nullable
                  as double,
        currentMin: null == currentMin
            ? _value.currentMin
            : currentMin // ignore: cast_nullable_to_non_nullable
                  as double,
        currentMax: null == currentMax
            ? _value.currentMax
            : currentMax // ignore: cast_nullable_to_non_nullable
                  as double,
        step: null == step
            ? _value.step
            : step // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: freezed == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String?,
        formatter: freezed == formatter
            ? _value.formatter
            : formatter // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchFilterRangeImpl implements _SearchFilterRange {
  const _$SearchFilterRangeImpl({
    required this.min,
    required this.max,
    required this.currentMin,
    required this.currentMax,
    this.step = 1.0,
    this.unit,
    this.formatter,
  });

  factory _$SearchFilterRangeImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchFilterRangeImplFromJson(json);

  @override
  final double min;
  @override
  final double max;
  @override
  final double currentMin;
  @override
  final double currentMax;
  @override
  @JsonKey()
  final double step;
  @override
  final String? unit;
  @override
  final String? formatter;

  @override
  String toString() {
    return 'SearchFilterRange(min: $min, max: $max, currentMin: $currentMin, currentMax: $currentMax, step: $step, unit: $unit, formatter: $formatter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchFilterRangeImpl &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.currentMin, currentMin) ||
                other.currentMin == currentMin) &&
            (identical(other.currentMax, currentMax) ||
                other.currentMax == currentMax) &&
            (identical(other.step, step) || other.step == step) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.formatter, formatter) ||
                other.formatter == formatter));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    min,
    max,
    currentMin,
    currentMax,
    step,
    unit,
    formatter,
  );

  /// Create a copy of SearchFilterRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchFilterRangeImplCopyWith<_$SearchFilterRangeImpl> get copyWith =>
      __$$SearchFilterRangeImplCopyWithImpl<_$SearchFilterRangeImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchFilterRangeImplToJson(this);
  }
}

abstract class _SearchFilterRange implements SearchFilterRange {
  const factory _SearchFilterRange({
    required final double min,
    required final double max,
    required final double currentMin,
    required final double currentMax,
    final double step,
    final String? unit,
    final String? formatter,
  }) = _$SearchFilterRangeImpl;

  factory _SearchFilterRange.fromJson(Map<String, dynamic> json) =
      _$SearchFilterRangeImpl.fromJson;

  @override
  double get min;
  @override
  double get max;
  @override
  double get currentMin;
  @override
  double get currentMax;
  @override
  double get step;
  @override
  String? get unit;
  @override
  String? get formatter;

  /// Create a copy of SearchFilterRange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchFilterRangeImplCopyWith<_$SearchFilterRangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchFilterPreset _$SearchFilterPresetFromJson(Map<String, dynamic> json) {
  return _SearchFilterPreset.fromJson(json);
}

/// @nodoc
mixin _$SearchFilterPreset {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<SearchFilter> get filters => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get iconUrl => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastUsed => throw _privateConstructorUsedError;

  /// Serializes this SearchFilterPreset to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchFilterPreset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchFilterPresetCopyWith<SearchFilterPreset> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchFilterPresetCopyWith<$Res> {
  factory $SearchFilterPresetCopyWith(
    SearchFilterPreset value,
    $Res Function(SearchFilterPreset) then,
  ) = _$SearchFilterPresetCopyWithImpl<$Res, SearchFilterPreset>;
  @useResult
  $Res call({
    String id,
    String name,
    List<SearchFilter> filters,
    String? description,
    String? iconUrl,
    bool isDefault,
    DateTime? createdAt,
    DateTime? lastUsed,
  });
}

/// @nodoc
class _$SearchFilterPresetCopyWithImpl<$Res, $Val extends SearchFilterPreset>
    implements $SearchFilterPresetCopyWith<$Res> {
  _$SearchFilterPresetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchFilterPreset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? filters = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? isDefault = null,
    Object? createdAt = freezed,
    Object? lastUsed = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            filters: null == filters
                ? _value.filters
                : filters // ignore: cast_nullable_to_non_nullable
                      as List<SearchFilter>,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            isDefault: null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastUsed: freezed == lastUsed
                ? _value.lastUsed
                : lastUsed // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchFilterPresetImplCopyWith<$Res>
    implements $SearchFilterPresetCopyWith<$Res> {
  factory _$$SearchFilterPresetImplCopyWith(
    _$SearchFilterPresetImpl value,
    $Res Function(_$SearchFilterPresetImpl) then,
  ) = __$$SearchFilterPresetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    List<SearchFilter> filters,
    String? description,
    String? iconUrl,
    bool isDefault,
    DateTime? createdAt,
    DateTime? lastUsed,
  });
}

/// @nodoc
class __$$SearchFilterPresetImplCopyWithImpl<$Res>
    extends _$SearchFilterPresetCopyWithImpl<$Res, _$SearchFilterPresetImpl>
    implements _$$SearchFilterPresetImplCopyWith<$Res> {
  __$$SearchFilterPresetImplCopyWithImpl(
    _$SearchFilterPresetImpl _value,
    $Res Function(_$SearchFilterPresetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchFilterPreset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? filters = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? isDefault = null,
    Object? createdAt = freezed,
    Object? lastUsed = freezed,
  }) {
    return _then(
      _$SearchFilterPresetImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        filters: null == filters
            ? _value._filters
            : filters // ignore: cast_nullable_to_non_nullable
                  as List<SearchFilter>,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        isDefault: null == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastUsed: freezed == lastUsed
            ? _value.lastUsed
            : lastUsed // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchFilterPresetImpl implements _SearchFilterPreset {
  const _$SearchFilterPresetImpl({
    required this.id,
    required this.name,
    required final List<SearchFilter> filters,
    this.description,
    this.iconUrl,
    this.isDefault = false,
    this.createdAt,
    this.lastUsed,
  }) : _filters = filters;

  factory _$SearchFilterPresetImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchFilterPresetImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final List<SearchFilter> _filters;
  @override
  List<SearchFilter> get filters {
    if (_filters is EqualUnmodifiableListView) return _filters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filters);
  }

  @override
  final String? description;
  @override
  final String? iconUrl;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? lastUsed;

  @override
  String toString() {
    return 'SearchFilterPreset(id: $id, name: $name, filters: $filters, description: $description, iconUrl: $iconUrl, isDefault: $isDefault, createdAt: $createdAt, lastUsed: $lastUsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchFilterPresetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._filters, _filters) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastUsed, lastUsed) ||
                other.lastUsed == lastUsed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    const DeepCollectionEquality().hash(_filters),
    description,
    iconUrl,
    isDefault,
    createdAt,
    lastUsed,
  );

  /// Create a copy of SearchFilterPreset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchFilterPresetImplCopyWith<_$SearchFilterPresetImpl> get copyWith =>
      __$$SearchFilterPresetImplCopyWithImpl<_$SearchFilterPresetImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchFilterPresetImplToJson(this);
  }
}

abstract class _SearchFilterPreset implements SearchFilterPreset {
  const factory _SearchFilterPreset({
    required final String id,
    required final String name,
    required final List<SearchFilter> filters,
    final String? description,
    final String? iconUrl,
    final bool isDefault,
    final DateTime? createdAt,
    final DateTime? lastUsed,
  }) = _$SearchFilterPresetImpl;

  factory _SearchFilterPreset.fromJson(Map<String, dynamic> json) =
      _$SearchFilterPresetImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  List<SearchFilter> get filters;
  @override
  String? get description;
  @override
  String? get iconUrl;
  @override
  bool get isDefault;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get lastUsed;

  /// Create a copy of SearchFilterPreset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchFilterPresetImplCopyWith<_$SearchFilterPresetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
