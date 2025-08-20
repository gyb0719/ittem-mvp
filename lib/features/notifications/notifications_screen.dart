import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text('모두 읽음'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _dummyNotifications.length,
        itemBuilder: (context, index) {
          final notification = _dummyNotifications[index];
          return _buildNotificationItem(notification);
        },
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    return Container(
      decoration: BoxDecoration(
        color: notification['isRead'] 
            ? null 
            : Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getNotificationColor(notification['type']).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getNotificationIcon(notification['type']),
            color: _getNotificationColor(notification['type']),
            size: 24,
          ),
        ),
        title: Text(
          notification['title'],
          style: TextStyle(
            fontWeight: notification['isRead'] ? FontWeight.normal : FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification['message']),
            const SizedBox(height: 4),
            Text(
              notification['time'],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: notification['isRead']
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
        onTap: () => _markAsRead(notification),
        isThreeLine: true,
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'rental_request':
        return Icons.shopping_bag_outlined;
      case 'rental_approved':
        return Icons.check_circle_outline;
      case 'chat_message':
        return Icons.chat_bubble_outline;
      case 'rental_reminder':
        return Icons.schedule_outlined;
      case 'review':
        return Icons.star_outline;
      case 'system':
        return Icons.info_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'rental_request':
        return Colors.blue;
      case 'rental_approved':
        return Colors.green;
      case 'chat_message':
        return Colors.purple;
      case 'rental_reminder':
        return Colors.orange;
      case 'review':
        return Colors.amber;
      case 'system':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  void _markAsRead(Map<String, dynamic> notification) {
    setState(() {
      notification['isRead'] = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _dummyNotifications) {
        notification['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('모든 알림을 읽음으로 표시했습니다')),
    );
  }
}

final List<Map<String, dynamic>> _dummyNotifications = [
  {
    'id': '1',
    'type': 'rental_request',
    'title': '대여 신청이 도착했습니다',
    'message': '김철수님이 "캐논 DSLR 카메라" 대여를 신청했습니다.',
    'time': '5분 전',
    'isRead': false,
  },
  {
    'id': '2',
    'type': 'chat_message',
    'title': '새로운 메시지',
    'message': '이영희: 언제 수령 가능한가요?',
    'time': '1시간 전',
    'isRead': false,
  },
  {
    'id': '3',
    'type': 'rental_approved',
    'title': '대여 신청이 승인되었습니다',
    'message': '"캠핑 텐트" 대여 신청이 승인되었습니다.',
    'time': '3시간 전',
    'isRead': true,
  },
  {
    'id': '4',
    'type': 'rental_reminder',
    'title': '반납 알림',
    'message': '"전동 드릴" 반납일이 내일입니다.',
    'time': '6시간 전',
    'isRead': false,
  },
  {
    'id': '5',
    'type': 'review',
    'title': '새로운 리뷰',
    'message': '박민수님이 5점 리뷰를 남겼습니다.',
    'time': '1일 전',
    'isRead': true,
  },
  {
    'id': '6',
    'type': 'system',
    'title': '시스템 업데이트',
    'message': 'Ittem 앱이 업데이트되었습니다. 새로운 기능을 확인해보세요.',
    'time': '2일 전',
    'isRead': true,
  },
];