import 'package:dartz/dartz.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';

abstract interface class IOrganizationRepository {
  Future<Either<Failure, List<OrganizationEntity>>> getAllOrganizations();
  Future<Either<Failure, OrganizationEntity>> getOrganizationById(
    String organizationId,
  );
    Future<Either<Failure, List<OrganizationEntity>>> getOrganizationsByType(
    OrganizationType type,
  );

}
