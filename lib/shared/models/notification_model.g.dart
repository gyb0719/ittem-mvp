// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  message: json['message'] as String,
  type:
      $enumDecodeNullable(_$NotificationTypeEnumMap, json['type']) ??
      NotificationType.system,
  relatedId: json['relatedId'] as String?,
  imageUrl: json['imageUrl'] as String?,
  isRead: json['isRead'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  readAt: json['readAt'] == null
      ? null
      : DateTime.parse(json['readAt'] as String),
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'title': instance.title,
  'message': instance.message,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'relatedId': instance.relatedId,
  'imageUrl': instance.imageUrl,
  'isRead': instance.isRead,
  'createdAt': instance.createdAt.toIso8601String(),
  'readAt': instance.readAt?.toIso8601String(),
};

const _$NotificationTypeEnumMap = {
  NotificationType.message: 'message',
  NotificationType.itemUpdate: 'itemUpdate',
  NotificationType.rental: 'rental',
  NotificationType.review: 'review',
  NotificationType.system: 'system',
};
