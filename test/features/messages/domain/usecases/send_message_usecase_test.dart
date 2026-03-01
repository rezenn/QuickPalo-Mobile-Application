import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/messages/domain/entities/message_entity.dart';
import 'package:quickpalo/features/messages/domain/repositories/message_repository.dart';
import 'package:quickpalo/features/messages/domain/usecases/send_message_usecase.dart';

class MockMessageRepository extends Mock implements IMessageRepository {}

void main() {
  late SendMessageUsecase usecase;
  late MockMessageRepository mockRepository;

  const tOrgUserId = 'org456';
  const tMessageText = 'Hello, this is a test message';

  final tMessageEntity = MessageEntity(
    id: 'msg123',
    channelId: 'user123_org456',
    text: tMessageText,
    userId: 'user123',
    userName: 'John Doe',
    createdAt: DateTime(2024, 1, 15, 10, 30),
  );

  const tParams = SendMessageParams(
    orgUserId: tOrgUserId,
    message: tMessageText,
  );

  setUp(() {
    mockRepository = MockMessageRepository();
    usecase = SendMessageUsecase(mockRepository);
  });

  group('SendMessageUsecase', () {
    test('should call repository with correct parameters', () async {
      when(() => mockRepository.sendMessageToOrganization(any(), any()))
          .thenAnswer((_) async => Right(tMessageEntity));

      await usecase(tParams);

      verify(() => mockRepository.sendMessageToOrganization(
            tOrgUserId,
            tMessageText,
          )).called(1);
    });

    test('should return MessageEntity when send succeeds', () async {
      when(() => mockRepository.sendMessageToOrganization(tOrgUserId, tMessageText))
          .thenAnswer((_) async => Right(tMessageEntity));

      final result = await usecase(tParams);

      expect(result, Right(tMessageEntity));
    });

    test('should return failure when send fails', () async {
      final failure = ServerFailure(message: 'Failed to send message');
      when(() => mockRepository.sendMessageToOrganization(tOrgUserId, tMessageText))
          .thenAnswer((_) async => Left(failure));

      final result = await usecase(tParams);

      expect(result, Left(failure));
    });

    test('should handle empty message', () async {
      const emptyParams = SendMessageParams(orgUserId: tOrgUserId, message: '');
      
      when(() => mockRepository.sendMessageToOrganization(tOrgUserId, ''))
          .thenAnswer((_) async => Right(tMessageEntity));

      final result = await usecase(emptyParams);

      expect(result, Right(tMessageEntity));
      verify(() => mockRepository.sendMessageToOrganization(tOrgUserId, '')).called(1);
    });
  });
}