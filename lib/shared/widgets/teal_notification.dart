import 'package:flutter/material.dart';
import '../../theme/colors.dart';

/// 틸 색상 알림 카드
class TealNotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? iconColor;

  const TealNotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
    this.onTap,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: isRead ? Colors.white : AppColors.tealPale,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isRead ? AppColors.separator : AppColors.secondary,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 아이콘 또는 알림 점
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: icon != null 
                    ? Icon(
                        icon,
                        color: iconColor ?? AppColors.primary,
                        size: 20,
                      )
                    : Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isRead ? AppColors.textTertiary : AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              
              // 알림 내용
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color: isRead ? AppColors.textSecondary : AppColors.textPrimary,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 알림 타입별 아이콘과 색상
enum NotificationType {
  general,
  rental,
  payment,
  review,
  system,
}

extension NotificationTypeExtension on NotificationType {
  IconData get icon {
    switch (this) {
      case NotificationType.general:
        return Icons.notifications_outlined;
      case NotificationType.rental:
        return Icons.inventory_2_outlined;
      case NotificationType.payment:
        return Icons.payment_outlined;
      case NotificationType.review:
        return Icons.star_outline;
      case NotificationType.system:
        return Icons.settings_outlined;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.general:
        return AppColors.primary;
      case NotificationType.rental:
        return AppColors.accent;
      case NotificationType.payment:
        return AppColors.success;
      case NotificationType.review:
        return AppColors.warning;
      case NotificationType.system:
        return AppColors.textSecondary;
    }
  }
}

