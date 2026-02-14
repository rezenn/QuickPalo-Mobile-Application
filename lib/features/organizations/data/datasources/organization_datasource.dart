import 'package:quickpalo/features/organizations/data/models/organization_api_model.dart';
import 'package:quickpalo/features/organizations/data/models/organization_hive_model.dart';

abstract interface class IOrganizationRemoteDataSource {
  Future<List<OrganizationApiModel>> getAllOrganizations();
  Future<OrganizationApiModel> getOrganizationById(String organizationId);
}

abstract interface class IOrganizationLocalDataSource {
  Future<List<OrganizationHiveModel>> getAllOrganizations();
  Future<OrganizationHiveModel?> getOrganizationById(String organizationId);
}
