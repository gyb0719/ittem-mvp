// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewModelImpl _$$ReviewModelImplFromJson(Map<String, dynamic> json) =>
    _$ReviewModelImpl(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      reviewerId: json['reviewerId'] as String,
      reviewedUserId: json['reviewedUserId'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ReviewModelImplToJson(_$ReviewModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'reviewerId': instance.reviewerId,
      'reviewedUserId': instance.reviewedUserId,
      'rating': instance.rating,
      'comment': instance.comment,
      'imageUrls': instance.imageUrls,
      'isAnonymous': instance.isAnonymous,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
