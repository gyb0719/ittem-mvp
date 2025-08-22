import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../shared/models/notification_model.dart';
import '../config/env.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static final SupabaseClient _supabase = Supabase.instance.client;
  
  static bool _initialized = false;

  // 알림 서비스 초기화
  static Future<void> initialize() async {
    if (_initialized) return;

    // 권한 요청
    await _requestPermissions();

    // 로컬 알림 초기화
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  // 권한 요청
  static Future<void> _requestPermissions() async {
    if (Theme.of(NavigationService.navigatorKey.currentContext!).platform == TargetPlatform.android) {
      await Permission.notification.request();
    }
  }

  // 알림 탭 이벤트 처리
  static void _onNotificationTapped(NotificationResponse response) {
    final context = NavigationService.navigatorKey.currentContext;
    if (context == null) return;

    // payload 파싱하여 적절한 화면으로 이동
    final payload = response.payload;
    if (payload != null) {
      _handleNotificationNavigation(context, payload);
    }
  }

  // 알림 네비게이션 처리
  static void _handleNotificationNavigation(BuildContext context, String payload) {
    try {
      final data = payload.split('|');
      if (data.length < 2) return;

      final type = data[0];
      final id = data[1];

      switch (type) {
        case 'message':
          Navigator.pushNamed(context, '/chat/$id');
          break;
        case 'item':
          Navigator.pushNamed(context, '/item/$id');
          break;
        case 'rental':
          Navigator.pushNamed(context, '/rental/$id');
          break;
        default:
          Navigator.pushNamed(context, '/notifications');
      }
    } catch (e) {
      if (Env.enableLogging) print('Error handling notification navigation: $e');
    }
  }

  // 로컬 알림 표시
  static Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationType type = NotificationType.system,
  }) async {
    if (!_initialized) await initialize();

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'ittem_channel',
      'Ittem 알림',
      channelDescription: 'Ittem 앱의 모든 알림',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFF5CBDBD),
      enableVibration: true,
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // 서버에서 알림 목록 조회
  static Future<List<NotificationModel>> getNotifications(String userId) async {
    try {
      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(50);

      return response.map<NotificationModel>((json) => NotificationModel.fromJson(json)).toList();
    } catch (e) {
      if (Env.enableLogging) print('Error fetching notifications: $e');
      return [];
    }
  }

  // 서버에 알림 저장
  static Future<NotificationModel?> createNotification({
    required String userId,
    required String title,
    required String message,
    required NotificationType type,
    String? relatedId,
    String? imageUrl,
  }) async {
    try {
      final data = {
        'user_id': userId,
        'title': title,
        'message': message,
        'type': type.toString().split('.').last,
        'related_id': relatedId,
        'image_url': imageUrl,
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('notifications')
          .insert(data)
          .select()
          .single();

      final notification = NotificationModel.fromJson(response);
      
      // 로컬 알림도 함께 표시
      await showLocalNotification(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        body: message,
        payload: '${type.toString().split('.').last}|${relatedId ?? ''}',
        type: type,
      );

      return notification;
    } catch (e) {
      if (Env.enableLogging) print('Error creating notification: $e');
      return null;
    }
  }

  // 알림 읽음 처리
  static Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({
            'is_read': true,
            'read_at': DateTime.now().toIso8601String(),
          })
          .eq('id', notificationId);
    } catch (e) {
      if (Env.enableLogging) print('Error marking notification as read: $e');
    }
  }

  // 모든 알림 읽음 처리
  static Future<void> markAllAsRead(String userId) async {
    try {
      await _supabase
          .from('notifications')
          .update({
            'is_read': true,
            'read_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .eq('is_read', false);
    } catch (e) {
      if (Env.enableLogging) print('Error marking all notifications as read: $e');
    }
  }

  // 알림 삭제
  static Future<void> deleteNotification(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .delete()
          .eq('id', notificationId);
    } catch (e) {
      if (Env.enableLogging) print('Error deleting notification: $e');
    }
  }

  // 읽지 않은 알림 개수 조회
  static Future<int> getUnreadCount(String userId) async {
    try {
      final response = await _supabase
          .from('notifications')
          .select('id')
          .eq('user_id', userId)
          .eq('is_read', false);

      return response.length;
    } catch (e) {
      if (Env.enableLogging) print('Error fetching unread count: $e');
      return 0;
    }
  }

  // 실시간 알림 구독
  static RealtimeChannel subscribeToNotifications(String userId, Function(NotificationModel) onNotification) {
    return _supabase
        .channel('notifications:user_id=eq.$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            try {
              final notification = NotificationModel.fromJson(payload.newRecord);
              onNotification(notification);
              
              // 로컬 알림도 표시
              showLocalNotification(
                id: DateTime.now().millisecondsSinceEpoch,
                title: notification.title,
                body: notification.message,
                payload: '${notification.type.toString().split('.').last}|${notification.relatedId ?? ''}',
                type: notification.type,
              );
            } catch (e) {
              if (Env.enableLogging) print('Error parsing notification: $e');
            }
          },
        )
        .subscribe();
  }

  // 특정 타입별 알림 생성 헬퍼 메서드들
  static Future<void> sendMessageNotification({
    required String userId,
    required String senderName,
    required String message,
    required String chatId,
  }) async {
    await createNotification(
      userId: userId,
      title: '$senderName님의 메시지',
      message: message,
      type: NotificationType.message,
      relatedId: chatId,
    );
  }

  static Future<void> sendItemUpdateNotification({
    required String userId,
    required String itemTitle,
    required String updateType,
    required String itemId,
  }) async {
    String message;
    switch (updateType) {
      case 'approved':
        message = '"$itemTitle" 대여 신청이 승인되었습니다.';
        break;
      case 'rejected':
        message = '"$itemTitle" 대여 신청이 거절되었습니다.';
        break;
      case 'returned':
        message = '"$itemTitle" 반납이 완료되었습니다.';
        break;
      default:
        message = '"$itemTitle"에 대한 업데이트가 있습니다.';
    }

    await createNotification(
      userId: userId,
      title: '아이템 상태 변경',
      message: message,
      type: NotificationType.itemUpdate,
      relatedId: itemId,
    );
  }

  static Future<void> sendRentalNotification({
    required String userId,
    required String itemTitle,
    required String action,
    required String rentalId,
  }) async {
    String title;
    String message;
    
    switch (action) {
      case 'request':
        title = '새로운 대여 신청';
        message = '"$itemTitle"에 대여 신청이 들어왔습니다.';
        break;
      case 'reminder':
        title = '반납 알림';
        message = '"$itemTitle" 반납일이 내일입니다.';
        break;
      case 'overdue':
        title = '연체 알림';
        message = '"$itemTitle" 반납일이 지났습니다.';
        break;
      default:
        title = '대여 알림';
        message = '"$itemTitle"에 대한 알림입니다.';
    }

    await createNotification(
      userId: userId,
      title: title,
      message: message,
      type: NotificationType.rental,
      relatedId: rentalId,
    );
  }

  static Future<void> sendReviewNotification({
    required String userId,
    required String itemTitle,
    required double rating,
    required String reviewId,
  }) async {
    await createNotification(
      userId: userId,
      title: '새로운 리뷰',
      message: '"$itemTitle"에 ${rating}점 리뷰가 등록되었습니다.',
      type: NotificationType.review,
      relatedId: reviewId,
    );
  }

  // 배지 카운트 업데이트 (iOS)
  static Future<void> updateBadgeCount(int count) async {
    await _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // 모든 로컬 알림 취소
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // 특정 알림 취소
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
}

// Navigation Service for global context access
class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

// Riverpod State Management
class NotificationNotifier extends StateNotifier<List<NotificationModel>> {
  RealtimeChannel? _subscription;
  
  NotificationNotifier() : super([]);

  Future<void> loadNotifications(String userId) async {
    final notifications = await NotificationService.getNotifications(userId);
    state = notifications;
    
    // 실시간 구독 시작
    _subscription?.unsubscribe();
    _subscription = NotificationService.subscribeToNotifications(userId, (notification) {
      state = [notification, ...state];
    });
  }

  Future<void> markAsRead(String notificationId) async {
    await NotificationService.markAsRead(notificationId);
    
    state = state.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(
          isRead: true,
          readAt: DateTime.now(),
        );
      }
      return notification;
    }).toList();
  }

  Future<void> markAllAsRead(String userId) async {
    await NotificationService.markAllAsRead(userId);
    
    state = state.map((notification) {
      return notification.copyWith(
        isRead: true,
        readAt: DateTime.now(),
      );
    }).toList();
  }

  Future<void> deleteNotification(String notificationId) async {
    await NotificationService.deleteNotification(notificationId);
    state = state.where((notification) => notification.id != notificationId).toList();
  }

  @override
  void dispose() {
    _subscription?.unsubscribe();
    super.dispose();
  }
}

// Providers
final notificationNotifierProvider = StateNotifierProvider<NotificationNotifier, List<NotificationModel>>((ref) {
  return NotificationNotifier();
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationNotifierProvider);
  return notifications.where((notification) => !notification.isRead).length;
});

final notificationsByTypeProvider = Provider.family<List<NotificationModel>, NotificationType>((ref, type) {
  final notifications = ref.watch(notificationNotifierProvider);
  return notifications.where((notification) => notification.type == type).toList();
});