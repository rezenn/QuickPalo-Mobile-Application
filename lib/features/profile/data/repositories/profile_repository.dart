import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/core/services/connectivity/network_info.dart';
import 'package:quickpalo/features/profile/data/datasources/local/profile_local_datasource.dart';
import 'package:quickpalo/features/profile/data/datasources/profile_datasource.dart';
import 'package:quickpalo/features/profile/data/datasources/remote/profile_remote_datasource.dart';
import 'package:quickpalo/features/profile/data/models/profile_api_model.dart';
import 'package:quickpalo/features/profile/data/models/profile_hive_model.dart';
import 'package:quickpalo/features/profile/domain/entities/profile_entity.dart';
import 'package:quickpalo/features/profile/domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  final localDatasource = ref.read(profileLocalDatasourceProvider);
  final remoteDatasource = ref.read(profileRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return ProfileRepository(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class ProfileRepository implements IProfileRepository {
  final IProfileLocalDataSource _localDataSource;
  final IProfileRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ProfileRepository({
    required IProfileLocalDataSource localDatasource,
    required IProfileRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  })  : _localDataSource = localDatasource,
        _remoteDataSource = remoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, ProfileEntity>> getProfileById(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getProfileById(userId);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _localDataSource.getProfileById(userId);
        if (model != null) {
          return Right(model.toEntity());
        }
        return const Left(LocalDatabaseFailure(message: 'User not found'));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> updateProfile(ProfileEntity profile) async {
    if (await _networkInfo.isConnected) {
      try {
        final profileApiModel = ProfileApiModel.fromEntity(profile);
        await _remoteDataSource.updateProfile(profileApiModel);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final profileModel = ProfileHiveModel.fromEntity(profile);
        final result = await _localDataSource.updateProfile(profileModel);
        if (result) {
          return const Right(true);
        }
        return const Left(
          LocalDatabaseFailure(message: "Failed to update profile"),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, String>> uploadPhoto(File photo) async {
    if (await _networkInfo.isConnected) {
      try {
        final fileName = await _remoteDataSource.uploadPhoto(photo);
        return Right(fileName);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  // @override
  // Future<Either<Failure, bool>> deleteProfile(String userId) async {
  //   if (await _networkInfo.isConnected) {
  //     try {
  //       await _remoteDataSource.deleteProfile(userId);
  //       return const Right(true);
  //     } catch (e) {
  //       return Left(ApiFailure(message: e.toString()));
  //     }
  //   } else {
  //     try {
  //       final result = await _localDataSource.deleteProfile(userId);
  //       if (result) {
  //         return const Right(true);
  //       }
  //       return const Left(
  //         LocalDatabaseFailure(message: "Failed to delete profile"),
  //       );
  //     } catch (e) {
  //       return Left(LocalDatabaseFailure(message: e.toString()));
  //     }
  //   }
  // }

  // @override
  // Future<Either<Failure, List<ProfileEntity>>> getAllProfiles() async {
  //   if (await _networkInfo.isConnected) {
  //     try {
  //       final models = await _remoteDataSource.getAllProfiles();
  //       final entities = ProfileApiModel.toEntityList(models);
  //       return Right(entities);
  //     } catch (e) {
  //       return Left(ApiFailure(message: e.toString()));
  //     }
  //   } else {
  //     try {
  //       final models = await _localDataSource.getAllProfiles();
  //       final entities = ProfileHiveModel.toEntityList(models);
  //       return Right(entities);
  //     } catch (e) {
  //       return Left(LocalDatabaseFailure(message: e.toString()));
  //     }
  //   }
  // }
}
