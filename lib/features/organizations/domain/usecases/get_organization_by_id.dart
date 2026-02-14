import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/core/usecases/app_usecase.dart';
import 'package:quickpalo/features/organizations/data/repositories/organization_repository.dart';
import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';
import 'package:quickpalo/features/organizations/domain/repositories/organization_repository.dart';

final getOrganizationByIdUsecaseProvider =
    Provider<GetOrganizationByIdUsecase>((ref) {
  final organizationRepository = ref.read(organizationRepositoryProvider);
  return GetOrganizationByIdUsecase(
      organizationRepository: organizationRepository);
});

class GetOrganizationByIdUsecase
    implements
        UsecaseWithParams<OrganizationEntity, GetOrganizationByIdParams> {
  final IOrganizationRepository _organizationRepository;

  GetOrganizationByIdUsecase(
      {required IOrganizationRepository organizationRepository})
      : _organizationRepository = organizationRepository;

  @override
  Future<Either<Failure, OrganizationEntity>> call(
      GetOrganizationByIdParams params) {
    return _organizationRepository.getOrganizationById(params.organizationId);
  }
}

class GetOrganizationByIdParams extends Equatable {
  final String organizationId;

  const GetOrganizationByIdParams({required this.organizationId});

  @override
  List<Object?> get props => [organizationId];
}
