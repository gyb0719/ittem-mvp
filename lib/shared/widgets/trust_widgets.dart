import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/verification_model.dart';
import '../../services/safety_service.dart';
import '../../theme/colors.dart';

class TrustBadgeRow extends ConsumerWidget {
  final UserModel user;
  final bool showLabels;
  final double size;

  const TrustBadgeRow({
    super.key,
    required this.user,
    this.showLabels = false,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badges = ref.watch(userBadgesProvider(user));
    
    if (badges.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 4,
      children: badges.take(3).map((badge) => 
        TrustBadge(
          badge: badge,
          showLabel: showLabels,
          size: size,
        )
      ).toList(),
    );
  }
}

class TrustBadge extends StatelessWidget {
  final TrustBadgeModel badge;
  final bool showLabel;
  final double size;

  const TrustBadge({
    super.key,
    required this.badge,
    this.showLabel = false,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(badge.color));
    
    if (showLabel) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconData(badge.iconName),
              size: size,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              badge.name,
              style: TextStyle(
                fontSize: size * 0.7,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      );
    }

    return Tooltip(
      message: badge.description,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          _getIconData(badge.iconName),
          size: size * 0.8,
          color: Colors.white,
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'phone_verified':
        return Icons.phone_android;
      case 'badge':
        return Icons.verified_user;
      case 'star':
        return Icons.star;
      case 'trending_up':
        return Icons.trending_up;
      case 'schedule':
        return Icons.schedule;
      default:
        return Icons.verified;
    }
  }
}

class TrustScoreIndicator extends ConsumerWidget {
  final UserModel user;
  final bool showLabel;
  final double size;

  const TrustScoreIndicator({
    super.key,
    required this.user,
    this.showLabel = true,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trustScoreAsync = ref.watch(userTrustScoreProvider(user));
    
    return trustScoreAsync.when(
      data: (trustScore) {
        final color = _getTrustScoreColor(trustScore);
        final level = _getTrustLevel(trustScore);
        
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: size,
                  height: size,
                  child: CircularProgressIndicator(
                    value: trustScore / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    strokeWidth: 4,
                  ),
                ),
                Text(
                  trustScore.toString(),
                  style: TextStyle(
                    fontSize: size * 0.3,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            if (showLabel) ...[
              const SizedBox(height: 4),
              Text(
                level,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ],
        );
      },
      loading: () => SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(),
      ),
      error: (error, stack) => Icon(
        Icons.error,
        size: size,
        color: Colors.red,
      ),
    );
  }

  Color _getTrustScoreColor(int score) {
    if (score >= 80) return Colors.purple;
    if (score >= 60) return Colors.amber;
    if (score >= 40) return Colors.grey;
    return Colors.brown;
  }

  String _getTrustLevel(int score) {
    if (score >= 80) return '플래티넘';
    if (score >= 60) return '골드';
    if (score >= 40) return '실버';
    return '브론즈';
  }
}

class VerificationStatusRow extends StatelessWidget {
  final UserModel user;
  final bool compact;

  const VerificationStatusRow({
    super.key,
    required this.user,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final verifications = [
      VerificationInfo('전화번호', user.isPhoneVerified, Icons.phone),
      VerificationInfo('이메일', user.isEmailVerified, Icons.email),
      VerificationInfo('신분증', user.isIdVerified, Icons.badge),
      if (!compact) ...[
        VerificationInfo('주소', user.isAddressVerified, Icons.home),
        VerificationInfo('계좌', user.isBankAccountVerified, Icons.account_balance),
      ],
    ];

    return Wrap(
      spacing: compact ? 4 : 8,
      runSpacing: 4,
      children: verifications.map((verification) =>
        VerificationIndicator(
          label: verification.label,
          isVerified: verification.isVerified,
          icon: verification.icon,
          compact: compact,
        )
      ).toList(),
    );
  }
}

class VerificationIndicator extends StatelessWidget {
  final String label;
  final bool isVerified;
  final IconData icon;
  final bool compact;

  const VerificationIndicator({
    super.key,
    required this.label,
    required this.isVerified,
    required this.icon,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isVerified ? Colors.green : Colors.grey[400]!;
    
    if (compact) {
      return Tooltip(
        message: '$label ${isVerified ? '인증됨' : '미인증'}',
        child: Icon(
          isVerified ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 16,
          color: color,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(width: 2),
          Icon(
            isVerified ? Icons.check : Icons.close,
            size: 12,
            color: color,
          ),
        ],
      ),
    );
  }
}

class SafetyIndicator extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;

  const SafetyIndicator({
    super.key,
    required this.user,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final safetyLevel = _calculateSafetyLevel(user);
    final color = _getSafetyColor(safetyLevel);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getSafetyIcon(safetyLevel),
              size: 16,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              _getSafetyText(safetyLevel),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 2),
              Icon(
                Icons.info_outline,
                size: 12,
                color: color,
              ),
            ],
          ],
        ),
      ),
    );
  }

  SafetyLevel _calculateSafetyLevel(UserModel user) {
    int verificationCount = 0;
    if (user.isPhoneVerified) verificationCount++;
    if (user.isEmailVerified) verificationCount++;
    if (user.isIdVerified) verificationCount++;
    
    if (user.reportCount > 3 || user.isBlocked) {
      return SafetyLevel.warning;
    }
    
    if (verificationCount >= 3 && user.rating >= 4.5 && user.successfulTransactions >= 10) {
      return SafetyLevel.high;
    }
    
    if (verificationCount >= 2 && user.rating >= 4.0) {
      return SafetyLevel.medium;
    }
    
    return SafetyLevel.low;
  }

  Color _getSafetyColor(SafetyLevel level) {
    switch (level) {
      case SafetyLevel.high:
        return Colors.green;
      case SafetyLevel.medium:
        return Colors.orange;
      case SafetyLevel.low:
        return Colors.grey;
      case SafetyLevel.warning:
        return Colors.red;
    }
  }

  IconData _getSafetyIcon(SafetyLevel level) {
    switch (level) {
      case SafetyLevel.high:
        return Icons.shield;
      case SafetyLevel.medium:
        return Icons.security;
      case SafetyLevel.low:
        return Icons.info;
      case SafetyLevel.warning:
        return Icons.warning;
    }
  }

  String _getSafetyText(SafetyLevel level) {
    switch (level) {
      case SafetyLevel.high:
        return '안전';
      case SafetyLevel.medium:
        return '보통';
      case SafetyLevel.low:
        return '주의';
      case SafetyLevel.warning:
        return '위험';
    }
  }
}

class ReportButton extends StatelessWidget {
  final String reportedUserId;
  final String? itemId;
  final String? chatId;
  final Widget child;

  const ReportButton({
    super.key,
    required this.reportedUserId,
    this.itemId,
    this.chatId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showReportDialog(context),
      child: child,
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ReportDialog(
        reportedUserId: reportedUserId,
        itemId: itemId,
        chatId: chatId,
      ),
    );
  }
}

class ReportDialog extends ConsumerStatefulWidget {
  final String reportedUserId;
  final String? itemId;
  final String? chatId;

  const ReportDialog({
    super.key,
    required this.reportedUserId,
    this.itemId,
    this.chatId,
  });

  @override
  ConsumerState<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends ConsumerState<ReportDialog> {
  ReportCategory? selectedCategory;
  final descriptionController = TextEditingController();
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('신고하기'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('신고 사유를 선택해주세요:'),
            const SizedBox(height: 12),
            ...ReportCategory.values.map((category) =>
              RadioListTile<ReportCategory>(
                title: Text(_getReportCategoryText(category)),
                value: category,
                groupValue: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              )
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: '상세 내용 (선택)',
                border: OutlineInputBorder(),
                hintText: '신고 내용에 대해 자세히 설명해주세요',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: selectedCategory != null && !isSubmitting
              ? _submitReport
              : null,
          child: isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('신고하기'),
        ),
      ],
    );
  }

  Future<void> _submitReport() async {
    setState(() {
      isSubmitting = true;
    });

    try {
      final safetyService = ref.read(safetyServiceProvider);
      // TODO: Get current user ID from auth state
      final currentUserId = 'current-user-id';

      final success = await safetyService.reportUser(
        reporterId: currentUserId,
        reportedUserId: widget.reportedUserId,
        category: selectedCategory!,
        description: descriptionController.text,
        itemId: widget.itemId,
        chatId: widget.chatId,
      );

      if (success) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('신고가 접수되었습니다.')),
          );
        }
      } else {
        throw Exception('신고 접수에 실패했습니다.');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  String _getReportCategoryText(ReportCategory category) {
    switch (category) {
      case ReportCategory.scam:
        return '사기/허위 정보';
      case ReportCategory.inappropriateBehavior:
        return '부적절한 행동';
      case ReportCategory.fakeProfile:
        return '가짜 프로필';
      case ReportCategory.spamming:
        return '스팸/도배';
      case ReportCategory.harassment:
        return '괴롭힘';
      case ReportCategory.violentThreat:
        return '폭력적 위협';
      case ReportCategory.inappropriateContent:
        return '부적절한 콘텐츠';
      case ReportCategory.itemMisrepresentation:
        return '상품 허위 기재';
      case ReportCategory.paymentIssue:
        return '결제 관련 문제';
      case ReportCategory.noShow:
        return '노쇼';
      case ReportCategory.other:
        return '기타';
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}

// Helper classes
class VerificationInfo {
  final String label;
  final bool isVerified;
  final IconData icon;

  VerificationInfo(this.label, this.isVerified, this.icon);
}

enum SafetyLevel { high, medium, low, warning }