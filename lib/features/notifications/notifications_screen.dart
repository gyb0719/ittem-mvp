import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../shared/models/notification_model.dart';
import '../../services/notification_service.dart';
import '../../shared/widgets/teal_card.dart';
import '../../shared/widgets/teal_button.dart';
import '../../shared/services/auth_service.dart';
import '../../app/routes/app_routes.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotifications();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    final authState = ref.read(authStateProvider);
    if (authState is AuthStateAuthenticated) {
      ref.read(notificationNotifierProvider.notifier).loadNotifications(authState.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationNotifierProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Text(
              '알림',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('모두 읽음'),
            ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () => _showMoreOptions(context),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationList(notifications),
          _buildNotificationList(notifications.where((n) => n.type == NotificationType.message).toList()),
          _buildNotificationList(notifications.where((n) => n.type == NotificationType.itemUpdate).toList()),
          _buildNotificationList(notifications.where((n) => n.type == NotificationType.rental).toList()),
          _buildNotificationList(notifications.where((n) => n.type == NotificationType.review).toList()),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: 16),
            Text(
              '알림이 없습니다',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Container(
        decoration: notification.isRead 
          ? null 
          : BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
        child: TealCard(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: _buildNotificationIcon(notification.type),
            title: Text(
              notification.title,
              style: TextStyle(
                fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.message,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      _formatTime(notification.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const Spacer(),
                    if (notification.imageUrl != null)
                      const Icon(
                        Icons.image,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            onTap: () => _onNotificationTap(notification),
            isThreeLine: true,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationType type) {
    IconData icon;
    Color color;

    switch (type) {
      case NotificationType.message:
        icon = Icons.chat_bubble_outline;
        color = Colors.blue;
        break;
      case NotificationType.itemUpdate:
        icon = Icons.inventory_2_outlined;
        color = Colors.green;
        break;
      case NotificationType.rental:
        icon = Icons.schedule_outlined;
        color = Colors.orange;
        break;
      case NotificationType.review:
        icon = Icons.star_outline;
        color = Colors.amber;
        break;
      case NotificationType.system:
        icon = Icons.info_outline;
        color = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}일 전';
    } else {
      return '${dateTime.month}월 ${dateTime.day}일';
    }
  }

  void _onNotificationTap(NotificationModel notification) {
    // 읽음 처리
    if (!notification.isRead) {
      ref.read(notificationNotifierProvider.notifier).markAsRead(notification.id);
    }

    // 적절한 화면으로 이동
    if (notification.relatedId != null) {
      switch (notification.type) {
        case NotificationType.message:
          context.push('/chat/${notification.relatedId}');
          break;
        case NotificationType.itemUpdate:
        case NotificationType.review:
          context.push(AppRoutes.itemDetail(notification.relatedId!));
          break;
        case NotificationType.rental:
          // TODO: 대여 상세 화면으로 이동
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('대여 상세 화면은 구현 예정입니다')),
          );
          break;
        case NotificationType.system:
          // TODO: 시스템 공지 화면으로 이동
          break;
      }
    }
  }

  void _deleteNotification(String notificationId) {
    ref.read(notificationNotifierProvider.notifier).deleteNotification(notificationId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('알림이 삭제되었습니다')),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '알림 설정',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.mark_email_read),
              title: const Text('모두 읽음 처리'),
              onTap: () {
                Navigator.pop(context);
                _markAllAsRead();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep),
              title: const Text('읽은 알림 삭제'),
              onTap: () {
                Navigator.pop(context);
                _deleteReadNotifications();
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active),
              title: const Text('알림 설정'),
              onTap: () {
                Navigator.pop(context);
                _showNotificationSettings();
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('새로고침'),
              onTap: () {
                Navigator.pop(context);
                _loadNotifications();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _deleteReadNotifications() {
    final authState = ref.read(authStateProvider);
    if (authState is AuthStateAuthenticated) {
      // 읽은 알림들을 직접 삭제
      final readNotifications = ref.read(notificationNotifierProvider).where((n) => n.isRead);
      for (final notification in readNotifications) {
        ref.read(notificationNotifierProvider.notifier).deleteNotification(notification.id);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('읽은 알림들이 삭제되었습니다')),
      );
    }
  }

  void _markAllAsRead() {
    final authState = ref.read(authStateProvider);
    if (authState is AuthStateAuthenticated) {
      ref.read(notificationNotifierProvider.notifier).markAllAsRead(authState.user.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 알림을 읽음 처리했습니다')),
      );
    }
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('알림 설정'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• 메시지 알림'),
            Text('• 아이템 업데이트 알림'),
            Text('• 대여 관련 알림'),
            Text('• 리뷰 알림'),
            Text('• 시스템 알림'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}