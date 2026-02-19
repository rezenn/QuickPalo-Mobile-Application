import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/core/usecases/app_usecase.dart';
import 'package:quickpalo/features/messages/data/repositories/message_repository.dart';
import '../entities/stream_token_entity.dart';
import '../repositories/message_repository.dart';

class GetStreamTokenParams extends Equatable {
  const GetStreamTokenParams();
  @override
  List<Object?> get props => [];
}

final getStreamTokenUsecaseProvider = Provider((ref) {
  final repo = ref.read(messageRepositoryProvider);
  return GetStreamTokenUsecase(repo);
});

class GetStreamTokenUsecase
    implements UsecaseWithParams<StreamTokenEntity, GetStreamTokenParams> {
  final IMessageRepository _repository;
  GetStreamTokenUsecase(this._repository);

  @override
  Future<Either<Failure, StreamTokenEntity>> call(GetStreamTokenParams params) {
    return _repository.getStreamToken();
  }
}
