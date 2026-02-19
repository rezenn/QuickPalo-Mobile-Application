import 'package:hive/hive.dart';
import 'package:quickpalo/core/constants/hive_table_constants.dart';
import 'package:quickpalo/features/messages/data/models/message_hive_model.dart';
import 'package:quickpalo/features/messages/domain/entities/message_entity.dart';

abstract class IMessageLocalDataSource {
  Future<void> saveMessage(MessageHiveModel message);
  Future<void> saveMessages(List<MessageHiveModel> messages);
  Future<List<MessageEntity>> getMessagesForChannel(String channelId);
  Future<void> clearChannelMessages(String channelId);
}

class MessageLocalDataSource implements IMessageLocalDataSource {
  Box<MessageHiveModel> get _messageBox =>
      Hive.box<MessageHiveModel>(HiveTableConstant.messageTable);

  @override
  Future<void> saveMessage(MessageHiveModel message) async {
    await _messageBox.put(message.id, message);
  }

  @override
  Future<void> saveMessages(List<MessageHiveModel> messages) async {
    for (var message in messages) {
      await _messageBox.put(message.id, message);
    }
  }

  @override
  Future<List<MessageEntity>> getMessagesForChannel(String channelId) async {
    final messages = _messageBox.values
        .where((message) => message.channelId == channelId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort by date desc

    return messages.map((message) => message.toEntity()).toList();
  }

  @override
  Future<void> clearChannelMessages(String channelId) async {
    final messages = _messageBox.values
        .where((message) => message.channelId == channelId)
        .toList();

    for (var message in messages) {
      await _messageBox.delete(message.id);
    }
  }
}
