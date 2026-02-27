import 'package:dartz/dartz.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/messages/domain/entities/message_entity.dart';
import 'package:quickpalo/features/messages/domain/entities/stream_token_entity.dart';

abstract interface class IMessageRepository {
  Future<Either<Failure, StreamTokenEntity>> getStreamToken();
  Future<Either<Failure, MessageEntity>> sendMessageToOrganization(
    String orgUserId,
    String message,
  );
}
