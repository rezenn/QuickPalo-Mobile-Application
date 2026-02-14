import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/core/usecases/app_usecase.dart';
import 'package:quickpalo/features/organizations/data/repositories/organization_repository.dart';
import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';
import 'package:quickpalo/features/organizations/domain/repositories/organization_repository.dart';

final getAllOrganizationsUsecaseProvider =
    Provider<GetAllOrganizationsUsecase>((ref) {
  final organizationRepository = ref.read(organizationRepositoryProvider);
  return GetAllOrganizationsUsecase(
      organizationRepository: organizationRepository);
});

class GetAllOrganizationsUsecase
    implements UsecaseWithoutParams<List<OrganizationEntity>> {
  final IOrganizationRepository _organizationRepository;

  GetAllOrganizationsUsecase(
      {required IOrganizationRepository organizationRepository})
      : _organizationRepository = organizationRepository;

  @override
  Future<Either<Failure, List<OrganizationEntity>>> call() {
    return _organizationRepository.getAllOrganizations();
  }
}
