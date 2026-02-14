import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/core/services/connectivity/network_info.dart';
import 'package:quickpalo/features/organizations/data/datasources/local/organization_local_datasource.dart';
import 'package:quickpalo/features/organizations/data/datasources/organization_datasource.dart';
import 'package:quickpalo/features/organizations/data/datasources/remote/organization_remote_datasource.dart';
import 'package:quickpalo/features/organizations/data/models/organization_api_model.dart';
import 'package:quickpalo/features/organizations/data/models/organization_hive_model.dart';
import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';
import 'package:quickpalo/features/organizations/domain/repositories/organization_repository.dart';

final organizationRepositoryProvider = Provider<IOrganizationRepository>((ref) {
  final localDatasource = ref.read(organizationLocalDatasourceProvider);
  final remoteDatasource = ref.read(organizationRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return OrganizationRepository(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class OrganizationRepository implements IOrganizationRepository {
  final IOrganizationLocalDataSource _localDataSource;
  final IOrganizationRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  OrganizationRepository({
    required IOrganizationLocalDataSource localDatasource,
    required IOrganizationRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  })  : _localDataSource = localDatasource,
        _remoteDataSource = remoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<OrganizationEntity>>>
      getAllOrganizations() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getAllOrganizations();
        final entities = OrganizationApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getAllOrganizations();
        final entities = OrganizationHiveModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, OrganizationEntity>> getOrganizationById(
      String organizationId) async {
    if (await _networkInfo.isConnected) {
      try {
        final model =
            await _remoteDataSource.getOrganizationById(organizationId);

        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model =
            await _localDataSource.getOrganizationById(organizationId);
        if (model != null) {
          return Right(model.toEntity());
        }
        return const Left(
            LocalDatabaseFailure(message: "Organization not found"));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<OrganizationEntity>>> getOrganizationsByType(
      OrganizationType type) {
    // TODO: implement getOrganizationsByType
    throw UnimplementedError();
  }
}
