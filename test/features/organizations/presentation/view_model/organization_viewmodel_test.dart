import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';
import 'package:quickpalo/features/organizations/domain/usecases/get_all_organizations.dart';
import 'package:quickpalo/features/organizations/domain/usecases/get_organization_by_id.dart';
import 'package:quickpalo/features/organizations/presentation/state/organization_state.dart';
import 'package:quickpalo/features/organizations/presentation/view_model/organization_viewmodel.dart';

class MockGetAllOrganizationsUsecase extends Mock
    implements GetAllOrganizationsUsecase {}

class MockGetOrganizationByIdUsecase extends Mock
    implements GetOrganizationByIdUsecase {}

void main() {
  late ProviderContainer container;
  late MockGetAllOrganizationsUsecase mockGetAll;
  late MockGetOrganizationByIdUsecase mockGetById;

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
      organizationType: OrganizationType.clinic,
      street: '',
      city: '',
    ),
  ];

  final tOrganization = OrganizationEntity(
    id: 'org1',
    organizationName: 'Hospital A',
    departments: [],
    timeSlots: [],
    workingHours: [],
    organizationType: OrganizationType.hospital,
    street: '',
    city: '',
  );

  setUp(() {
    mockGetAll = MockGetAllOrganizationsUsecase();
    mockGetById = MockGetOrganizationByIdUsecase();

    container = ProviderContainer(overrides: [
      getAllOrganizationsUsecaseProvider.overrideWithValue(mockGetAll),
      getOrganizationByIdUsecaseProvider.overrideWithValue(mockGetById),
    ]);
  });

  tearDown(() {
    container.dispose();
  });

  group('OrganizationViewModel - getAllOrganizations', () {
    test('initial state should be correct', () {
      final state = container.read(organizationViewModelProvider);
      expect(state.status, OrganizationStatus.initial);
      expect(state.organizations, []);
      expect(state.selectedOrganization, isNull);
      expect(state.errorMessage, isNull);
    });

    test('should update state to loading then loaded on success', () async {
      when(() => mockGetAll.call())
          .thenAnswer((_) async => Right(tOrganizations));

      final viewModel = container.read(organizationViewModelProvider.notifier);

      final future = viewModel.getAllOrganizations();

      expect(container.read(organizationViewModelProvider).status,
          OrganizationStatus.loading);

      await future;

      final state = container.read(organizationViewModelProvider);
      expect(state.status, OrganizationStatus.loaded);
      expect(state.organizations, tOrganizations);
      expect(state.errorMessage, isNull);
    });

    test('should update state to error on failure', () async {
      final failure = ApiFailure(message: 'Failed to load');
      when(() => mockGetAll.call()).thenAnswer((_) async => Left(failure));

      final viewModel = container.read(organizationViewModelProvider.notifier);
      await viewModel.getAllOrganizations();

      final state = container.read(organizationViewModelProvider);
      expect(state.status, OrganizationStatus.error);
      expect(state.errorMessage, 'API Error: Failed to load');
      expect(state.organizations, []);
    });

    test('should handle network failure', () async {
      final failure = NetworkFailure(message: 'No internet');
      when(() => mockGetAll.call()).thenAnswer((_) async => Left(failure));

      final viewModel = container.read(organizationViewModelProvider.notifier);
      await viewModel.getAllOrganizations();

      final state = container.read(organizationViewModelProvider);
      expect(state.status, OrganizationStatus.error);
      expect(state.errorMessage, 'Network error: No internet');
    });
  });

  group('OrganizationViewModel - getOrganizationById', () {
    const tOrgId = 'org1';
    final tParams = GetOrganizationByIdParams(organizationId: tOrgId);

    test(
        'should update state to loading then loaded with selected organization',
        () async {
      when(() => mockGetById.call(tParams))
          .thenAnswer((_) async => Right(tOrganization));

      final viewModel = container.read(organizationViewModelProvider.notifier);

      final future = viewModel.getOrganizationById(tOrgId);

      expect(container.read(organizationViewModelProvider).status,
          OrganizationStatus.loading);

      await future;

      final state = container.read(organizationViewModelProvider);
      expect(state.status, OrganizationStatus.loaded);
      expect(state.selectedOrganization, tOrganization);
      expect(state.errorMessage, isNull);
    });

    test('should update state to error when organization not found', () async {
      final failure = ApiFailure(message: 'Organization not found');
      when(() => mockGetById.call(tParams))
          .thenAnswer((_) async => Left(failure));

      final viewModel = container.read(organizationViewModelProvider.notifier);
      await viewModel.getOrganizationById(tOrgId);

      final state = container.read(organizationViewModelProvider);
      expect(state.status, OrganizationStatus.error);
      expect(state.errorMessage, 'API Error: Organization not found');
      expect(state.selectedOrganization, isNull);
    });
  });

  group('OrganizationViewModel - helper methods', () {
    test('clearError should reset error message', () async {
      // Set error first
      when(() => mockGetAll.call())
          .thenAnswer((_) async => Left(ApiFailure(message: 'Some error')));

      final viewModel = container.read(organizationViewModelProvider.notifier);
      await viewModel.getAllOrganizations();

      expect(container.read(organizationViewModelProvider).errorMessage,
          'API Error: Some error');

      // Clear error
      viewModel.clearError();

      final state = container.read(organizationViewModelProvider);
      expect(state.errorMessage, isNull);
    });
  });
}
