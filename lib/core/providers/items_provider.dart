import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item.dart';
import '../repositories/items_repository.dart';

final nearbyItemsProvider = FutureProvider.family<List<Item>, Map<String, dynamic>>((ref, params) async {
  final lat = params['lat'] as double;
  final lng = params['lng'] as double;
  final radius = params['radius'] as int? ?? 5000;
  
  return await ItemsRepository.getItemsNearby(
    lat: lat,
    lng: lng,
    radiusMeters: radius,
  );
});

final allItemsProvider = FutureProvider<List<Item>>((ref) async {
  return await ItemsRepository.getAllAvailableItems();
});

final itemByIdProvider = FutureProvider.family<Item?, String>((ref, id) async {
  return await ItemsRepository.getItemById(id);
});

class MapRadiusNotifier extends StateNotifier<int> {
  MapRadiusNotifier() : super(3000); // Default 3km

  void setRadius(int radius) {
    state = radius;
  }
}

final mapRadiusProvider = StateNotifierProvider<MapRadiusNotifier, int>((ref) {
  return MapRadiusNotifier();
});

// Simple clustering logic for map markers
class ItemClusteringService {
  static List<ItemCluster> clusterItems(List<Item> items, {double clusterRadius = 0.005}) {
    final clusters = <ItemCluster>[];
    final processedItems = <String>{};

    for (final item in items) {
      if (processedItems.contains(item.id)) continue;

      final nearbyItems = <Item>[item];
      processedItems.add(item.id);

      for (final otherItem in items) {
        if (processedItems.contains(otherItem.id)) continue;

        final distance = _calculateDistance(
          item.lat,
          item.lng,
          otherItem.lat,
          otherItem.lng,
        );

        if (distance <= clusterRadius) {
          nearbyItems.add(otherItem);
          processedItems.add(otherItem.id);
        }
      }

      // Calculate cluster center (simple average)
      final centerLat = nearbyItems.map((i) => i.lat).reduce((a, b) => a + b) / nearbyItems.length;
      final centerLng = nearbyItems.map((i) => i.lng).reduce((a, b) => a + b) / nearbyItems.length;

      clusters.add(ItemCluster(
        lat: centerLat,
        lng: centerLng,
        count: nearbyItems.length,
        items: nearbyItems,
      ));
    }

    return clusters;
  }

  static double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    // Simple distance calculation (for clustering only)
    return ((lat1 - lat2).abs() + (lng1 - lng2).abs());
  }
}

final itemClustersProvider = Provider.family<List<ItemCluster>, List<Item>>((ref, items) {
  return ItemClusteringService.clusterItems(items);
});