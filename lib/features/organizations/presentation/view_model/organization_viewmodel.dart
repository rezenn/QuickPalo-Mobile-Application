import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/organizations/domain/usecases/get_all_organizations.dart';
import 'package:quickpalo/features/organizations/domain/usecases/get_organization_by_id.dart';
import 'package:quickpalo/features/organizations/presentation/state/organization_state.dart';

final organizationViewModelProvider =
    NotifierProvider<OrganizationViewModel, OrganizationState>(
  OrganizationViewModel.new,
);

class OrganizationViewModel extends Notifier<OrganizationState> {
  late final GetAllOrganizationsUsecase _getAllOrganizations;
  late final GetOrganizationByIdUsecase _getOrganizationById;

  @override
  OrganizationState build() {
    _getAllOrganizations = ref.read(getAllOrganizationsUsecaseProvider);
    _getOrganizationById = ref.read(getOrganizationByIdUsecaseProvider);

    return const OrganizationState();
  }

  Future<void> getAllOrganizations() async {
    state = state.copyWith(status: OrganizationStatus.loading);

    try {
      final result = await _getAllOrganizations();

      result.fold(
        (failure) {
          state = state.copyWith(
            status: OrganizationStatus.error,
            errorMessage: _mapFailureToMessage(failure),
          );
        },
        (organizations) {
          state = state.copyWith(
            status: OrganizationStatus.loaded,
            organizations: organizations,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: OrganizationStatus.error,
        errorMessage: 'Unexpected error: $e',
      );
    }
  }

  Future<void> getOrganizationById(String id) async {
    state = state.copyWith(status: OrganizationStatus.loading);

    try {
      final result = await _getOrganizationById(
        GetOrganizationByIdParams(organizationId: id),
      );

      result.fold(
        (failure) {
          state = state.copyWith(
            status: OrganizationStatus.error,
            errorMessage: _mapFailureToMessage(failure),
          );
        },
        (organization) {
          state = state.copyWith(
            status: OrganizationStatus.loaded,
            selectedOrganization: organization,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: OrganizationStatus.error,
        errorMessage: 'Unexpected error: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(resetErrorMessage: true);
  }

  void clearSelectedOrganization() {
    state = state.copyWith(resetSelectedOrganization: true);
  }

  void clearState() {
    state = state.copyWith(
      status: OrganizationStatus.initial,
      resetErrorMessage: true,
      resetSelectedOrganization: true,
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server error  ${failure.message ?? "Unknown error"}';
    } else if (failure is NetworkFailure) {
      return 'Network error: ${failure.message ?? "Please check your connection"}';
    } else {
      return 'Unexpected error: ${failure.message ?? "Unknown error"}';
    }
  }
}
