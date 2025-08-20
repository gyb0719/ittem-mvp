import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/env.dart';
import '../shared/models/user_model.dart';
import '../shared/models/item_model.dart';

class SupabaseService {
  static SupabaseClient? _client;
  
  static SupabaseClient get client {
    _client ??= Supabase.instance.client;
    return _client!;
  }
  
  // Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
  }
  
  // Auth Methods
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        final userData = await getUserProfile(response.user!.id);
        return userData;
      }
      return null;
    } catch (e) {
      if (Env.enableLogging) print('Sign in error: $e');
      throw Exception('로그인 중 오류가 발생했습니다: $e');
    }
  }
  
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
    required String location,
    String? phoneNumber,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        // Create user profile
        final userProfile = {
          'id': response.user!.id,
          'email': email,
          'name': name,
          'location': location,
          'phone_number': phoneNumber,
          'rating': 0.0,
          'transaction_count': 0,
          'is_verified': false,
          'created_at': DateTime.now().toIso8601String(),
          'last_login_at': DateTime.now().toIso8601String(),
        };
        
        await client.from('user_profiles').insert(userProfile);
        
        return UserModel(
          id: response.user!.id,
          email: email,
          name: name,
          location: location,
          phoneNumber: phoneNumber,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      if (Env.enableLogging) print('Sign up error: $e');
      throw Exception('회원가입 중 오류가 발생했습니다: $e');
    }
  }
  
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      if (Env.enableLogging) print('Sign out error: $e');
      throw Exception('로그아웃 중 오류가 발생했습니다: $e');
    }
  }
  
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final response = await client
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .single();
      
      return UserModel.fromJson(response);
    } catch (e) {
      if (Env.enableLogging) print('Get user profile error: $e');
      return null;
    }
  }
  
  // Item Methods
  Future<List<ItemModel>> getItems({
    String? category,
    String? location,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      PostgrestFilterBuilder query = client
          .from('items')
          .select()
          .eq('is_available', true);
      
      if (category != null && category != '전체') {
        query = query.eq('category', category);
      }
      
      if (location != null) {
        query = query.ilike('location', '%$location%');
      }
      
      final finalQuery = query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);
      
      final response = await finalQuery;
      
      return (response as List)
          .map((item) => ItemModel.fromJson(item))
          .toList();
    } catch (e) {
      if (Env.enableLogging) print('Get items error: $e');
      return [];
    }
  }
  
  Future<ItemModel?> createItem({
    required String title,
    required String description,
    required int price,
    required String category,
    required String location,
    String? imageUrl,
    required String ownerId,
  }) async {
    try {
      final itemData = {
        'title': title,
        'description': description,
        'price': price,
        'category': category,
        'location': location,
        'image_url': imageUrl ?? '',
        'owner_id': ownerId,
        'is_available': true,
        'rating': 0.0,
        'review_count': 0,
        'created_at': DateTime.now().toIso8601String(),
      };
      
      final response = await client
          .from('items')
          .insert(itemData)
          .select()
          .single();
      
      return ItemModel.fromJson(response);
    } catch (e) {
      if (Env.enableLogging) print('Create item error: $e');
      throw Exception('아이템 생성 중 오류가 발생했습니다: $e');
    }
  }
  
  Future<ItemModel?> getItem(String itemId) async {
    try {
      final response = await client
          .from('items')
          .select()
          .eq('id', itemId)
          .single();
      
      return ItemModel.fromJson(response);
    } catch (e) {
      if (Env.enableLogging) print('Get item error: $e');
      return null;
    }
  }
  
  // Chat Methods
  Future<List<Map<String, dynamic>>> getChats(String userId) async {
    try {
      final response = await client
          .from('chats')
          .select('''
            *,
            item:items(*),
            participant:user_profiles(*)
          ''')
          .or('user1_id.eq.$userId,user2_id.eq.$userId')
          .order('updated_at', ascending: false);
      
      return response as List<Map<String, dynamic>>;
    } catch (e) {
      if (Env.enableLogging) print('Get chats error: $e');
      return [];
    }
  }
  
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String message,
  }) async {
    try {
      await client.from('messages').insert({
        'chat_id': chatId,
        'sender_id': senderId,
        'message': message,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      // Update chat's last message time
      await client
          .from('chats')
          .update({'updated_at': DateTime.now().toIso8601String()})
          .eq('id', chatId);
    } catch (e) {
      if (Env.enableLogging) print('Send message error: $e');
      throw Exception('메시지 전송 중 오류가 발생했습니다: $e');
    }
  }
  
  // Real-time subscriptions
  RealtimeChannel subscribeToChat(String chatId, Function(Map<String, dynamic>) onMessage) {
    return client
        .channel('messages:chat_id=eq.$chatId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            onMessage(payload.newRecord);
          },
        )
        .subscribe();
  }
  
  // Rental Methods
  Future<void> createRentalRequest({
    required String itemId,
    required String renterId,
    required DateTime startDate,
    required int durationDays,
    required int totalPrice,
  }) async {
    try {
      await client.from('rental_requests').insert({
        'item_id': itemId,
        'renter_id': renterId,
        'start_date': startDate.toIso8601String(),
        'duration_days': durationDays,
        'total_price': totalPrice,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      if (Env.enableLogging) print('Create rental request error: $e');
      throw Exception('대여 신청 중 오류가 발생했습니다: $e');
    }
  }
}

// Providers
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

final currentUserProvider = StateProvider<User?>((ref) {
  return Supabase.instance.client.auth.currentUser;
});

final userProfileProvider = FutureProvider<UserModel?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user != null) {
    final supabaseService = ref.read(supabaseServiceProvider);
    return await supabaseService.getUserProfile(user.id);
  }
  return null;
});