// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VerificationModelImpl _$$VerificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$VerificationModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  type: $enumDecode(_$VerificationTypeEnumMap, json['type']),
  status: $enumDecode(_$VerificationStatusEnumMap, json['status']),
  documentUrl: json['documentUrl'] as String?,
  rejectionReason: json['rejectionReason'] as String?,
  verifiedBy: json['verifiedBy'] as String?,
  submittedAt: DateTime.parse(json['submittedAt'] as String),
  verifiedAt: json['verifiedAt'] == null
      ? null
      : DateTime.parse(json['verifiedAt'] as String),
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$$VerificationModelImplToJson(
  _$VerificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'type': _$VerificationTypeEnumMap[instance.type]!,
  'status': _$VerificationStatusEnumMap[instance.status]!,
  'documentUrl': instance.documentUrl,
  'rejectionReason': instance.rejectionReason,
  'verifiedBy': instance.verifiedBy,
  'submittedAt': instance.submittedAt.toIso8601String(),
  'verifiedAt': instance.verifiedAt?.toIso8601String(),
  'expiresAt': instance.expiresAt?.toIso8601String(),
};

const _$VerificationTypeEnumMap = {
  VerificationType.phone: 'phone',
  VerificationType.email: 'email',
  VerificationType.identity: 'identity',
  VerificationType.address: 'address',
  VerificationType.bankAccount: 'bankAccount',
  VerificationType.faceVerification: 'faceVerification',
};

const _$VerificationStatusEnumMap = {
  VerificationStatus.pending: 'pending',
  VerificationStatus.approved: 'approved',
  VerificationStatus.rejected: 'rejected',
  VerificationStatus.expired: 'expired',
  VerificationStatus.inReview: 'inReview',
};

_$ReportModelImpl _$$ReportModelImplFromJson(Map<String, dynamic> json) =>
    _$ReportModelImpl(
      id: json['id'] as String,
      reporterId: json['reporterId'] as String,
      reportedUserId: json['reportedUserId'] as String,
      itemId: json['itemId'] as String?,
      chatId: json['chatId'] as String?,
      category: $enumDecode(_$ReportCategoryEnumMap, json['category']),
      description: json['description'] as String,
      evidenceUrls: (json['evidenceUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: $enumDecode(_$ReportStatusEnumMap, json['status']),
      adminNotes: json['adminNotes'] as String?,
      resolution: json['resolution'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
    );

Map<String, dynamic> _$$ReportModelImplToJson(_$ReportModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reporterId': instance.reporterId,
      'reportedUserId': instance.reportedUserId,
      'itemId': instance.itemId,
      'chatId': instance.chatId,
      'category': _$ReportCategoryEnumMap[instance.category]!,
      'description': instance.description,
      'evidenceUrls': instance.evidenceUrls,
      'status': _$ReportStatusEnumMap[instance.status]!,
      'adminNotes': instance.adminNotes,
      'resolution': instance.resolution,
      'createdAt': instance.createdAt.toIso8601String(),
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
    };

const _$ReportCategoryEnumMap = {
  ReportCategory.scam: 'scam',
  ReportCategory.inappropriateBehavior: 'inappropriateBehavior',
  ReportCategory.fakeProfile: 'fakeProfile',
  ReportCategory.spamming: 'spamming',
  ReportCategory.harassment: 'harassment',
  ReportCategory.violentThreat: 'violentThreat',
  ReportCategory.inappropriateContent: 'inappropriateContent',
  ReportCategory.itemMisrepresentation: 'itemMisrepresentation',
  ReportCategory.paymentIssue: 'paymentIssue',
  ReportCategory.noShow: 'noShow',
  ReportCategory.other: 'other',
};

const _$ReportStatusEnumMap = {
  ReportStatus.pending: 'pending',
  ReportStatus.investigating: 'investigating',
  ReportStatus.resolved: 'resolved',
  ReportStatus.dismissed: 'dismissed',
  ReportStatus.actionTaken: 'actionTaken',
};

_$SafetyTipModelImpl _$$SafetyTipModelImplFromJson(Map<String, dynamic> json) =>
    _$SafetyTipModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: $enumDecode(_$SafetyCategoryEnumMap, json['category']),
      iconName: json['iconName'] as String?,
      priority: (json['priority'] as num).toInt(),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SafetyTipModelImplToJson(
  _$SafetyTipModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'category': _$SafetyCategoryEnumMap[instance.category]!,
  'iconName': instance.iconName,
  'priority': instance.priority,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$SafetyCategoryEnumMap = {
  SafetyCategory.meeting: 'meeting',
  SafetyCategory.payment: 'payment',
  SafetyCategory.communication: 'communication',
  SafetyCategory.verification: 'verification',
  SafetyCategory.general: 'general',
};

_$TrustBadgeModelImpl _$$TrustBadgeModelImplFromJson(
  Map<String, dynamic> json,
) => _$TrustBadgeModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  iconName: json['iconName'] as String,
  color: json['color'] as String,
  type: $enumDecode(_$BadgeTypeEnumMap, json['type']),
  requirements: json['requirements'] as Map<String, dynamic>,
  priority: (json['priority'] as num).toInt(),
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$$TrustBadgeModelImplToJson(
  _$TrustBadgeModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'iconName': instance.iconName,
  'color': instance.color,
  'type': _$BadgeTypeEnumMap[instance.type]!,
  'requirements': instance.requirements,
  'priority': instance.priority,
  'isActive': instance.isActive,
};

const _$BadgeTypeEnumMap = {
  BadgeType.verification: 'verification',
  BadgeType.activity: 'activity',
  BadgeType.rating: 'rating',
  BadgeType.loyalty: 'loyalty',
  BadgeType.premium: 'premium',
};
