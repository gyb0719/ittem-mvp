import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

@freezed
class ChatModel with _$ChatModel {
  const factory ChatModel({
    required String id,
    required String itemId,
    required String buyerId,
    required String sellerId,
    String? lastMessage,
    DateTime? lastMessageAt,
    @Default(0) int unreadCount,
    @Default(true) bool isActive,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) => 
      _$ChatModelFromJson(json);
}