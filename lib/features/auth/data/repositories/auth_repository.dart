import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/core/services/connectivity/network_info.dart';
import 'package:quickpalo/features/auth/data/datasources/auth_datasource.dart';
import 'package:quickpalo/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:quickpalo/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:quickpalo/features/auth/data/model/auth_register_api_model.dart';
import 'package:quickpalo/features/auth/data/model/auth_hive_model.dart';
import 'package:quickpalo/features/auth/domain/entities/auth_entity.dart';
import 'package:quickpalo/features/auth/domain/repositories/auth_repository.dart';

// Create provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDatasource = ref.read(authLocalDatasourceProvider);
  final authRemoteDatasource = ref.read(authRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return AuthRepository(
    authDatasource: authDatasource,
    authRemoteDataSource: authRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthDataSource _authDataSource;
  final IAuthRemoteDataSource _authRemoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthDataSource authDatasource,
    required IAuthRemoteDataSource authRemoteDataSource,
    required NetworkInfo networkInfo,
  })  : _authDataSource = authDatasource,
        _authRemoteDataSource = authRemoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, AuthEntity>> login(
      String email, String password) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiUser = await _authRemoteDataSource.login(email, password);

        if (apiUser != null) {
          // save locally in Hive without password check
          final localModel = AuthHiveModel.fromEntity(apiUser.toEntity());
          await _authDataSource.register(localModel);

          return Right(apiUser.toEntity());
        } else {
          return Left(ApiFailure(message: "Invalid email or password"));
        }
      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? "Login failed",
          statusCode: e.response?.statusCode,
        ));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      // offline login (only compare Hive-stored plaintext passwords)
      try {
        final localUser = await _authDataSource.login(email, password);
        if (localUser != null) return Right(localUser.toEntity());
        return Left(LocalDatabaseFailure(message: "Invalid email or password"));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity user) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthRegisterApiModel.fromEntity(user);

        // Capture returned user from API
        final registeredUser = await _authRemoteDataSource.register(apiModel);

        // Optionally store locally in Hive
        final localModel = AuthHiveModel.fromEntity(registeredUser.toEntity());
        await _authDataSource.register(localModel);

        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? "Registration failed",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      // Offline registration
      try {
        final existingUser = await _authDataSource.getUserByEmail(user.email);
        if (existingUser != null) {
          return const Left(
            LocalDatabaseFailure(message: "Email already registered"),
          );
        }

        final authModel = AuthHiveModel(
          fullName: user.fullName,
          email: user.email,
          phoneNumber: user.phoneNumber,
          password: user.password,
          profilePicture: user.profilePicture,
        );

        await _authDataSource.register(authModel);
        return const Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authDataSource.logout();
      if (result) {
        return Right(true);
      } else {
        return Left(LocalDatabaseFailure(message: "Logout failed"));
      }
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
