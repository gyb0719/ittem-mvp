import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_model.freezed.dart';
part 'item_model.g.dart';

@freezed
class ItemModel with _$ItemModel {
  const factory ItemModel({
    required String id,
    required String title,
    required String description,
    required int price,
    required String imageUrl,
    required String category,
    required String location,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default(true) bool isAvailable,
    required DateTime createdAt,
    double? latitude,
    double? longitude,
    String? ownerId,
    List<String>? imageUrls,
  }) = _ItemModel;

  factory ItemModel.fromJson(Map<String, dynamic> json) => 
      _$ItemModelFromJson(json);
}