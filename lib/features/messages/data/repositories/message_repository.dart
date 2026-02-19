// lib/features/messages/data/repositories/message_repository.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/api/api_client.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/core/services/connectivity/network_info.dart';
import 'package:quickpalo/features/messages/data/datasources/remote/message_remote_datasource.dart';
import 'package:quickpalo/features/messages/data/models/message_api_model.dart'; // Add this import
import 'package:quickpalo/features/messages/domain/entities/message_entity.dart';
import 'package:quickpalo/features/messages/domain/entities/stream_token_entity.dart';
import 'package:quickpalo/features/messages/domain/repositories/message_repository.dart';

final messageRemoteDataSourceProvider =
    Provider<MessageRemoteDataSource>((ref) {
  final dio = ref.read(apiClientProvider).dio;
  return MessageRemoteDataSource(dio: dio);
});

final messageRepositoryProvider = Provider<IMessageRepository>((ref) {
  final remoteDataSource = ref.read(messageRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return MessageRepository(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

class MessageRepository implements IMessageRepository {
  final MessageRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  MessageRepository({
    required MessageRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, StreamTokenEntity>> getStreamToken() async {
    if (await _networkInfo.isConnected) {
      try {
        final remoteToken = await _remoteDataSource.getStreamToken();
        return Right(remoteToken.toEntity());
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessageToOrganization(
    String orgUserId,
    String message,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        print('📤 Sending message to org user: $orgUserId');
        print('📝 Message content: $message');

        final result = await _remoteDataSource.sendMessageToOrganization(
          orgUserId,
          message,
        );

        print('✅ Message sent successfully: $result');

        final messageApiModel = result['message'] as MessageApiModel;
        final messageEntity = messageApiModel.toEntity();

        return Right(messageEntity);
      } on ServerFailure catch (e) {
        print('❌ Server error: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('❌ Unexpected error: $e');
        return Left(ServerFailure(message: e.toString()));
      }
    }

    return Left(NetworkFailure());
  }
}
