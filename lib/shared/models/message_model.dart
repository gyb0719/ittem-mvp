import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

enum MessageType {
  text,
  image,
  system,
}

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String chatId,
    required String senderId,
    required String content,
    @Default(MessageType.text) MessageType type,
    String? imageUrl,
    @Default(false) bool isRead,
    required DateTime createdAt,
    DateTime? readAt,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) => 
      _$MessageModelFromJson(json);
}