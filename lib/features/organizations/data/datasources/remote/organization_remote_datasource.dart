import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/api/api_client.dart';
import 'package:quickpalo/core/api/api_endpoints.dart';
import 'package:quickpalo/core/services/storage/token_service.dart';
import 'package:quickpalo/features/organizations/data/datasources/organization_datasource.dart';
import 'package:quickpalo/features/organizations/data/models/organization_api_model.dart';

final organizationRemoteDatasourceProvider =
    Provider<IOrganizationRemoteDataSource>((ref) {
  return OrganizationRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class OrganizationRemoteDatasource implements IOrganizationRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  OrganizationRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService;

  @override
  Future<List<OrganizationApiModel>> getAllOrganizations() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.organizations);

      if (response.data['success'] == true) {
        final data = response.data['data'];

        if (data is List) {
          List<OrganizationApiModel> organizations = [];
          for (int i = 0; i < data.length; i++) {
            try {
              final item = data[i];
              if (item is Map<String, dynamic>) {
                final org = OrganizationApiModel.fromJson(item);
                organizations.add(org);
              }
            } catch (e) {
              throw Exception('Failed to fetch organizations: $e');
            }
          }

          return organizations;
        } else {
          return [];
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch organizations: $e');
    }
  }

  @override
  Future<OrganizationApiModel> getOrganizationById(
      String organizationId) async {
    try {
      final response =
          await _apiClient.get(ApiEndpoints.organizationById(organizationId));

      if (response.data['success'] == true) {
        return OrganizationApiModel.fromJson(response.data['data']);
      }
      throw Exception('Organization not found');
    } catch (e) {
      throw Exception('Failed to fetch organization: $e');
    }
  }
}
