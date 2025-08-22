import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_model.freezed.dart';
part 'verification_model.g.dart';

@freezed
class VerificationModel with _$VerificationModel {
  const factory VerificationModel({
    required String id,
    required String userId,
    required VerificationType type,
    required VerificationStatus status,
    String? documentUrl,
    String? rejectionReason,
    String? verifiedBy,
    required DateTime submittedAt,
    DateTime? verifiedAt,
    DateTime? expiresAt,
  }) = _VerificationModel;

  factory VerificationModel.fromJson(Map<String, dynamic> json) =>
      _$VerificationModelFromJson(json);
}

enum VerificationType {
  phone,
  email,
  identity,
  address,
  bankAccount,
  faceVerification,
}

enum VerificationStatus {
  pending,
  approved,
  rejected,
  expired,
  inReview,
}

@freezed
class ReportModel with _$ReportModel {
  const factory ReportModel({
    required String id,
    required String reporterId,
    required String reportedUserId,
    String? itemId,
    String? chatId,
    required ReportCategory category,
    required String description,
    List<String>? evidenceUrls,
    required ReportStatus status,
    String? adminNotes,
    String? resolution,
    required DateTime createdAt,
    DateTime? resolvedAt,
  }) = _ReportModel;

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);
}

enum ReportCategory {
  scam,
  inappropriateBehavior,
  fakeProfile,
  spamming,
  harassment,
  violentThreat,
  inappropriateContent,
  itemMisrepresentation,
  paymentIssue,
  noShow,
  other,
}

enum ReportStatus {
  pending,
  investigating,
  resolved,
  dismissed,
  actionTaken,
}

@freezed
class SafetyTipModel with _$SafetyTipModel {
  const factory SafetyTipModel({
    required String id,
    required String title,
    required String description,
    required SafetyCategory category,
    String? iconName,
    required int priority,
    required bool isActive,
    required DateTime createdAt,
  }) = _SafetyTipModel;

  factory SafetyTipModel.fromJson(Map<String, dynamic> json) =>
      _$SafetyTipModelFromJson(json);
}

enum SafetyCategory {
  meeting,
  payment,
  communication,
  verification,
  general,
}

@freezed
class TrustBadgeModel with _$TrustBadgeModel {
  const factory TrustBadgeModel({
    required String id,
    required String name,
    required String description,
    required String iconName,
    required String color,
    required BadgeType type,
    required Map<String, dynamic> requirements,
    required int priority,
    required bool isActive,
  }) = _TrustBadgeModel;

  factory TrustBadgeModel.fromJson(Map<String, dynamic> json) =>
      _$TrustBadgeModelFromJson(json);
}

enum BadgeType {
  verification,
  activity,
  rating,
  loyalty,
  premium,
}