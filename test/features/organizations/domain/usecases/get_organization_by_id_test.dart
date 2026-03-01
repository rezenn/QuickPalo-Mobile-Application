import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';
import 'package:quickpalo/features/organizations/domain/repositories/organization_repository.dart';
import 'package:quickpalo/features/organizations/domain/usecases/get_organization_by_id.dart';

class MockOrganizationRepository extends Mock
    implements IOrganizationRepository {}

void main() {
  late GetOrganizationByIdUsecase usecase;
  late MockOrganizationRepository mockRepository;

  const tOrgId = 'org123';
  const tParams = GetOrganizationByIdParams(organizationId: tOrgId);

  final tOrganization = OrganizationEntity(
    id: tOrgId,
    organizationName: 'Test Hospital',
    departments: [],
    timeSlots: [],
    workingHours: [],
    organizationType: OrganizationType.hospital,
    street: '',
    city: '',
  );

  setUp(() {
    mockRepository = MockOrganizationRepository();
    usecase =
        GetOrganizationByIdUsecase(organizationRepository: mockRepository);
  });

  test('should call repository with correct id', () async {
    when(() => mockRepository.getOrganizationById(any()))
        .thenAnswer((_) async => Right(tOrganization));

    await usecase(tParams);

    verify(() => mockRepository.getOrganizationById(tOrgId)).called(1);
  });

  test('should return organization when successful', () async {
    when(() => mockRepository.getOrganizationById(tOrgId))
        .thenAnswer((_) async => Right(tOrganization));

    final result = await usecase(tParams);

    expect(result, Right(tOrganization));
  });

  test('should return failure when repository fails', () async {
    final failure = ApiFailure(message: 'Organization not found');
    when(() => mockRepository.getOrganizationById(tOrgId))
        .thenAnswer((_) async => Left(failure));

    final result = await usecase(tParams);

    expect(result, Left(failure));
  });
}
