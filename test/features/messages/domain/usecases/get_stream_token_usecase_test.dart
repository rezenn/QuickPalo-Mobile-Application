import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/messages/domain/entities/stream_token_entity.dart';
import 'package:quickpalo/features/messages/domain/repositories/message_repository.dart';
import 'package:quickpalo/features/messages/domain/usecases/get_stream_token_usecase.dart';

class MockMessageRepository extends Mock implements IMessageRepository {}

void main() {
  late GetStreamTokenUsecase usecase;
  late MockMessageRepository mockRepository;

  const tStreamToken = StreamTokenEntity(
    apiKey: 'api_key_123',
    token: 'stream_token_123',
    userId: 'user123',
    userName: 'John Doe',
    role: 'user',
  );

  setUp(() {
    mockRepository = MockMessageRepository();
    usecase = GetStreamTokenUsecase(mockRepository);
  });

  group('GetStreamTokenUsecase', () {
    test('should call repository', () async {
      when(() => mockRepository.getStreamToken())
          .thenAnswer((_) async => const Right(tStreamToken));

      await usecase(const GetStreamTokenParams());

      verify(() => mockRepository.getStreamToken()).called(1);
    });

    test('should return StreamTokenEntity when successful', () async {
      when(() => mockRepository.getStreamToken())
          .thenAnswer((_) async => const Right(tStreamToken));

      final result = await usecase(const GetStreamTokenParams());

      expect(result, const Right(tStreamToken));
    });

    test('should return failure when repository fails', () async {
      final failure = ServerFailure(message: 'Failed to get token');
      when(() => mockRepository.getStreamToken())
          .thenAnswer((_) async => Left(failure));

      final result = await usecase(const GetStreamTokenParams());

      expect(result, Left(failure));
    });
  });
}