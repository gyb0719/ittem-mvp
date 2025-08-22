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

  // Advanced Search Methods
  Future<List<ItemModel>> searchItems({
    String? query,
    String? category,
    String? location,
    double? minPrice,
    double? maxPrice,
    bool onlyAvailable = true,
    String sortBy = 'created_at',
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      PostgrestFilterBuilder searchQuery = client
          .from('items')
          .select();
      
      // 가용성 필터
      if (onlyAvailable) {
        searchQuery = searchQuery.eq('is_available', true);
      }
      
      // 검색어 필터 (제목, 설명, 카테고리에서 검색)
      if (query != null && query.trim().isNotEmpty) {
        final searchTerm = query.trim();
        searchQuery = searchQuery.or(
          'title.ilike.%$searchTerm%,'
          'description.ilike.%$searchTerm%,'
          'category.ilike.%$searchTerm%'
        );
      }
      
      // 카테고리 필터
      if (category != null && category != '전체') {
        searchQuery = searchQuery.eq('category', category);
      }
      
      // 위치 필터
      if (location != null && location != '전체') {
        searchQuery = searchQuery.ilike('location', '%$location%');
      }
      
      // 가격 범위 필터
      if (minPrice != null) {
        searchQuery = searchQuery.gte('price', minPrice);
      }
      if (maxPrice != null) {
        searchQuery = searchQuery.lte('price', maxPrice);
      }
      
      // 정렬
      bool ascending = false;
      String orderColumn = 'created_at';
      
      switch (sortBy) {
        case 'latest':
          orderColumn = 'created_at';
          ascending = false;
          break;
        case 'price_low':
          orderColumn = 'price';
          ascending = true;
          break;
        case 'price_high':
          orderColumn = 'price';
          ascending = false;
          break;
        case 'rating':
          orderColumn = 'rating';
          ascending = false;
          break;
        case 'alphabetical':
          orderColumn = 'title';
          ascending = true;
          break;
        case 'distance':
          // TODO: 거리순 정렬은 위치 정보가 필요
          orderColumn = 'created_at';
          ascending = false;
          break;
      }
      
      final finalQuery = searchQuery
          .order(orderColumn, ascending: ascending)
          .range(offset, offset + limit - 1);
      
      final response = await finalQuery;
      
      return (response as List)
          .map((item) => ItemModel.fromJson(item))
          .toList();
    } catch (e) {
      if (Env.enableLogging) print('Search items error: $e');
      return [];
    }
  }

  // 자동완성을 위한 검색 제안
  Future<List<String>> getSearchSuggestions(String query, {int limit = 10}) async {
    try {
      if (query.trim().isEmpty) return [];
      
      final searchTerm = query.trim();
      
      // 아이템 제목에서 유사한 검색어 찾기
      final titleSuggestions = await client
          .from('items')
          .select('title')
          .ilike('title', '%$searchTerm%')
          .eq('is_available', true)
          .limit(limit);
      
      final suggestions = <String>{};
      for (final item in titleSuggestions) {
        final title = item['title'] as String;
        // 검색어를 포함한 단어들 추출
        final words = title.toLowerCase().split(' ');
        for (final word in words) {
          if (word.contains(searchTerm.toLowerCase()) && word.length > 2) {
            suggestions.add(word);
          }
        }
        // 전체 제목도 추가 (길이 제한)
        if (title.length <= 30) {
          suggestions.add(title);
        }
      }
      
      return suggestions.take(limit).toList();
    } catch (e) {
      if (Env.enableLogging) print('Get search suggestions error: $e');
      return [];
    }
  }

  // 인기 검색어 (가장 많이 검색된 키워드)
  Future<List<String>> getPopularKeywords({int limit = 10}) async {
    try {
      // TODO: 실제로는 검색 로그 테이블에서 집계해야 함
      // 지금은 인기 카테고리와 아이템을 기반으로 반환
      final popularItems = await client
          .from('items')
          .select('title, category')
          .eq('is_available', true)
          .order('rating', ascending: false)
          .limit(limit * 2);
      
      final keywords = <String>{};
      for (final item in popularItems) {
        keywords.add(item['category'] as String);
        
        // 제목에서 키워드 추출
        final title = (item['title'] as String).toLowerCase();
        final words = title.split(' ');
        for (final word in words) {
          if (word.length > 2) {
            keywords.add(word);
          }
        }
      }
      
      return keywords.take(limit).toList();
    } catch (e) {
      if (Env.enableLogging) print('Get popular keywords error: $e');
      return [];
    }
  }

  // 카테고리별 아이템 수 조회 (패싯 검색용)
  Future<Map<String, int>> getCategoryFacets({
    String? query,
    String? location,
    double? minPrice,
    double? maxPrice,
    bool onlyAvailable = true,
  }) async {
    try {
      PostgrestFilterBuilder facetQuery = client
          .from('items')
          .select('category');
      
      // 동일한 필터 조건 적용
      if (onlyAvailable) {
        facetQuery = facetQuery.eq('is_available', true);
      }
      
      if (query != null && query.trim().isNotEmpty) {
        final searchTerm = query.trim();
        facetQuery = facetQuery.or(
          'title.ilike.%$searchTerm%,'
          'description.ilike.%$searchTerm%,'
          'category.ilike.%$searchTerm%'
        );
      }
      
      if (location != null && location != '전체') {
        facetQuery = facetQuery.ilike('location', '%$location%');
      }
      
      if (minPrice != null) {
        facetQuery = facetQuery.gte('price', minPrice);
      }
      if (maxPrice != null) {
        facetQuery = facetQuery.lte('price', maxPrice);
      }
      
      final response = await facetQuery;
      
      // 카테고리별 개수 집계
      final categoryCount = <String, int>{};
      for (final item in response) {
        final category = item['category'] as String;
        categoryCount[category] = (categoryCount[category] ?? 0) + 1;
      }
      
      return categoryCount;
    } catch (e) {
      if (Env.enableLogging) print('Get category facets error: $e');
      return {};
    }
  }

  // 위치별 아이템 수 조회
  Future<Map<String, int>> getLocationFacets({
    String? query,
    String? category,
    double? minPrice,
    double? maxPrice,
    bool onlyAvailable = true,
  }) async {
    try {
      PostgrestFilterBuilder facetQuery = client
          .from('items')
          .select('location');
      
      if (onlyAvailable) {
        facetQuery = facetQuery.eq('is_available', true);
      }
      
      if (query != null && query.trim().isNotEmpty) {
        final searchTerm = query.trim();
        facetQuery = facetQuery.or(
          'title.ilike.%$searchTerm%,'
          'description.ilike.%$searchTerm%,'
          'category.ilike.%$searchTerm%'
        );
      }
      
      if (category != null && category != '전체') {
        facetQuery = facetQuery.eq('category', category);
      }
      
      if (minPrice != null) {
        facetQuery = facetQuery.gte('price', minPrice);
      }
      if (maxPrice != null) {
        facetQuery = facetQuery.lte('price', maxPrice);
      }
      
      final response = await facetQuery;
      
      final locationCount = <String, int>{};
      for (final item in response) {
        final location = item['location'] as String;
        locationCount[location] = (locationCount[location] ?? 0) + 1;
      }
      
      return locationCount;
    } catch (e) {
      if (Env.enableLogging) print('Get location facets error: $e');
      return {};
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
      
      return response;
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