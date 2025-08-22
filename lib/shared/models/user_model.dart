import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    String? profileImageUrl,
    String? phoneNumber,
    String? bio,
    required String location,
    @Default(0.0) double rating,
    @Default(0) int transactionCount,
    @Default(false) bool isVerified,
    
    // Enhanced verification fields
    @Default(false) bool isPhoneVerified,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isIdVerified,
    @Default(false) bool isAddressVerified,
    @Default(false) bool isBankAccountVerified,
    
    // Trust system fields
    @Default(0) int trustScore,
    @Default('bronze') String trustLevel, // bronze, silver, gold, platinum
    @Default(0) int reportCount,
    @Default(false) bool isBlocked,
    @Default(false) bool isPremiumMember,
    
    // Safety and privacy settings
    @Default(true) bool allowDirectContact,
    @Default(true) bool showExactLocation,
    @Default(true) bool allowRatingDisplay,
    @Default([]) List<String> blockedUsers,
    
    // Activity tracking
    @Default(0) int successfulTransactions,
    @Default(0) int cancelledTransactions,
    @Default(0) int reviewsReceived,
    @Default(0) int reviewsGiven,
    DateTime? lastVerificationDate,
    
    required DateTime createdAt,
    DateTime? lastLoginAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => 
      _$UserModelFromJson(json);
}