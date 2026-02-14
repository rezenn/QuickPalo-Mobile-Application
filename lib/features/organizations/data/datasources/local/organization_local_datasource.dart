import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/services/hive/hive_service.dart';
import 'package:quickpalo/features/organizations/data/datasources/organization_datasource.dart';
import 'package:quickpalo/features/organizations/data/models/organization_hive_model.dart';

final organizationLocalDatasourceProvider =
    Provider<OrganizationLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return OrganizationLocalDatasource(hiveService: hiveService);
});

class OrganizationLocalDatasource implements IOrganizationLocalDataSource {
  final HiveService _hiveService;

  OrganizationLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<List<OrganizationHiveModel>> getAllOrganizations() async {
    try {
      return _hiveService.getAllOrganizations();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<OrganizationHiveModel?> getOrganizationById(
      String organizationId) async {
    try {
      return _hiveService.getOrganizationById(organizationId);
    } catch (e) {
      return null;
    }
  }
}
