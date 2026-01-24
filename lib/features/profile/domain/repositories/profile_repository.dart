import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/profile/domain/entities/profile_entity.dart';

abstract interface class IProfileRepository {
  Future<Either<Failure, List<ProfileEntity>>> getAllProfiles();

  Future<Either<Failure, ProfileEntity>> getProfileById(String userId);
  Future<Either<Failure, bool>> updateProfile(ProfileEntity profile);
  Future<Either<Failure, bool>> deleteProfile(String userId);
  Future<Either<Failure, String>> uploadPhoto(File photo);
}
