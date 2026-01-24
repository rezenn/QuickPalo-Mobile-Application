import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/core/usecases/app_usecase.dart';
import 'package:quickpalo/features/profile/data/repositories/profile_repository.dart';
import 'package:quickpalo/features/profile/domain/repositories/profile_repository.dart';

final uploadPhotoUsecaseProvider = Provider<UploadPhotoUsecase>((ref) {
  final profileRepository = ref.read(profileRepositoryProvider);
  return UploadPhotoUsecase(profileRepository: profileRepository);
});

class UploadPhotoUsecase implements UsecaseWithParams<String, File> {
  final IProfileRepository _profileRepository;

  UploadPhotoUsecase({required IProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, String>> call(File photo) {
    return _profileRepository.uploadPhoto(photo);
  }
}
