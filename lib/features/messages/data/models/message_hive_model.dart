import 'package:hive/hive.dart';
import 'package:quickpalo/core/constants/hive_table_constants.dart';
import 'package:quickpalo/features/messages/domain/entities/message_entity.dart';

part 'message_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.messageTypeId)
class MessageHiveModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String channelId;
  
  @HiveField(2)
  final String text;
  
  @HiveField(3)
  final String userId;
  
  @HiveField(4)
  final String userName;
  
  @HiveField(5)
  final String? userImage;
  
  @HiveField(6)
  final DateTime createdAt;
  
  @HiveField(7)
  final bool isFromMe;

  MessageHiveModel({
    required this.id,
    required this.channelId,
    required this.text,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.createdAt,
    required this.isFromMe,
  });

  factory MessageHiveModel.fromEntity(MessageEntity entity, String currentUserId) {
    return MessageHiveModel(
      id: entity.id,
      channelId: entity.channelId,
      text: entity.text,
      userId: entity.userId,
      userName: entity.userName,
      userImage: entity.userImage,
      createdAt: entity.createdAt,
      isFromMe: entity.userId == currentUserId,
    );
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      channelId: channelId,
      text: text,
      userId: userId,
      userName: userName,
      userImage: userImage,
      createdAt: createdAt,
    );
  }
}