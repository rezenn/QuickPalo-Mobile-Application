// lib/features/messages/data/models/message_api_model.dart
import 'package:quickpalo/features/messages/domain/entities/message_entity.dart';

class MessageApiModel {
  final String id;
  final String channelId;
  final String text;
  final String userId;
  final String userName;
  final String? userImage;
  final DateTime createdAt;

  MessageApiModel({
    required this.id,
    required this.channelId,
    required this.text,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.createdAt,
  });

  factory MessageApiModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};

    return MessageApiModel(
      id: json['id'] ?? '',
      channelId: json['channel_id'] ?? json['channelId'] ?? '',
      text: json['text'] ?? '',
      userId: user['id'] ?? json['user_id'] ?? '',
      userName: user['name'] ?? json['userName'] ?? '',
      userImage: user['image']?.toString(),
      createdAt: DateTime.parse(json['created_at'] ??
          json['createdAt'] ??
          DateTime.now().toIso8601String()),
    );
  }

  MessageEntity toEntity() => MessageEntity(
        id: id,
        channelId: channelId,
        text: text,
        userId: userId,
        userName: userName,
        userImage: userImage,
        createdAt: createdAt,
      );
}
