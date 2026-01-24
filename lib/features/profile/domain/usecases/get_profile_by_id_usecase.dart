import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/core/usecases/app_usecase.dart';
import 'package:quickpalo/features/profile/data/repositories/profile_repository.dart';
import 'package:quickpalo/features/profile/domain/entities/profile_entity.dart';
import 'package:quickpalo/features/profile/domain/repositories/profile_repository.dart';

class GetProfileByIdParams extends Equatable {
  final String userId;

  const GetProfileByIdParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final getProfileByIdUsecaseProvider = Provider<GetProfileByIdUsecase>((ref) {
  final profileRepository = ref.read(profileRepositoryProvider);
  return GetProfileByIdUsecase(profileRepository: profileRepository);
});

class GetProfileByIdUsecase
    implements UsecaseWithParams<ProfileEntity, GetProfileByIdParams> {
  final IProfileRepository _profileRepository;

  GetProfileByIdUsecase({required IProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, ProfileEntity>> call(GetProfileByIdParams params) {
    return _profileRepository.getProfileById(params.userId);
  }
}
