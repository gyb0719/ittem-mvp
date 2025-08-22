import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../shared/models/verification_model.dart';
import '../shared/models/user_model.dart';
import '../config/env.dart';

class SafetyService {
  final SupabaseClient _client = Supabase.instance.client;

  // Verification Methods
  Future<bool> submitVerification({
    required String userId,
    required VerificationType type,
    String? documentUrl,
  }) async {
    try {
      final verificationData = {
        'user_id': userId,
        'type': type.name,
        'status': VerificationStatus.pending.name,
        'document_url': documentUrl,
        'submitted_at': DateTime.now().toIso8601String(),
      };

      await _client.from('verifications').insert(verificationData);
      return true;
    } catch (e) {
      if (Env.enableLogging) print('Submit verification error: $e');
      return false;
    }
  }

  Future<List<VerificationModel>> getUserVerifications(String userId) async {
    try {
      final response = await _client
          .from('verifications')
          .select()
          .eq('user_id', userId)
          .order('submitted_at', ascending: false);

      return (response as List)
          .map((item) => VerificationModel.fromJson(item))
          .toList();
    } catch (e) {
      if (Env.enableLogging) print('Get user verifications error: $e');
      return [];
    }
  }

  Future<bool> updateVerificationStatus({
    required String verificationId,
    required VerificationStatus status,
    String? rejectionReason,
    String? verifiedBy,
  }) async {
    try {
      final updateData = {
        'status': status.name,
        'verified_at': DateTime.now().toIso8601String(),
      };

      if (rejectionReason != null) {
        updateData['rejection_reason'] = rejectionReason;
      }
      if (verifiedBy != null) {
        updateData['verified_by'] = verifiedBy;
      }

      await _client
          .from('verifications')
          .update(updateData)
          .eq('id', verificationId);

      return true;
    } catch (e) {
      if (Env.enableLogging) print('Update verification status error: $e');
      return false;
    }
  }

  // Report and Safety Methods
  Future<bool> reportUser({
    required String reporterId,
    required String reportedUserId,
    required ReportCategory category,
    required String description,
    String? itemId,
    String? chatId,
    List<String>? evidenceUrls,
  }) async {
    try {
      final reportData = {
        'reporter_id': reporterId,
        'reported_user_id': reportedUserId,
        'category': category.name,
        'description': description,
        'status': ReportStatus.pending.name,
        'created_at': DateTime.now().toIso8601String(),
      };

      if (itemId != null) reportData['item_id'] = itemId;
      if (chatId != null) reportData['chat_id'] = chatId;
      if (evidenceUrls != null) reportData['evidence_urls'] = evidenceUrls;

      await _client.from('reports').insert(reportData);
      return true;
    } catch (e) {
      if (Env.enableLogging) print('Report user error: $e');
      return false;
    }
  }

  Future<bool> blockUser(String blockerId, String blockedUserId) async {
    try {
      await _client.from('blocked_users').insert({
        'blocker_id': blockerId,
        'blocked_user_id': blockedUserId,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Update user's blocked list
      await _updateUserBlockedList(blockerId, blockedUserId, true);
      return true;
    } catch (e) {
      if (Env.enableLogging) print('Block user error: $e');
      return false;
    }
  }

  Future<bool> unblockUser(String blockerId, String blockedUserId) async {
    try {
      await _client
          .from('blocked_users')
          .delete()
          .eq('blocker_id', blockerId)
          .eq('blocked_user_id', blockedUserId);

      await _updateUserBlockedList(blockerId, blockedUserId, false);
      return true;
    } catch (e) {
      if (Env.enableLogging) print('Unblock user error: $e');
      return false;
    }
  }

  Future<List<String>> getBlockedUsers(String userId) async {
    try {
      final response = await _client
          .from('blocked_users')
          .select('blocked_user_id')
          .eq('blocker_id', userId);

      return (response as List)
          .map((item) => item['blocked_user_id'] as String)
          .toList();
    } catch (e) {
      if (Env.enableLogging) print('Get blocked users error: $e');
      return [];
    }
  }

  // Trust Score Calculation
  Future<int> calculateTrustScore(UserModel user) async {
    int score = 0;

    // Verification bonuses
    if (user.isPhoneVerified) score += 15;
    if (user.isEmailVerified) score += 10;
    if (user.isIdVerified) score += 25;
    if (user.isAddressVerified) score += 15;
    if (user.isBankAccountVerified) score += 20;

    // Activity bonuses
    score += user.successfulTransactions * 5;
    score += (user.rating * 10).round();
    
    // Account age bonus (months * 2)
    final accountAge = DateTime.now().difference(user.createdAt).inDays / 30;
    score += (accountAge * 2).round();

    // Penalties
    score -= user.reportCount * 10;
    score -= user.cancelledTransactions * 2;

    // Ensure score is between 0 and 100
    return score.clamp(0, 100);
  }

  String getTrustLevel(int trustScore) {
    if (trustScore >= 80) return 'platinum';
    if (trustScore >= 60) return 'gold';
    if (trustScore >= 40) return 'silver';
    return 'bronze';
  }

  // Chat Safety
  bool isSuspiciousMessage(String message) {
    final suspiciousPatterns = [
      r'카톡\s*[:：]\s*\w+',
      r'카카오\s*[:：]\s*\w+',
      r'라인\s*[:：]\s*\w+',
      r'텔레그램\s*[:：]\s*\w+',
      r'010[-\s]*\d{4}[-\s]*\d{4}',
      r'휴대폰\s*번호',
      r'전화번호',
      r'연락처',
      r'직거래',
      r'만나서\s*거래',
      r'앱\s*밖에서',
      r'다른\s*곳에서',
      r'외부\s*연락',
      r'개인적으로\s*연락',
    ];

    final lowerMessage = message.toLowerCase();
    
    for (final pattern in suspiciousPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(lowerMessage)) {
        return true;
      }
    }
    
    return false;
  }

  String filterSuspiciousContent(String message) {
    final patterns = {
      r'010[-\s]*\d{4}[-\s]*\d{4}': '[전화번호 숨김]',
      r'카톡\s*[:：]\s*\w+': '[외부 연락처 숨김]',
      r'카카오\s*[:：]\s*\w+': '[외부 연락처 숨김]',
      r'라인\s*[:：]\s*\w+': '[외부 연락처 숨김]',
      r'텔레그램\s*[:：]\s*\w+': '[외부 연락처 숨김]',
    };

    String filteredMessage = message;
    patterns.forEach((pattern, replacement) {
      filteredMessage = filteredMessage.replaceAll(
        RegExp(pattern, caseSensitive: false),
        replacement,
      );
    });

    return filteredMessage;
  }

  // Safe Meeting Locations
  List<Map<String, String>> getSafeMeetingPlaces(String area) {
    // This would typically come from a database
    return [
      {
        'name': '스타벅스 ${area}점',
        'type': '카페',
        'address': '${area} 메인스트리트 123',
        'hours': '06:00 - 22:00',
        'reason': 'CCTV 완비, 사람 많음'
      },
      {
        'name': '${area} 지하철역',
        'type': '지하철역',
        'address': '${area}역 1번 출구',
        'hours': '05:30 - 24:00',
        'reason': '보안요원 상주, 접근성 좋음'
      },
      {
        'name': '${area} 구청',
        'type': '관공서',
        'address': '${area} 공무원로 456',
        'hours': '09:00 - 18:00',
        'reason': '안전한 공공장소'
      },
    ];
  }

  // Safety Tips
  List<SafetyTipModel> getSafetyTips(SafetyCategory? category) {
    final allTips = [
      SafetyTipModel(
        id: '1',
        title: '첫 거래는 공개된 장소에서',
        description: '카페, 지하철역, 대형마트 등 사람이 많고 CCTV가 있는 곳에서 만나세요.',
        category: SafetyCategory.meeting,
        iconName: 'location_on',
        priority: 1,
        isActive: true,
        createdAt: DateTime.now(),
      ),
      SafetyTipModel(
        id: '2',
        title: '본인 인증된 사용자와 거래',
        description: '전화번호, 신분증 인증을 완료한 사용자와 거래하는 것이 안전해요.',
        category: SafetyCategory.verification,
        iconName: 'verified_user',
        priority: 2,
        isActive: true,
        createdAt: DateTime.now(),
      ),
      SafetyTipModel(
        id: '3',
        title: '앱 내에서만 소통하세요',
        description: '카카오톡, 문자 등 외부 연락처 교환은 피하고 앱 내 채팅을 이용하세요.',
        category: SafetyCategory.communication,
        iconName: 'chat',
        priority: 3,
        isActive: true,
        createdAt: DateTime.now(),
      ),
      SafetyTipModel(
        id: '4',
        title: '현금 거래 시 주의사항',
        description: '가짜 지폐를 주의하고, 큰 금액은 은행에서 확인 후 거래하세요.',
        category: SafetyCategory.payment,
        iconName: 'payment',
        priority: 4,
        isActive: true,
        createdAt: DateTime.now(),
      ),
    ];

    if (category != null) {
      return allTips.where((tip) => tip.category == category).toList();
    }
    return allTips;
  }

  // Trust Badges
  List<TrustBadgeModel> getAvailableBadges() {
    return [
      TrustBadgeModel(
        id: 'phone_verified',
        name: '전화번호 인증',
        description: '전화번호 인증을 완료한 사용자입니다.',
        iconName: 'phone_verified',
        color: '0xFF4CAF50',
        type: BadgeType.verification,
        requirements: {'phone_verified': true},
        priority: 1,
        isActive: true,
      ),
      TrustBadgeModel(
        id: 'id_verified',
        name: '신분증 인증',
        description: '신분증 인증을 완료한 사용자입니다.',
        iconName: 'badge',
        color: '0xFF2196F3',
        type: BadgeType.verification,
        requirements: {'id_verified': true},
        priority: 2,
        isActive: true,
      ),
      TrustBadgeModel(
        id: 'trusted_member',
        name: '믿을 만한 회원',
        description: '높은 신뢰도를 가진 우수 회원입니다.',
        iconName: 'star',
        color: '0xFFFFD700',
        type: BadgeType.rating,
        requirements: {'trust_score': 70, 'rating': 4.5},
        priority: 3,
        isActive: true,
      ),
      TrustBadgeModel(
        id: 'active_trader',
        name: '활발한 거래자',
        description: '10회 이상 성공적인 거래를 완료한 사용자입니다.',
        iconName: 'trending_up',
        color: '0xFF9C27B0',
        type: BadgeType.activity,
        requirements: {'successful_transactions': 10},
        priority: 4,
        isActive: true,
      ),
      TrustBadgeModel(
        id: 'long_term_member',
        name: '장기 회원',
        description: '6개월 이상 활동한 신뢰할 수 있는 회원입니다.',
        iconName: 'schedule',
        color: '0xFF795548',
        type: BadgeType.loyalty,
        requirements: {'account_age_months': 6},
        priority: 5,
        isActive: true,
      ),
    ];
  }

  List<TrustBadgeModel> getUserBadges(UserModel user) {
    final allBadges = getAvailableBadges();
    final userBadges = <TrustBadgeModel>[];

    for (final badge in allBadges) {
      if (_meetsRequirements(user, badge.requirements)) {
        userBadges.add(badge);
      }
    }

    return userBadges..sort((a, b) => a.priority.compareTo(b.priority));
  }

  bool _meetsRequirements(UserModel user, Map<String, dynamic> requirements) {
    for (final entry in requirements.entries) {
      switch (entry.key) {
        case 'phone_verified':
          if (!user.isPhoneVerified) return false;
          break;
        case 'email_verified':
          if (!user.isEmailVerified) return false;
          break;
        case 'id_verified':
          if (!user.isIdVerified) return false;
          break;
        case 'trust_score':
          if (user.trustScore < (entry.value as int)) return false;
          break;
        case 'rating':
          if (user.rating < (entry.value as double)) return false;
          break;
        case 'successful_transactions':
          if (user.successfulTransactions < (entry.value as int)) return false;
          break;
        case 'account_age_months':
          final ageMonths = DateTime.now().difference(user.createdAt).inDays / 30;
          if (ageMonths < (entry.value as int)) return false;
          break;
      }
    }
    return true;
  }

  Future<void> _updateUserBlockedList(String blockerId, String blockedUserId, bool isBlocking) async {
    try {
      final userResponse = await _client
          .from('user_profiles')
          .select('blocked_users')
          .eq('id', blockerId)
          .single();

      List<String> blockedUsers = List<String>.from(userResponse['blocked_users'] ?? []);

      if (isBlocking && !blockedUsers.contains(blockedUserId)) {
        blockedUsers.add(blockedUserId);
      } else if (!isBlocking) {
        blockedUsers.remove(blockedUserId);
      }

      await _client
          .from('user_profiles')
          .update({'blocked_users': blockedUsers})
          .eq('id', blockerId);
    } catch (e) {
      if (Env.enableLogging) print('Update blocked list error: $e');
    }
  }
}

// Riverpod Providers
final safetyServiceProvider = Provider<SafetyService>((ref) {
  return SafetyService();
});

final userTrustScoreProvider = FutureProvider.family<int, UserModel>((ref, user) async {
  final safetyService = ref.read(safetyServiceProvider);
  return await safetyService.calculateTrustScore(user);
});

final userBadgesProvider = Provider.family<List<TrustBadgeModel>, UserModel>((ref, user) {
  final safetyService = ref.read(safetyServiceProvider);
  return safetyService.getUserBadges(user);
});

final safetyTipsProvider = Provider.family<List<SafetyTipModel>, SafetyCategory?>((ref, category) {
  final safetyService = ref.read(safetyServiceProvider);
  return safetyService.getSafetyTips(category);
});