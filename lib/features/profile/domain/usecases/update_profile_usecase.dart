import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/core/usecases/app_usecase.dart';
import 'package:quickpalo/features/profile/data/repositories/profile_repository.dart';
import 'package:quickpalo/features/profile/domain/entities/profile_entity.dart';
import 'package:quickpalo/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileParams extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? profilePicture;

  const UpdateProfileParams({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [id, fullName, email, phoneNumber, profilePicture];
}

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  final profileRepository = ref.read(profileRepositoryProvider);
  return UpdateProfileUsecase(profileRepository: profileRepository);
});

class UpdateProfileUsecase
    implements UsecaseWithParams<bool, UpdateProfileParams> {
  final IProfileRepository _profileRepository;

  UpdateProfileUsecase({required IProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateProfileParams params) {
    final profileEntity = ProfileEntity(
      userId: params.id,
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      profilePicture: params.profilePicture,
    );
    return _profileRepository.updateProfile(profileEntity);
  }
}
