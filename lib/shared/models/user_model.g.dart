// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isIdVerified: json['isIdVerified'] as bool? ?? false,
      isAddressVerified: json['isAddressVerified'] as bool? ?? false,
      isBankAccountVerified: json['isBankAccountVerified'] as bool? ?? false,
      trustScore: (json['trustScore'] as num?)?.toInt() ?? 0,
      trustLevel: json['trustLevel'] as String? ?? 'bronze',
      reportCount: (json['reportCount'] as num?)?.toInt() ?? 0,
      isBlocked: json['isBlocked'] as bool? ?? false,
      isPremiumMember: json['isPremiumMember'] as bool? ?? false,
      allowDirectContact: json['allowDirectContact'] as bool? ?? true,
      showExactLocation: json['showExactLocation'] as bool? ?? true,
      allowRatingDisplay: json['allowRatingDisplay'] as bool? ?? true,
      blockedUsers:
          (json['blockedUsers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      successfulTransactions:
          (json['successfulTransactions'] as num?)?.toInt() ?? 0,
      cancelledTransactions:
          (json['cancelledTransactions'] as num?)?.toInt() ?? 0,
      reviewsReceived: (json['reviewsReceived'] as num?)?.toInt() ?? 0,
      reviewsGiven: (json['reviewsGiven'] as num?)?.toInt() ?? 0,
      lastVerificationDate: json['lastVerificationDate'] == null
          ? null
          : DateTime.parse(json['lastVerificationDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'profileImageUrl': instance.profileImageUrl,
      'phoneNumber': instance.phoneNumber,
      'bio': instance.bio,
      'location': instance.location,
      'rating': instance.rating,
      'transactionCount': instance.transactionCount,
      'isVerified': instance.isVerified,
      'isPhoneVerified': instance.isPhoneVerified,
      'isEmailVerified': instance.isEmailVerified,
      'isIdVerified': instance.isIdVerified,
      'isAddressVerified': instance.isAddressVerified,
      'isBankAccountVerified': instance.isBankAccountVerified,
      'trustScore': instance.trustScore,
      'trustLevel': instance.trustLevel,
      'reportCount': instance.reportCount,
      'isBlocked': instance.isBlocked,
      'isPremiumMember': instance.isPremiumMember,
      'allowDirectContact': instance.allowDirectContact,
      'showExactLocation': instance.showExactLocation,
      'allowRatingDisplay': instance.allowRatingDisplay,
      'blockedUsers': instance.blockedUsers,
      'successfulTransactions': instance.successfulTransactions,
      'cancelledTransactions': instance.cancelledTransactions,
      'reviewsReceived': instance.reviewsReceived,
      'reviewsGiven': instance.reviewsGiven,
      'lastVerificationDate': instance.lastVerificationDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
    };
