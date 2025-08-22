import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    required String id,
    required String itemId,
    required String reviewerId,
    required String reviewedUserId,
    required double rating,
    required String comment,
    List<String>? imageUrls,
    @Default(false) bool isAnonymous,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) => 
      _$ReviewModelFromJson(json);
}