import 'package:equatable/equatable.dart';
import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';

enum OrganizationStatus {
  initial,
  loading,
  loaded,
  error,
}

class OrganizationState extends Equatable {
  final OrganizationStatus status;
  final List<OrganizationEntity> organizations;
  final OrganizationEntity? selectedOrganization;
  final String? errorMessage;

  const OrganizationState({
    this.status = OrganizationStatus.initial,
    this.organizations = const [],
    this.selectedOrganization,
    this.errorMessage,
  });

  OrganizationState copyWith({
    OrganizationStatus? status,
    List<OrganizationEntity>? organizations,
    OrganizationEntity? selectedOrganization,
    bool resetSelectedOrganization = false,
    String? errorMessage,
    bool resetErrorMessage = false,
  }) {
    return OrganizationState(
      status: status ?? this.status,
      organizations: organizations ?? this.organizations,
      selectedOrganization: resetSelectedOrganization
          ? null
          : (selectedOrganization ?? this.selectedOrganization),
      errorMessage:
          resetErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        organizations,
        selectedOrganization,
        errorMessage,
      ];
}
