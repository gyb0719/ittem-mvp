import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import '../models/item.dart';

class ItemsRepository {
  static final _logger = Logger();
  static final _supabase = Supabase.instance.client;

  static Future<List<Item>> getItemsNearby({
    required double lat,
    required double lng,
    int radiusMeters = 5000,
  }) async {
    try {
      final response = await _supabase.rpc('items_nearby', params: {
        'lat': lat,
        'lng': lng,
        'meters': radiusMeters,
      });

      if (response == null) return [];

      return (response as List)
          .map((json) => Item.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      _logger.e('Failed to fetch nearby items', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  static Future<List<Item>> getAllAvailableItems() async {
    try {
      final response = await _supabase
          .from('items')
          .select()
          .eq('status', 'available')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Item.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      _logger.e('Failed to fetch all items', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  static Future<Item?> getItemById(String id) async {
    try {
      final response = await _supabase
          .from('items')
          .select()
          .eq('id', id)
          .single();

      return Item.fromJson(response);
    } catch (e, stackTrace) {
      _logger.e('Failed to fetch item by ID', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  static Future<String?> createItem({
    required String ownerId,
    required String title,
    required String description,
    required int pricePerDay,
    required int deposit,
    required double lat,
    required double lng,
    List<String> photos = const [],
  }) async {
    try {
      final response = await _supabase
          .from('items')
          .insert({
            'owner_id': ownerId,
            'title': title,
            'description': description,
            'price_per_day': pricePerDay,
            'deposit': deposit,
            'lat': lat,
            'lng': lng,
            'photos': photos,
            'status': 'available',
          })
          .select('id')
          .single();

      return response['id'] as String;
    } catch (e, stackTrace) {
      _logger.e('Failed to create item', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  static Future<bool> updateItem(String id, Map<String, dynamic> updates) async {
    try {
      await _supabase
          .from('items')
          .update(updates)
          .eq('id', id);

      return true;
    } catch (e, stackTrace) {
      _logger.e('Failed to update item', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  static Future<bool> deleteItem(String id) async {
    try {
      await _supabase
          .from('items')
          .delete()
          .eq('id', id);

      return true;
    } catch (e, stackTrace) {
      _logger.e('Failed to delete item', error: e, stackTrace: stackTrace);
      return false;
    }
  }
}