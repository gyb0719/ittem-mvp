import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../shared/models/chat_model.dart';
import '../shared/models/message_model.dart';
import '../config/env.dart';

class ChatService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // 채팅방 목록 조회
  Future<List<ChatModel>> getChats(String userId) async {
    try {
      final response = await _supabase
          .from('chats')
          .select('''
            *,
            item:items(id, title, image_url),
            buyer:user_profiles!chats_buyer_id_fkey(id, name, location),
            seller:user_profiles!chats_seller_id_fkey(id, name, location),
            last_message_data:messages(content, created_at, message_type)
          ''')
          .or('buyer_id.eq.$userId,seller_id.eq.$userId')
          .order('updated_at', ascending: false);

      return response.map<ChatModel>((json) {
        // Transform the response to match ChatModel structure
        final transformedJson = {
          'id': json['id'],
          'item_id': json['item_id'],
          'buyer_id': json['buyer_id'],
          'seller_id': json['seller_id'],
          'last_message': json['last_message'],
          'last_message_at': json['last_message_at'],
          'unread_count': json['unread_count'] ?? 0,
          'is_active': json['is_active'] ?? true,
          'created_at': json['created_at'],
          'updated_at': json['updated_at'],
        };
        
        return ChatModel.fromJson(transformedJson);
      }).toList();
    } catch (e) {
      if (Env.enableLogging) print('Error fetching chats: $e');
      return [];
    }
  }

  // 특정 채팅방의 메시지 목록 조회
  Future<List<MessageModel>> getMessages(String chatId, {int limit = 50, int offset = 0}) async {
    try {
      final response = await _supabase
          .from('messages')
          .select('*')
          .eq('chat_id', chatId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return response.map<MessageModel>((json) => MessageModel.fromJson(json)).toList();
    } catch (e) {
      if (Env.enableLogging) print('Error fetching messages: $e');
      return [];
    }
  }

  // 채팅방 생성 또는 기존 채팅방 조회
  Future<ChatModel?> createOrGetChat({
    required String itemId,
    required String buyerId,
    required String sellerId,
  }) async {
    try {
      // 기존 채팅방 확인
      final existingChats = await _supabase
          .from('chats')
          .select()
          .eq('item_id', itemId)
          .eq('buyer_id', buyerId)
          .eq('seller_id', sellerId)
          .limit(1);

      if (existingChats.isNotEmpty) {
        return ChatModel.fromJson(existingChats.first);
      }

      // 새 채팅방 생성
      final response = await _supabase
          .from('chats')
          .insert({
            'item_id': itemId,
            'buyer_id': buyerId,
            'seller_id': sellerId,
            'is_active': true,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return ChatModel.fromJson(response);
    } catch (e) {
      if (Env.enableLogging) print('Error creating/getting chat: $e');
      return null;
    }
  }

  // 메시지 전송
  Future<MessageModel?> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    MessageType type = MessageType.text,
    String? imageUrl,
  }) async {
    try {
      final messageData = {
        'chat_id': chatId,
        'sender_id': senderId,
        'content': content,
        'type': type.toString().split('.').last,
        'image_url': imageUrl,
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('messages')
          .insert(messageData)
          .select()
          .single();

      // 채팅방의 마지막 메시지 정보 업데이트
      await _supabase
          .from('chats')
          .update({
            'last_message': content,
            'last_message_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', chatId);

      // 상대방의 읽지 않은 메시지 수 증가
      await _incrementUnreadCount(chatId, senderId);

      return MessageModel.fromJson(response);
    } catch (e) {
      if (Env.enableLogging) print('Error sending message: $e');
      return null;
    }
  }

  // 메시지 읽음 처리
  Future<void> markMessagesAsRead(String chatId, String userId) async {
    try {
      await _supabase
          .from('messages')
          .update({
            'is_read': true,
            'read_at': DateTime.now().toIso8601String(),
          })
          .eq('chat_id', chatId)
          .neq('sender_id', userId)
          .eq('is_read', false);

      // 읽지 않은 메시지 수 초기화
      await _supabase
          .from('chats')
          .update({'unread_count': 0})
          .eq('id', chatId);
    } catch (e) {
      if (Env.enableLogging) print('Error marking messages as read: $e');
    }
  }

  // 읽지 않은 메시지 수 증가
  Future<void> _incrementUnreadCount(String chatId, String senderId) async {
    try {
      // 현재 읽지 않은 메시지 수 조회
      final chatData = await _supabase
          .from('chats')
          .select('unread_count')
          .eq('id', chatId)
          .single();

      final currentCount = chatData['unread_count'] ?? 0;
      
      await _supabase
          .from('chats')
          .update({'unread_count': currentCount + 1})
          .eq('id', chatId);
    } catch (e) {
      if (Env.enableLogging) print('Error incrementing unread count: $e');
    }
  }

  // 실시간 메시지 구독
  RealtimeChannel subscribeToMessages(String chatId, Function(MessageModel) onMessage) {
    return _supabase
        .channel('messages:chat_id=eq.$chatId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chat_id',
            value: chatId,
          ),
          callback: (payload) {
            try {
              final message = MessageModel.fromJson(payload.newRecord);
              onMessage(message);
            } catch (e) {
              if (Env.enableLogging) print('Error parsing message: $e');
            }
          },
        )
        .subscribe();
  }

  // 실시간 채팅방 목록 구독
  RealtimeChannel subscribeToChats(String userId, Function(ChatModel) onChatUpdate) {
    return _supabase
        .channel('chats:user_id=eq.$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'chats',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.or,
            column: 'buyer_id,seller_id',
            value: '$userId,$userId',
          ),
          callback: (payload) {
            try {
              final chat = ChatModel.fromJson(payload.newRecord);
              onChatUpdate(chat);
            } catch (e) {
              if (Env.enableLogging) print('Error parsing chat update: $e');
            }
          },
        )
        .subscribe();
  }

  // 채팅방 삭제
  Future<bool> deleteChat(String chatId) async {
    try {
      // 관련 메시지들 먼저 삭제
      await _supabase
          .from('messages')
          .delete()
          .eq('chat_id', chatId);

      // 채팅방 삭제
      await _supabase
          .from('chats')
          .delete()
          .eq('id', chatId);

      return true;
    } catch (e) {
      if (Env.enableLogging) print('Error deleting chat: $e');
      return false;
    }
  }

  // 온라인 상태 업데이트
  Future<void> updateOnlineStatus(String userId, bool isOnline) async {
    try {
      await _supabase
          .from('user_profiles')
          .update({
            'is_online': isOnline,
            'last_seen_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
    } catch (e) {
      if (Env.enableLogging) print('Error updating online status: $e');
    }
  }

  // 이미지 메시지 전송
  Future<MessageModel?> sendImageMessage({
    required String chatId,
    required String senderId,
    required String imageUrl,
    String? caption,
  }) async {
    return await sendMessage(
      chatId: chatId,
      senderId: senderId,
      content: caption ?? '사진을 보냈습니다.',
      type: MessageType.image,
      imageUrl: imageUrl,
    );
  }

  // 시스템 메시지 전송 (예: "대여가 시작되었습니다")
  Future<MessageModel?> sendSystemMessage({
    required String chatId,
    required String content,
  }) async {
    return await sendMessage(
      chatId: chatId,
      senderId: 'system',
      content: content,
      type: MessageType.system,
    );
  }
}

// Riverpod State Management
class ChatNotifier extends StateNotifier<List<ChatModel>> {
  final ChatService _chatService;
  RealtimeChannel? _chatSubscription;
  
  ChatNotifier(this._chatService) : super([]);

  Future<void> loadChats(String userId) async {
    final chats = await _chatService.getChats(userId);
    state = chats;
    
    // 실시간 구독 시작
    _chatSubscription?.unsubscribe();
    _chatSubscription = _chatService.subscribeToChats(userId, (updatedChat) {
      state = state.map((chat) {
        return chat.id == updatedChat.id ? updatedChat : chat;
      }).toList();
    });
  }

  Future<ChatModel?> createOrGetChat({
    required String itemId,
    required String buyerId,
    required String sellerId,
  }) async {
    return await _chatService.createOrGetChat(
      itemId: itemId,
      buyerId: buyerId,
      sellerId: sellerId,
    );
  }

  @override
  void dispose() {
    _chatSubscription?.unsubscribe();
    super.dispose();
  }
}

class MessageNotifier extends StateNotifier<List<MessageModel>> {
  final ChatService _chatService;
  RealtimeChannel? _messageSubscription;
  
  MessageNotifier(this._chatService) : super([]);

  Future<void> loadMessages(String chatId) async {
    final messages = await _chatService.getMessages(chatId);
    state = messages.reversed.toList(); // 최신 순서로 정렬
    
    // 실시간 구독 시작
    _messageSubscription?.unsubscribe();
    _messageSubscription = _chatService.subscribeToMessages(chatId, (newMessage) {
      state = [...state, newMessage];
    });
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    MessageType type = MessageType.text,
    String? imageUrl,
  }) async {
    final message = await _chatService.sendMessage(
      chatId: chatId,
      senderId: senderId,
      content: content,
      type: type,
      imageUrl: imageUrl,
    );

    if (message != null) {
      // 낙관적 업데이트 (실시간 구독으로도 추가되지만, 즉시 반영)
      state = [...state, message];
    }
  }

  Future<void> markAsRead(String chatId, String userId) async {
    await _chatService.markMessagesAsRead(chatId, userId);
  }

  @override
  void dispose() {
    _messageSubscription?.unsubscribe();
    super.dispose();
  }
}

// Providers
final chatServiceProvider = Provider<ChatService>((ref) => ChatService());

final chatNotifierProvider = StateNotifierProvider<ChatNotifier, List<ChatModel>>((ref) {
  return ChatNotifier(ref.read(chatServiceProvider));
});

final messageNotifierProvider = StateNotifierProvider<MessageNotifier, List<MessageModel>>((ref) {
  return MessageNotifier(ref.read(chatServiceProvider));
});

// 읽지 않은 메시지 총 개수
final totalUnreadCountProvider = Provider<int>((ref) {
  final chats = ref.watch(chatNotifierProvider);
  return chats.fold(0, (sum, chat) => sum + chat.unreadCount);
});

// 온라인 사용자 목록
final onlineUsersProvider = StateProvider<Set<String>>((ref) => {});