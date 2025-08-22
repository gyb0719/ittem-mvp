// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;
  bool get isVerified =>
      throw _privateConstructorUsedError; // Enhanced verification fields
  bool get isPhoneVerified => throw _privateConstructorUsedError;
  bool get isEmailVerified => throw _privateConstructorUsedError;
  bool get isIdVerified => throw _privateConstructorUsedError;
  bool get isAddressVerified => throw _privateConstructorUsedError;
  bool get isBankAccountVerified =>
      throw _privateConstructorUsedError; // Trust system fields
  int get trustScore => throw _privateConstructorUsedError;
  String get trustLevel =>
      throw _privateConstructorUsedError; // bronze, silver, gold, platinum
  int get reportCount => throw _privateConstructorUsedError;
  bool get isBlocked => throw _privateConstructorUsedError;
  bool get isPremiumMember =>
      throw _privateConstructorUsedError; // Safety and privacy settings
  bool get allowDirectContact => throw _privateConstructorUsedError;
  bool get showExactLocation => throw _privateConstructorUsedError;
  bool get allowRatingDisplay => throw _privateConstructorUsedError;
  List<String> get blockedUsers =>
      throw _privateConstructorUsedError; // Activity tracking
  int get successfulTransactions => throw _privateConstructorUsedError;
  int get cancelledTransactions => throw _privateConstructorUsedError;
  int get reviewsReceived => throw _privateConstructorUsedError;
  int get reviewsGiven => throw _privateConstructorUsedError;
  DateTime? get lastVerificationDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    String id,
    String email,
    String name,
    String? profileImageUrl,
    String? phoneNumber,
    String? bio,
    String location,
    double rating,
    int transactionCount,
    bool isVerified,
    bool isPhoneVerified,
    bool isEmailVerified,
    bool isIdVerified,
    bool isAddressVerified,
    bool isBankAccountVerified,
    int trustScore,
    String trustLevel,
    int reportCount,
    bool isBlocked,
    bool isPremiumMember,
    bool allowDirectContact,
    bool showExactLocation,
    bool allowRatingDisplay,
    List<String> blockedUsers,
    int successfulTransactions,
    int cancelledTransactions,
    int reviewsReceived,
    int reviewsGiven,
    DateTime? lastVerificationDate,
    DateTime createdAt,
    DateTime? lastLoginAt,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? profileImageUrl = freezed,
    Object? phoneNumber = freezed,
    Object? bio = freezed,
    Object? location = null,
    Object? rating = null,
    Object? transactionCount = null,
    Object? isVerified = null,
    Object? isPhoneVerified = null,
    Object? isEmailVerified = null,
    Object? isIdVerified = null,
    Object? isAddressVerified = null,
    Object? isBankAccountVerified = null,
    Object? trustScore = null,
    Object? trustLevel = null,
    Object? reportCount = null,
    Object? isBlocked = null,
    Object? isPremiumMember = null,
    Object? allowDirectContact = null,
    Object? showExactLocation = null,
    Object? allowRatingDisplay = null,
    Object? blockedUsers = null,
    Object? successfulTransactions = null,
    Object? cancelledTransactions = null,
    Object? reviewsReceived = null,
    Object? reviewsGiven = null,
    Object? lastVerificationDate = freezed,
    Object? createdAt = null,
    Object? lastLoginAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            profileImageUrl: freezed == profileImageUrl
                ? _value.profileImageUrl
                : profileImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            phoneNumber: freezed == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            transactionCount: null == transactionCount
                ? _value.transactionCount
                : transactionCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isVerified: null == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPhoneVerified: null == isPhoneVerified
                ? _value.isPhoneVerified
                : isPhoneVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            isEmailVerified: null == isEmailVerified
                ? _value.isEmailVerified
                : isEmailVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            isIdVerified: null == isIdVerified
                ? _value.isIdVerified
                : isIdVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            isAddressVerified: null == isAddressVerified
                ? _value.isAddressVerified
                : isAddressVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            isBankAccountVerified: null == isBankAccountVerified
                ? _value.isBankAccountVerified
                : isBankAccountVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            trustScore: null == trustScore
                ? _value.trustScore
                : trustScore // ignore: cast_nullable_to_non_nullable
                      as int,
            trustLevel: null == trustLevel
                ? _value.trustLevel
                : trustLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            reportCount: null == reportCount
                ? _value.reportCount
                : reportCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isBlocked: null == isBlocked
                ? _value.isBlocked
                : isBlocked // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPremiumMember: null == isPremiumMember
                ? _value.isPremiumMember
                : isPremiumMember // ignore: cast_nullable_to_non_nullable
                      as bool,
            allowDirectContact: null == allowDirectContact
                ? _value.allowDirectContact
                : allowDirectContact // ignore: cast_nullable_to_non_nullable
                      as bool,
            showExactLocation: null == showExactLocation
                ? _value.showExactLocation
                : showExactLocation // ignore: cast_nullable_to_non_nullable
                      as bool,
            allowRatingDisplay: null == allowRatingDisplay
                ? _value.allowRatingDisplay
                : allowRatingDisplay // ignore: cast_nullable_to_non_nullable
                      as bool,
            blockedUsers: null == blockedUsers
                ? _value.blockedUsers
                : blockedUsers // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            successfulTransactions: null == successfulTransactions
                ? _value.successfulTransactions
                : successfulTransactions // ignore: cast_nullable_to_non_nullable
                      as int,
            cancelledTransactions: null == cancelledTransactions
                ? _value.cancelledTransactions
                : cancelledTransactions // ignore: cast_nullable_to_non_nullable
                      as int,
            reviewsReceived: null == reviewsReceived
                ? _value.reviewsReceived
                : reviewsReceived // ignore: cast_nullable_to_non_nullable
                      as int,
            reviewsGiven: null == reviewsGiven
                ? _value.reviewsGiven
                : reviewsGiven // ignore: cast_nullable_to_non_nullable
                      as int,
            lastVerificationDate: freezed == lastVerificationDate
                ? _value.lastVerificationDate
                : lastVerificationDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastLoginAt: freezed == lastLoginAt
                ? _value.lastLoginAt
                : lastLoginAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String name,
    String? profileImageUrl,
    String? phoneNumber,
    String? bio,
    String location,
    double rating,
    int transactionCount,
    bool isVerified,
    bool isPhoneVerified,
    bool isEmailVerified,
    bool isIdVerified,
    bool isAddressVerified,
    bool isBankAccountVerified,
    int trustScore,
    String trustLevel,
    int reportCount,
    bool isBlocked,
    bool isPremiumMember,
    bool allowDirectContact,
    bool showExactLocation,
    bool allowRatingDisplay,
    List<String> blockedUsers,
    int successfulTransactions,
    int cancelledTransactions,
    int reviewsReceived,
    int reviewsGiven,
    DateTime? lastVerificationDate,
    DateTime createdAt,
    DateTime? lastLoginAt,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? profileImageUrl = freezed,
    Object? phoneNumber = freezed,
    Object? bio = freezed,
    Object? location = null,
    Object? rating = null,
    Object? transactionCount = null,
    Object? isVerified = null,
    Object? isPhoneVerified = null,
    Object? isEmailVerified = null,
    Object? isIdVerified = null,
    Object? isAddressVerified = null,
    Object? isBankAccountVerified = null,
    Object? trustScore = null,
    Object? trustLevel = null,
    Object? reportCount = null,
    Object? isBlocked = null,
    Object? isPremiumMember = null,
    Object? allowDirectContact = null,
    Object? showExactLocation = null,
    Object? allowRatingDisplay = null,
    Object? blockedUsers = null,
    Object? successfulTransactions = null,
    Object? cancelledTransactions = null,
    Object? reviewsReceived = null,
    Object? reviewsGiven = null,
    Object? lastVerificationDate = freezed,
    Object? createdAt = null,
    Object? lastLoginAt = freezed,
  }) {
    return _then(
      _$UserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        profileImageUrl: freezed == profileImageUrl
            ? _value.profileImageUrl
            : profileImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        phoneNumber: freezed == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        transactionCount: null == transactionCount
            ? _value.transactionCount
            : transactionCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isVerified: null == isVerified
            ? _value.isVerified
            : isVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPhoneVerified: null == isPhoneVerified
            ? _value.isPhoneVerified
            : isPhoneVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        isEmailVerified: null == isEmailVerified
            ? _value.isEmailVerified
            : isEmailVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        isIdVerified: null == isIdVerified
            ? _value.isIdVerified
            : isIdVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        isAddressVerified: null == isAddressVerified
            ? _value.isAddressVerified
            : isAddressVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        isBankAccountVerified: null == isBankAccountVerified
            ? _value.isBankAccountVerified
            : isBankAccountVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        trustScore: null == trustScore
            ? _value.trustScore
            : trustScore // ignore: cast_nullable_to_non_nullable
                  as int,
        trustLevel: null == trustLevel
            ? _value.trustLevel
            : trustLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        reportCount: null == reportCount
            ? _value.reportCount
            : reportCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isBlocked: null == isBlocked
            ? _value.isBlocked
            : isBlocked // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPremiumMember: null == isPremiumMember
            ? _value.isPremiumMember
            : isPremiumMember // ignore: cast_nullable_to_non_nullable
                  as bool,
        allowDirectContact: null == allowDirectContact
            ? _value.allowDirectContact
            : allowDirectContact // ignore: cast_nullable_to_non_nullable
                  as bool,
        showExactLocation: null == showExactLocation
            ? _value.showExactLocation
            : showExactLocation // ignore: cast_nullable_to_non_nullable
                  as bool,
        allowRatingDisplay: null == allowRatingDisplay
            ? _value.allowRatingDisplay
            : allowRatingDisplay // ignore: cast_nullable_to_non_nullable
                  as bool,
        blockedUsers: null == blockedUsers
            ? _value._blockedUsers
            : blockedUsers // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        successfulTransactions: null == successfulTransactions
            ? _value.successfulTransactions
            : successfulTransactions // ignore: cast_nullable_to_non_nullable
                  as int,
        cancelledTransactions: null == cancelledTransactions
            ? _value.cancelledTransactions
            : cancelledTransactions // ignore: cast_nullable_to_non_nullable
                  as int,
        reviewsReceived: null == reviewsReceived
            ? _value.reviewsReceived
            : reviewsReceived // ignore: cast_nullable_to_non_nullable
                  as int,
        reviewsGiven: null == reviewsGiven
            ? _value.reviewsGiven
            : reviewsGiven // ignore: cast_nullable_to_non_nullable
                  as int,
        lastVerificationDate: freezed == lastVerificationDate
            ? _value.lastVerificationDate
            : lastVerificationDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastLoginAt: freezed == lastLoginAt
            ? _value.lastLoginAt
            : lastLoginAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    this.phoneNumber,
    this.bio,
    required this.location,
    this.rating = 0.0,
    this.transactionCount = 0,
    this.isVerified = false,
    this.isPhoneVerified = false,
    this.isEmailVerified = false,
    this.isIdVerified = false,
    this.isAddressVerified = false,
    this.isBankAccountVerified = false,
    this.trustScore = 0,
    this.trustLevel = 'bronze',
    this.reportCount = 0,
    this.isBlocked = false,
    this.isPremiumMember = false,
    this.allowDirectContact = true,
    this.showExactLocation = true,
    this.allowRatingDisplay = true,
    final List<String> blockedUsers = const [],
    this.successfulTransactions = 0,
    this.cancelledTransactions = 0,
    this.reviewsReceived = 0,
    this.reviewsGiven = 0,
    this.lastVerificationDate,
    required this.createdAt,
    this.lastLoginAt,
  }) : _blockedUsers = blockedUsers;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String name;
  @override
  final String? profileImageUrl;
  @override
  final String? phoneNumber;
  @override
  final String? bio;
  @override
  final String location;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int transactionCount;
  @override
  @JsonKey()
  final bool isVerified;
  // Enhanced verification fields
  @override
  @JsonKey()
  final bool isPhoneVerified;
  @override
  @JsonKey()
  final bool isEmailVerified;
  @override
  @JsonKey()
  final bool isIdVerified;
  @override
  @JsonKey()
  final bool isAddressVerified;
  @override
  @JsonKey()
  final bool isBankAccountVerified;
  // Trust system fields
  @override
  @JsonKey()
  final int trustScore;
  @override
  @JsonKey()
  final String trustLevel;
  // bronze, silver, gold, platinum
  @override
  @JsonKey()
  final int reportCount;
  @override
  @JsonKey()
  final bool isBlocked;
  @override
  @JsonKey()
  final bool isPremiumMember;
  // Safety and privacy settings
  @override
  @JsonKey()
  final bool allowDirectContact;
  @override
  @JsonKey()
  final bool showExactLocation;
  @override
  @JsonKey()
  final bool allowRatingDisplay;
  final List<String> _blockedUsers;
  @override
  @JsonKey()
  List<String> get blockedUsers {
    if (_blockedUsers is EqualUnmodifiableListView) return _blockedUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blockedUsers);
  }

  // Activity tracking
  @override
  @JsonKey()
  final int successfulTransactions;
  @override
  @JsonKey()
  final int cancelledTransactions;
  @override
  @JsonKey()
  final int reviewsReceived;
  @override
  @JsonKey()
  final int reviewsGiven;
  @override
  final DateTime? lastVerificationDate;
  @override
  final DateTime createdAt;
  @override
  final DateTime? lastLoginAt;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, profileImageUrl: $profileImageUrl, phoneNumber: $phoneNumber, bio: $bio, location: $location, rating: $rating, transactionCount: $transactionCount, isVerified: $isVerified, isPhoneVerified: $isPhoneVerified, isEmailVerified: $isEmailVerified, isIdVerified: $isIdVerified, isAddressVerified: $isAddressVerified, isBankAccountVerified: $isBankAccountVerified, trustScore: $trustScore, trustLevel: $trustLevel, reportCount: $reportCount, isBlocked: $isBlocked, isPremiumMember: $isPremiumMember, allowDirectContact: $allowDirectContact, showExactLocation: $showExactLocation, allowRatingDisplay: $allowRatingDisplay, blockedUsers: $blockedUsers, successfulTransactions: $successfulTransactions, cancelledTransactions: $cancelledTransactions, reviewsReceived: $reviewsReceived, reviewsGiven: $reviewsGiven, lastVerificationDate: $lastVerificationDate, createdAt: $createdAt, lastLoginAt: $lastLoginAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.isPhoneVerified, isPhoneVerified) ||
                other.isPhoneVerified == isPhoneVerified) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.isIdVerified, isIdVerified) ||
                other.isIdVerified == isIdVerified) &&
            (identical(other.isAddressVerified, isAddressVerified) ||
                other.isAddressVerified == isAddressVerified) &&
            (identical(other.isBankAccountVerified, isBankAccountVerified) ||
                other.isBankAccountVerified == isBankAccountVerified) &&
            (identical(other.trustScore, trustScore) ||
                other.trustScore == trustScore) &&
            (identical(other.trustLevel, trustLevel) ||
                other.trustLevel == trustLevel) &&
            (identical(other.reportCount, reportCount) ||
                other.reportCount == reportCount) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked) &&
            (identical(other.isPremiumMember, isPremiumMember) ||
                other.isPremiumMember == isPremiumMember) &&
            (identical(other.allowDirectContact, allowDirectContact) ||
                other.allowDirectContact == allowDirectContact) &&
            (identical(other.showExactLocation, showExactLocation) ||
                other.showExactLocation == showExactLocation) &&
            (identical(other.allowRatingDisplay, allowRatingDisplay) ||
                other.allowRatingDisplay == allowRatingDisplay) &&
            const DeepCollectionEquality().equals(
              other._blockedUsers,
              _blockedUsers,
            ) &&
            (identical(other.successfulTransactions, successfulTransactions) ||
                other.successfulTransactions == successfulTransactions) &&
            (identical(other.cancelledTransactions, cancelledTransactions) ||
                other.cancelledTransactions == cancelledTransactions) &&
            (identical(other.reviewsReceived, reviewsReceived) ||
                other.reviewsReceived == reviewsReceived) &&
            (identical(other.reviewsGiven, reviewsGiven) ||
                other.reviewsGiven == reviewsGiven) &&
            (identical(other.lastVerificationDate, lastVerificationDate) ||
                other.lastVerificationDate == lastVerificationDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    email,
    name,
    profileImageUrl,
    phoneNumber,
    bio,
    location,
    rating,
    transactionCount,
    isVerified,
    isPhoneVerified,
    isEmailVerified,
    isIdVerified,
    isAddressVerified,
    isBankAccountVerified,
    trustScore,
    trustLevel,
    reportCount,
    isBlocked,
    isPremiumMember,
    allowDirectContact,
    showExactLocation,
    allowRatingDisplay,
    const DeepCollectionEquality().hash(_blockedUsers),
    successfulTransactions,
    cancelledTransactions,
    reviewsReceived,
    reviewsGiven,
    lastVerificationDate,
    createdAt,
    lastLoginAt,
  ]);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    required final String id,
    required final String email,
    required final String name,
    final String? profileImageUrl,
    final String? phoneNumber,
    final String? bio,
    required final String location,
    final double rating,
    final int transactionCount,
    final bool isVerified,
    final bool isPhoneVerified,
    final bool isEmailVerified,
    final bool isIdVerified,
    final bool isAddressVerified,
    final bool isBankAccountVerified,
    final int trustScore,
    final String trustLevel,
    final int reportCount,
    final bool isBlocked,
    final bool isPremiumMember,
    final bool allowDirectContact,
    final bool showExactLocation,
    final bool allowRatingDisplay,
    final List<String> blockedUsers,
    final int successfulTransactions,
    final int cancelledTransactions,
    final int reviewsReceived,
    final int reviewsGiven,
    final DateTime? lastVerificationDate,
    required final DateTime createdAt,
    final DateTime? lastLoginAt,
  }) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get name;
  @override
  String? get profileImageUrl;
  @override
  String? get phoneNumber;
  @override
  String? get bio;
  @override
  String get location;
  @override
  double get rating;
  @override
  int get transactionCount;
  @override
  bool get isVerified; // Enhanced verification fields
  @override
  bool get isPhoneVerified;
  @override
  bool get isEmailVerified;
  @override
  bool get isIdVerified;
  @override
  bool get isAddressVerified;
  @override
  bool get isBankAccountVerified; // Trust system fields
  @override
  int get trustScore;
  @override
  String get trustLevel; // bronze, silver, gold, platinum
  @override
  int get reportCount;
  @override
  bool get isBlocked;
  @override
  bool get isPremiumMember; // Safety and privacy settings
  @override
  bool get allowDirectContact;
  @override
  bool get showExactLocation;
  @override
  bool get allowRatingDisplay;
  @override
  List<String> get blockedUsers; // Activity tracking
  @override
  int get successfulTransactions;
  @override
  int get cancelledTransactions;
  @override
  int get reviewsReceived;
  @override
  int get reviewsGiven;
  @override
  DateTime? get lastVerificationDate;
  @override
  DateTime get createdAt;
  @override
  DateTime? get lastLoginAt;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
