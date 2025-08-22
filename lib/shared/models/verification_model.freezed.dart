// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VerificationModel _$VerificationModelFromJson(Map<String, dynamic> json) {
  return _VerificationModel.fromJson(json);
}

/// @nodoc
mixin _$VerificationModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  VerificationType get type => throw _privateConstructorUsedError;
  VerificationStatus get status => throw _privateConstructorUsedError;
  String? get documentUrl => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  String? get verifiedBy => throw _privateConstructorUsedError;
  DateTime get submittedAt => throw _privateConstructorUsedError;
  DateTime? get verifiedAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this VerificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerificationModelCopyWith<VerificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationModelCopyWith<$Res> {
  factory $VerificationModelCopyWith(
    VerificationModel value,
    $Res Function(VerificationModel) then,
  ) = _$VerificationModelCopyWithImpl<$Res, VerificationModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    VerificationType type,
    VerificationStatus status,
    String? documentUrl,
    String? rejectionReason,
    String? verifiedBy,
    DateTime submittedAt,
    DateTime? verifiedAt,
    DateTime? expiresAt,
  });
}

/// @nodoc
class _$VerificationModelCopyWithImpl<$Res, $Val extends VerificationModel>
    implements $VerificationModelCopyWith<$Res> {
  _$VerificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? status = null,
    Object? documentUrl = freezed,
    Object? rejectionReason = freezed,
    Object? verifiedBy = freezed,
    Object? submittedAt = null,
    Object? verifiedAt = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as VerificationType,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as VerificationStatus,
            documentUrl: freezed == documentUrl
                ? _value.documentUrl
                : documentUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            rejectionReason: freezed == rejectionReason
                ? _value.rejectionReason
                : rejectionReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            verifiedBy: freezed == verifiedBy
                ? _value.verifiedBy
                : verifiedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            submittedAt: null == submittedAt
                ? _value.submittedAt
                : submittedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            verifiedAt: freezed == verifiedAt
                ? _value.verifiedAt
                : verifiedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VerificationModelImplCopyWith<$Res>
    implements $VerificationModelCopyWith<$Res> {
  factory _$$VerificationModelImplCopyWith(
    _$VerificationModelImpl value,
    $Res Function(_$VerificationModelImpl) then,
  ) = __$$VerificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    VerificationType type,
    VerificationStatus status,
    String? documentUrl,
    String? rejectionReason,
    String? verifiedBy,
    DateTime submittedAt,
    DateTime? verifiedAt,
    DateTime? expiresAt,
  });
}

/// @nodoc
class __$$VerificationModelImplCopyWithImpl<$Res>
    extends _$VerificationModelCopyWithImpl<$Res, _$VerificationModelImpl>
    implements _$$VerificationModelImplCopyWith<$Res> {
  __$$VerificationModelImplCopyWithImpl(
    _$VerificationModelImpl _value,
    $Res Function(_$VerificationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? status = null,
    Object? documentUrl = freezed,
    Object? rejectionReason = freezed,
    Object? verifiedBy = freezed,
    Object? submittedAt = null,
    Object? verifiedAt = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _$VerificationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as VerificationType,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as VerificationStatus,
        documentUrl: freezed == documentUrl
            ? _value.documentUrl
            : documentUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        rejectionReason: freezed == rejectionReason
            ? _value.rejectionReason
            : rejectionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        verifiedBy: freezed == verifiedBy
            ? _value.verifiedBy
            : verifiedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        submittedAt: null == submittedAt
            ? _value.submittedAt
            : submittedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        verifiedAt: freezed == verifiedAt
            ? _value.verifiedAt
            : verifiedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationModelImpl implements _VerificationModel {
  const _$VerificationModelImpl({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    this.documentUrl,
    this.rejectionReason,
    this.verifiedBy,
    required this.submittedAt,
    this.verifiedAt,
    this.expiresAt,
  });

  factory _$VerificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final VerificationType type;
  @override
  final VerificationStatus status;
  @override
  final String? documentUrl;
  @override
  final String? rejectionReason;
  @override
  final String? verifiedBy;
  @override
  final DateTime submittedAt;
  @override
  final DateTime? verifiedAt;
  @override
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'VerificationModel(id: $id, userId: $userId, type: $type, status: $status, documentUrl: $documentUrl, rejectionReason: $rejectionReason, verifiedBy: $verifiedBy, submittedAt: $submittedAt, verifiedAt: $verifiedAt, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.documentUrl, documentUrl) ||
                other.documentUrl == documentUrl) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.verifiedBy, verifiedBy) ||
                other.verifiedBy == verifiedBy) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    type,
    status,
    documentUrl,
    rejectionReason,
    verifiedBy,
    submittedAt,
    verifiedAt,
    expiresAt,
  );

  /// Create a copy of VerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationModelImplCopyWith<_$VerificationModelImpl> get copyWith =>
      __$$VerificationModelImplCopyWithImpl<_$VerificationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationModelImplToJson(this);
  }
}

abstract class _VerificationModel implements VerificationModel {
  const factory _VerificationModel({
    required final String id,
    required final String userId,
    required final VerificationType type,
    required final VerificationStatus status,
    final String? documentUrl,
    final String? rejectionReason,
    final String? verifiedBy,
    required final DateTime submittedAt,
    final DateTime? verifiedAt,
    final DateTime? expiresAt,
  }) = _$VerificationModelImpl;

  factory _VerificationModel.fromJson(Map<String, dynamic> json) =
      _$VerificationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  VerificationType get type;
  @override
  VerificationStatus get status;
  @override
  String? get documentUrl;
  @override
  String? get rejectionReason;
  @override
  String? get verifiedBy;
  @override
  DateTime get submittedAt;
  @override
  DateTime? get verifiedAt;
  @override
  DateTime? get expiresAt;

  /// Create a copy of VerificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerificationModelImplCopyWith<_$VerificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) {
  return _ReportModel.fromJson(json);
}

/// @nodoc
mixin _$ReportModel {
  String get id => throw _privateConstructorUsedError;
  String get reporterId => throw _privateConstructorUsedError;
  String get reportedUserId => throw _privateConstructorUsedError;
  String? get itemId => throw _privateConstructorUsedError;
  String? get chatId => throw _privateConstructorUsedError;
  ReportCategory get category => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String>? get evidenceUrls => throw _privateConstructorUsedError;
  ReportStatus get status => throw _privateConstructorUsedError;
  String? get adminNotes => throw _privateConstructorUsedError;
  String? get resolution => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;

  /// Serializes this ReportModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportModelCopyWith<ReportModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportModelCopyWith<$Res> {
  factory $ReportModelCopyWith(
    ReportModel value,
    $Res Function(ReportModel) then,
  ) = _$ReportModelCopyWithImpl<$Res, ReportModel>;
  @useResult
  $Res call({
    String id,
    String reporterId,
    String reportedUserId,
    String? itemId,
    String? chatId,
    ReportCategory category,
    String description,
    List<String>? evidenceUrls,
    ReportStatus status,
    String? adminNotes,
    String? resolution,
    DateTime createdAt,
    DateTime? resolvedAt,
  });
}

/// @nodoc
class _$ReportModelCopyWithImpl<$Res, $Val extends ReportModel>
    implements $ReportModelCopyWith<$Res> {
  _$ReportModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reporterId = null,
    Object? reportedUserId = null,
    Object? itemId = freezed,
    Object? chatId = freezed,
    Object? category = null,
    Object? description = null,
    Object? evidenceUrls = freezed,
    Object? status = null,
    Object? adminNotes = freezed,
    Object? resolution = freezed,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            reporterId: null == reporterId
                ? _value.reporterId
                : reporterId // ignore: cast_nullable_to_non_nullable
                      as String,
            reportedUserId: null == reportedUserId
                ? _value.reportedUserId
                : reportedUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            itemId: freezed == itemId
                ? _value.itemId
                : itemId // ignore: cast_nullable_to_non_nullable
                      as String?,
            chatId: freezed == chatId
                ? _value.chatId
                : chatId // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as ReportCategory,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            evidenceUrls: freezed == evidenceUrls
                ? _value.evidenceUrls
                : evidenceUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ReportStatus,
            adminNotes: freezed == adminNotes
                ? _value.adminNotes
                : adminNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            resolution: freezed == resolution
                ? _value.resolution
                : resolution // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            resolvedAt: freezed == resolvedAt
                ? _value.resolvedAt
                : resolvedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportModelImplCopyWith<$Res>
    implements $ReportModelCopyWith<$Res> {
  factory _$$ReportModelImplCopyWith(
    _$ReportModelImpl value,
    $Res Function(_$ReportModelImpl) then,
  ) = __$$ReportModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String reporterId,
    String reportedUserId,
    String? itemId,
    String? chatId,
    ReportCategory category,
    String description,
    List<String>? evidenceUrls,
    ReportStatus status,
    String? adminNotes,
    String? resolution,
    DateTime createdAt,
    DateTime? resolvedAt,
  });
}

/// @nodoc
class __$$ReportModelImplCopyWithImpl<$Res>
    extends _$ReportModelCopyWithImpl<$Res, _$ReportModelImpl>
    implements _$$ReportModelImplCopyWith<$Res> {
  __$$ReportModelImplCopyWithImpl(
    _$ReportModelImpl _value,
    $Res Function(_$ReportModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reporterId = null,
    Object? reportedUserId = null,
    Object? itemId = freezed,
    Object? chatId = freezed,
    Object? category = null,
    Object? description = null,
    Object? evidenceUrls = freezed,
    Object? status = null,
    Object? adminNotes = freezed,
    Object? resolution = freezed,
    Object? createdAt = null,
    Object? resolvedAt = freezed,
  }) {
    return _then(
      _$ReportModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reporterId: null == reporterId
            ? _value.reporterId
            : reporterId // ignore: cast_nullable_to_non_nullable
                  as String,
        reportedUserId: null == reportedUserId
            ? _value.reportedUserId
            : reportedUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        itemId: freezed == itemId
            ? _value.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        chatId: freezed == chatId
            ? _value.chatId
            : chatId // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as ReportCategory,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        evidenceUrls: freezed == evidenceUrls
            ? _value._evidenceUrls
            : evidenceUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ReportStatus,
        adminNotes: freezed == adminNotes
            ? _value.adminNotes
            : adminNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        resolution: freezed == resolution
            ? _value.resolution
            : resolution // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        resolvedAt: freezed == resolvedAt
            ? _value.resolvedAt
            : resolvedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportModelImpl implements _ReportModel {
  const _$ReportModelImpl({
    required this.id,
    required this.reporterId,
    required this.reportedUserId,
    this.itemId,
    this.chatId,
    required this.category,
    required this.description,
    final List<String>? evidenceUrls,
    required this.status,
    this.adminNotes,
    this.resolution,
    required this.createdAt,
    this.resolvedAt,
  }) : _evidenceUrls = evidenceUrls;

  factory _$ReportModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportModelImplFromJson(json);

  @override
  final String id;
  @override
  final String reporterId;
  @override
  final String reportedUserId;
  @override
  final String? itemId;
  @override
  final String? chatId;
  @override
  final ReportCategory category;
  @override
  final String description;
  final List<String>? _evidenceUrls;
  @override
  List<String>? get evidenceUrls {
    final value = _evidenceUrls;
    if (value == null) return null;
    if (_evidenceUrls is EqualUnmodifiableListView) return _evidenceUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final ReportStatus status;
  @override
  final String? adminNotes;
  @override
  final String? resolution;
  @override
  final DateTime createdAt;
  @override
  final DateTime? resolvedAt;

  @override
  String toString() {
    return 'ReportModel(id: $id, reporterId: $reporterId, reportedUserId: $reportedUserId, itemId: $itemId, chatId: $chatId, category: $category, description: $description, evidenceUrls: $evidenceUrls, status: $status, adminNotes: $adminNotes, resolution: $resolution, createdAt: $createdAt, resolvedAt: $resolvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reporterId, reporterId) ||
                other.reporterId == reporterId) &&
            (identical(other.reportedUserId, reportedUserId) ||
                other.reportedUserId == reportedUserId) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._evidenceUrls,
              _evidenceUrls,
            ) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.adminNotes, adminNotes) ||
                other.adminNotes == adminNotes) &&
            (identical(other.resolution, resolution) ||
                other.resolution == resolution) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    reporterId,
    reportedUserId,
    itemId,
    chatId,
    category,
    description,
    const DeepCollectionEquality().hash(_evidenceUrls),
    status,
    adminNotes,
    resolution,
    createdAt,
    resolvedAt,
  );

  /// Create a copy of ReportModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportModelImplCopyWith<_$ReportModelImpl> get copyWith =>
      __$$ReportModelImplCopyWithImpl<_$ReportModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportModelImplToJson(this);
  }
}

abstract class _ReportModel implements ReportModel {
  const factory _ReportModel({
    required final String id,
    required final String reporterId,
    required final String reportedUserId,
    final String? itemId,
    final String? chatId,
    required final ReportCategory category,
    required final String description,
    final List<String>? evidenceUrls,
    required final ReportStatus status,
    final String? adminNotes,
    final String? resolution,
    required final DateTime createdAt,
    final DateTime? resolvedAt,
  }) = _$ReportModelImpl;

  factory _ReportModel.fromJson(Map<String, dynamic> json) =
      _$ReportModelImpl.fromJson;

  @override
  String get id;
  @override
  String get reporterId;
  @override
  String get reportedUserId;
  @override
  String? get itemId;
  @override
  String? get chatId;
  @override
  ReportCategory get category;
  @override
  String get description;
  @override
  List<String>? get evidenceUrls;
  @override
  ReportStatus get status;
  @override
  String? get adminNotes;
  @override
  String? get resolution;
  @override
  DateTime get createdAt;
  @override
  DateTime? get resolvedAt;

  /// Create a copy of ReportModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportModelImplCopyWith<_$ReportModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SafetyTipModel _$SafetyTipModelFromJson(Map<String, dynamic> json) {
  return _SafetyTipModel.fromJson(json);
}

/// @nodoc
mixin _$SafetyTipModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  SafetyCategory get category => throw _privateConstructorUsedError;
  String? get iconName => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SafetyTipModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SafetyTipModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SafetyTipModelCopyWith<SafetyTipModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SafetyTipModelCopyWith<$Res> {
  factory $SafetyTipModelCopyWith(
    SafetyTipModel value,
    $Res Function(SafetyTipModel) then,
  ) = _$SafetyTipModelCopyWithImpl<$Res, SafetyTipModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    SafetyCategory category,
    String? iconName,
    int priority,
    bool isActive,
    DateTime createdAt,
  });
}

/// @nodoc
class _$SafetyTipModelCopyWithImpl<$Res, $Val extends SafetyTipModel>
    implements $SafetyTipModelCopyWith<$Res> {
  _$SafetyTipModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SafetyTipModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? iconName = freezed,
    Object? priority = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as SafetyCategory,
            iconName: freezed == iconName
                ? _value.iconName
                : iconName // ignore: cast_nullable_to_non_nullable
                      as String?,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SafetyTipModelImplCopyWith<$Res>
    implements $SafetyTipModelCopyWith<$Res> {
  factory _$$SafetyTipModelImplCopyWith(
    _$SafetyTipModelImpl value,
    $Res Function(_$SafetyTipModelImpl) then,
  ) = __$$SafetyTipModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    SafetyCategory category,
    String? iconName,
    int priority,
    bool isActive,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$SafetyTipModelImplCopyWithImpl<$Res>
    extends _$SafetyTipModelCopyWithImpl<$Res, _$SafetyTipModelImpl>
    implements _$$SafetyTipModelImplCopyWith<$Res> {
  __$$SafetyTipModelImplCopyWithImpl(
    _$SafetyTipModelImpl _value,
    $Res Function(_$SafetyTipModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SafetyTipModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? iconName = freezed,
    Object? priority = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$SafetyTipModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as SafetyCategory,
        iconName: freezed == iconName
            ? _value.iconName
            : iconName // ignore: cast_nullable_to_non_nullable
                  as String?,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SafetyTipModelImpl implements _SafetyTipModel {
  const _$SafetyTipModelImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.iconName,
    required this.priority,
    required this.isActive,
    required this.createdAt,
  });

  factory _$SafetyTipModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SafetyTipModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final SafetyCategory category;
  @override
  final String? iconName;
  @override
  final int priority;
  @override
  final bool isActive;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'SafetyTipModel(id: $id, title: $title, description: $description, category: $category, iconName: $iconName, priority: $priority, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SafetyTipModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    category,
    iconName,
    priority,
    isActive,
    createdAt,
  );

  /// Create a copy of SafetyTipModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SafetyTipModelImplCopyWith<_$SafetyTipModelImpl> get copyWith =>
      __$$SafetyTipModelImplCopyWithImpl<_$SafetyTipModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SafetyTipModelImplToJson(this);
  }
}

abstract class _SafetyTipModel implements SafetyTipModel {
  const factory _SafetyTipModel({
    required final String id,
    required final String title,
    required final String description,
    required final SafetyCategory category,
    final String? iconName,
    required final int priority,
    required final bool isActive,
    required final DateTime createdAt,
  }) = _$SafetyTipModelImpl;

  factory _SafetyTipModel.fromJson(Map<String, dynamic> json) =
      _$SafetyTipModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  SafetyCategory get category;
  @override
  String? get iconName;
  @override
  int get priority;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;

  /// Create a copy of SafetyTipModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SafetyTipModelImplCopyWith<_$SafetyTipModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrustBadgeModel _$TrustBadgeModelFromJson(Map<String, dynamic> json) {
  return _TrustBadgeModel.fromJson(json);
}

/// @nodoc
mixin _$TrustBadgeModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get iconName => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  BadgeType get type => throw _privateConstructorUsedError;
  Map<String, dynamic> get requirements => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this TrustBadgeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrustBadgeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrustBadgeModelCopyWith<TrustBadgeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrustBadgeModelCopyWith<$Res> {
  factory $TrustBadgeModelCopyWith(
    TrustBadgeModel value,
    $Res Function(TrustBadgeModel) then,
  ) = _$TrustBadgeModelCopyWithImpl<$Res, TrustBadgeModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String iconName,
    String color,
    BadgeType type,
    Map<String, dynamic> requirements,
    int priority,
    bool isActive,
  });
}

/// @nodoc
class _$TrustBadgeModelCopyWithImpl<$Res, $Val extends TrustBadgeModel>
    implements $TrustBadgeModelCopyWith<$Res> {
  _$TrustBadgeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrustBadgeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? iconName = null,
    Object? color = null,
    Object? type = null,
    Object? requirements = null,
    Object? priority = null,
    Object? isActive = null,
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
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            iconName: null == iconName
                ? _value.iconName
                : iconName // ignore: cast_nullable_to_non_nullable
                      as String,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as BadgeType,
            requirements: null == requirements
                ? _value.requirements
                : requirements // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TrustBadgeModelImplCopyWith<$Res>
    implements $TrustBadgeModelCopyWith<$Res> {
  factory _$$TrustBadgeModelImplCopyWith(
    _$TrustBadgeModelImpl value,
    $Res Function(_$TrustBadgeModelImpl) then,
  ) = __$$TrustBadgeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String iconName,
    String color,
    BadgeType type,
    Map<String, dynamic> requirements,
    int priority,
    bool isActive,
  });
}

/// @nodoc
class __$$TrustBadgeModelImplCopyWithImpl<$Res>
    extends _$TrustBadgeModelCopyWithImpl<$Res, _$TrustBadgeModelImpl>
    implements _$$TrustBadgeModelImplCopyWith<$Res> {
  __$$TrustBadgeModelImplCopyWithImpl(
    _$TrustBadgeModelImpl _value,
    $Res Function(_$TrustBadgeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrustBadgeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? iconName = null,
    Object? color = null,
    Object? type = null,
    Object? requirements = null,
    Object? priority = null,
    Object? isActive = null,
  }) {
    return _then(
      _$TrustBadgeModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        iconName: null == iconName
            ? _value.iconName
            : iconName // ignore: cast_nullable_to_non_nullable
                  as String,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as BadgeType,
        requirements: null == requirements
            ? _value._requirements
            : requirements // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TrustBadgeModelImpl implements _TrustBadgeModel {
  const _$TrustBadgeModelImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.color,
    required this.type,
    required final Map<String, dynamic> requirements,
    required this.priority,
    required this.isActive,
  }) : _requirements = requirements;

  factory _$TrustBadgeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrustBadgeModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String iconName;
  @override
  final String color;
  @override
  final BadgeType type;
  final Map<String, dynamic> _requirements;
  @override
  Map<String, dynamic> get requirements {
    if (_requirements is EqualUnmodifiableMapView) return _requirements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_requirements);
  }

  @override
  final int priority;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'TrustBadgeModel(id: $id, name: $name, description: $description, iconName: $iconName, color: $color, type: $type, requirements: $requirements, priority: $priority, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrustBadgeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(
              other._requirements,
              _requirements,
            ) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    iconName,
    color,
    type,
    const DeepCollectionEquality().hash(_requirements),
    priority,
    isActive,
  );

  /// Create a copy of TrustBadgeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrustBadgeModelImplCopyWith<_$TrustBadgeModelImpl> get copyWith =>
      __$$TrustBadgeModelImplCopyWithImpl<_$TrustBadgeModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TrustBadgeModelImplToJson(this);
  }
}

abstract class _TrustBadgeModel implements TrustBadgeModel {
  const factory _TrustBadgeModel({
    required final String id,
    required final String name,
    required final String description,
    required final String iconName,
    required final String color,
    required final BadgeType type,
    required final Map<String, dynamic> requirements,
    required final int priority,
    required final bool isActive,
  }) = _$TrustBadgeModelImpl;

  factory _TrustBadgeModel.fromJson(Map<String, dynamic> json) =
      _$TrustBadgeModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get iconName;
  @override
  String get color;
  @override
  BadgeType get type;
  @override
  Map<String, dynamic> get requirements;
  @override
  int get priority;
  @override
  bool get isActive;

  /// Create a copy of TrustBadgeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrustBadgeModelImplCopyWith<_$TrustBadgeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
