import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';
part 'item.g.dart';

@freezed
class Item with _$Item {
  const factory Item({
    required String id,
    required String ownerId,
    required String title,
    required String description,
    required int pricePerDay,
    required int deposit,
    required double lat,
    required double lng,
    @Default([]) List<String> photos,
    @Default('available') String status,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

@freezed
class ItemCluster with _$ItemCluster {
  const factory ItemCluster({
    required double lat,
    required double lng,
    required int count,
    required List<Item> items,
  }) = _ItemCluster;
}