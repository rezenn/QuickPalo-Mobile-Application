import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/core/usecases/app_usecase.dart';
import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';
import 'package:quickpalo/features/organizations/domain/repositories/organization_repository.dart';

class GetOrganizationsByType
    implements
        UsecaseWithParams<List<OrganizationEntity>,
            GetOrganizationsByTypeParams> {
  final IOrganizationRepository repository;

  GetOrganizationsByType(this.repository);

  @override
  Future<Either<Failure, List<OrganizationEntity>>> call(
      GetOrganizationsByTypeParams params) {
    return repository.getOrganizationsByType(params.type);
  }
}

class GetOrganizationsByTypeParams extends Equatable {
  final OrganizationType type;

  const GetOrganizationsByTypeParams({required this.type});

  @override
  List<Object?> get props => [type];
}
