import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';
import 'package:quickpalo/features/organizations/domain/repositories/organization_repository.dart';
import 'package:quickpalo/features/organizations/domain/usecases/get_all_organizations.dart';

class MockOrganizationRepository extends Mock
    implements IOrganizationRepository {}

void main() {
  late GetAllOrganizationsUsecase usecase;
  late MockOrganizationRepository mockRepository;

  final tOrganizations = [
    OrganizationEntity(
      id: 'org1',
      organizationName: 'Hospital A',
      departments: [],
      timeSlots: [],
      workingHours: [],
      organizationType: OrganizationType.hospital,
      street: '',
      city: '',
    ),
    OrganizationEntity(
      id: 'org2',
      organizationName: 'Hospital B',
      departments: [],
      timeSlots: [],
      workingHours: [],
      organizationType: OrganizationType.hospital,
      street: '',
      city: '',
    ),
  ];

  setUp(() {
    mockRepository = MockOrganizationRepository();
    usecase =
        GetAllOrganizationsUsecase(organizationRepository: mockRepository);
  });

  test('should call repository', () async {
    when(() => mockRepository.getAllOrganizations())
        .thenAnswer((_) async => Right(tOrganizations));

    await usecase();

    verify(() => mockRepository.getAllOrganizations()).called(1);
  });

  test('should return list of organizations when successful', () async {
    when(() => mockRepository.getAllOrganizations())
        .thenAnswer((_) async => Right(tOrganizations));

    final result = await usecase();

    expect(result, Right(tOrganizations));
  });

  test('should return failure when repository fails', () async {
    final failure = ApiFailure(message: 'Failed to fetch');
    when(() => mockRepository.getAllOrganizations())
        .thenAnswer((_) async => Left(failure));

    final result = await usecase();

    expect(result, Left(failure));
  });
}
