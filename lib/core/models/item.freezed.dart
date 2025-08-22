// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Item _$ItemFromJson(Map<String, dynamic> json) {
  return _Item.fromJson(json);
}

/// @nodoc
mixin _$Item {
  String get id => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get pricePerDay => throw _privateConstructorUsedError;
  int get deposit => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  List<String> get photos => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Item to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemCopyWith<Item> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemCopyWith<$Res> {
  factory $ItemCopyWith(Item value, $Res Function(Item) then) =
      _$ItemCopyWithImpl<$Res, Item>;
  @useResult
  $Res call({
    String id,
    String ownerId,
    String title,
    String description,
    int pricePerDay,
    int deposit,
    double lat,
    double lng,
    List<String> photos,
    String status,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$ItemCopyWithImpl<$Res, $Val extends Item>
    implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? title = null,
    Object? description = null,
    Object? pricePerDay = null,
    Object? deposit = null,
    Object? lat = null,
    Object? lng = null,
    Object? photos = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            pricePerDay: null == pricePerDay
                ? _value.pricePerDay
                : pricePerDay // ignore: cast_nullable_to_non_nullable
                      as int,
            deposit: null == deposit
                ? _value.deposit
                : deposit // ignore: cast_nullable_to_non_nullable
                      as int,
            lat: null == lat
                ? _value.lat
                : lat // ignore: cast_nullable_to_non_nullable
                      as double,
            lng: null == lng
                ? _value.lng
                : lng // ignore: cast_nullable_to_non_nullable
                      as double,
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ItemImplCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$$ItemImplCopyWith(
    _$ItemImpl value,
    $Res Function(_$ItemImpl) then,
  ) = __$$ItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String ownerId,
    String title,
    String description,
    int pricePerDay,
    int deposit,
    double lat,
    double lng,
    List<String> photos,
    String status,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ItemImplCopyWithImpl<$Res>
    extends _$ItemCopyWithImpl<$Res, _$ItemImpl>
    implements _$$ItemImplCopyWith<$Res> {
  __$$ItemImplCopyWithImpl(_$ItemImpl _value, $Res Function(_$ItemImpl) _then)
    : super(_value, _then);

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? title = null,
    Object? description = null,
    Object? pricePerDay = null,
    Object? deposit = null,
    Object? lat = null,
    Object? lng = null,
    Object? photos = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        pricePerDay: null == pricePerDay
            ? _value.pricePerDay
            : pricePerDay // ignore: cast_nullable_to_non_nullable
                  as int,
        deposit: null == deposit
            ? _value.deposit
            : deposit // ignore: cast_nullable_to_non_nullable
                  as int,
        lat: null == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double,
        lng: null == lng
            ? _value.lng
            : lng // ignore: cast_nullable_to_non_nullable
                  as double,
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemImpl implements _Item {
  const _$ItemImpl({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.pricePerDay,
    required this.deposit,
    required this.lat,
    required this.lng,
    final List<String> photos = const [],
    this.status = 'available',
    required this.createdAt,
    this.updatedAt,
  }) : _photos = photos;

  factory _$ItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemImplFromJson(json);

  @override
  final String id;
  @override
  final String ownerId;
  @override
  final String title;
  @override
  final String description;
  @override
  final int pricePerDay;
  @override
  final int deposit;
  @override
  final double lat;
  @override
  final double lng;
  final List<String> _photos;
  @override
  @JsonKey()
  List<String> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  @JsonKey()
  final String status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Item(id: $id, ownerId: $ownerId, title: $title, description: $description, pricePerDay: $pricePerDay, deposit: $deposit, lat: $lat, lng: $lng, photos: $photos, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.pricePerDay, pricePerDay) ||
                other.pricePerDay == pricePerDay) &&
            (identical(other.deposit, deposit) || other.deposit == deposit) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    ownerId,
    title,
    description,
    pricePerDay,
    deposit,
    lat,
    lng,
    const DeepCollectionEquality().hash(_photos),
    status,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemImplCopyWith<_$ItemImpl> get copyWith =>
      __$$ItemImplCopyWithImpl<_$ItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemImplToJson(this);
  }
}

abstract class _Item implements Item {
  const factory _Item({
    required final String id,
    required final String ownerId,
    required final String title,
    required final String description,
    required final int pricePerDay,
    required final int deposit,
    required final double lat,
    required final double lng,
    final List<String> photos,
    final String status,
    required final DateTime createdAt,
    final DateTime? updatedAt,
  }) = _$ItemImpl;

  factory _Item.fromJson(Map<String, dynamic> json) = _$ItemImpl.fromJson;

  @override
  String get id;
  @override
  String get ownerId;
  @override
  String get title;
  @override
  String get description;
  @override
  int get pricePerDay;
  @override
  int get deposit;
  @override
  double get lat;
  @override
  double get lng;
  @override
  List<String> get photos;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Item
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemImplCopyWith<_$ItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ItemCluster {
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  List<Item> get items => throw _privateConstructorUsedError;

  /// Create a copy of ItemCluster
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemClusterCopyWith<ItemCluster> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemClusterCopyWith<$Res> {
  factory $ItemClusterCopyWith(
    ItemCluster value,
    $Res Function(ItemCluster) then,
  ) = _$ItemClusterCopyWithImpl<$Res, ItemCluster>;
  @useResult
  $Res call({double lat, double lng, int count, List<Item> items});
}

/// @nodoc
class _$ItemClusterCopyWithImpl<$Res, $Val extends ItemCluster>
    implements $ItemClusterCopyWith<$Res> {
  _$ItemClusterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemCluster
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
    Object? count = null,
    Object? items = null,
  }) {
    return _then(
      _value.copyWith(
            lat: null == lat
                ? _value.lat
                : lat // ignore: cast_nullable_to_non_nullable
                      as double,
            lng: null == lng
                ? _value.lng
                : lng // ignore: cast_nullable_to_non_nullable
                      as double,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<Item>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ItemClusterImplCopyWith<$Res>
    implements $ItemClusterCopyWith<$Res> {
  factory _$$ItemClusterImplCopyWith(
    _$ItemClusterImpl value,
    $Res Function(_$ItemClusterImpl) then,
  ) = __$$ItemClusterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double lat, double lng, int count, List<Item> items});
}

/// @nodoc
class __$$ItemClusterImplCopyWithImpl<$Res>
    extends _$ItemClusterCopyWithImpl<$Res, _$ItemClusterImpl>
    implements _$$ItemClusterImplCopyWith<$Res> {
  __$$ItemClusterImplCopyWithImpl(
    _$ItemClusterImpl _value,
    $Res Function(_$ItemClusterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ItemCluster
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
    Object? count = null,
    Object? items = null,
  }) {
    return _then(
      _$ItemClusterImpl(
        lat: null == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double,
        lng: null == lng
            ? _value.lng
            : lng // ignore: cast_nullable_to_non_nullable
                  as double,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<Item>,
      ),
    );
  }
}

/// @nodoc

class _$ItemClusterImpl implements _ItemCluster {
  const _$ItemClusterImpl({
    required this.lat,
    required this.lng,
    required this.count,
    required final List<Item> items,
  }) : _items = items;

  @override
  final double lat;
  @override
  final double lng;
  @override
  final int count;
  final List<Item> _items;
  @override
  List<Item> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'ItemCluster(lat: $lat, lng: $lng, count: $count, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemClusterImpl &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    lat,
    lng,
    count,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of ItemCluster
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemClusterImplCopyWith<_$ItemClusterImpl> get copyWith =>
      __$$ItemClusterImplCopyWithImpl<_$ItemClusterImpl>(this, _$identity);
}

abstract class _ItemCluster implements ItemCluster {
  const factory _ItemCluster({
    required final double lat,
    required final double lng,
    required final int count,
    required final List<Item> items,
  }) = _$ItemClusterImpl;

  @override
  double get lat;
  @override
  double get lng;
  @override
  int get count;
  @override
  List<Item> get items;

  /// Create a copy of ItemCluster
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemClusterImplCopyWith<_$ItemClusterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
