import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/core/usecases/app_usecase.dart';
import 'package:quickpalo/features/messages/data/repositories/message_repository.dart';
import 'package:quickpalo/features/messages/domain/entities/message_entity.dart';
import 'package:quickpalo/features/messages/domain/repositories/message_repository.dart';

class SendMessageParams extends Equatable {
  final String orgUserId;
  final String message;

  const SendMessageParams({
    required this.orgUserId,
    required this.message,
  });

  @override
  List<Object?> get props => [orgUserId, message];
}

final sendMessageUsecaseProvider = Provider((ref) {
  final repo = ref.read(messageRepositoryProvider);
  return SendMessageUsecase(repo);
});

class SendMessageUsecase
    implements UsecaseWithParams<MessageEntity, SendMessageParams> {
  final IMessageRepository _repository;

  SendMessageUsecase(this._repository);

  @override
  Future<Either<Failure, MessageEntity>> call(SendMessageParams params) {
    return _repository.sendMessageToOrganization(
      params.orgUserId,
      params.message,
    );
  }
}
