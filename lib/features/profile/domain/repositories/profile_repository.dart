import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/profile/domain/entities/profile_entity.dart';

abstract interface class IProfileRepository {
  Future<Either<Failure, List<ProfileEntity>>> getAllProfiles();
  Future<Either<Failure, List<ProfileEntity>>> getItemsByUser(String userId);
  Future<Either<Failure, List<ProfileEntity>>> getLostItems();
  Future<Either<Failure, List<ProfileEntity>>> getFoundItems();
  Future<Either<Failure, List<ProfileEntity>>> getItemsByCategory(
    String categoryId,
  );
  Future<Either<Failure, ProfileEntity>> getItemById(String itemId);
  Future<Either<Failure, bool>> createItem(ProfileEntity item);
  Future<Either<Failure, bool>> updateItem(ProfileEntity item);
  Future<Either<Failure, bool>> deleteItem(String itemId);
  Future<Either<Failure, String>> uploadPhoto(File photo);
}
