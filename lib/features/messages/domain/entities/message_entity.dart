import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String channelId;
  final String text;
  final String userId;
  final String userName;
  final String? userImage;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.channelId,
    required this.text,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, channelId, text, userId, userName, userImage, createdAt];
}
