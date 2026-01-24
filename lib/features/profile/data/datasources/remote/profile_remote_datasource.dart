import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/api/api_client.dart';
import 'package:quickpalo/core/api/api_endpoints.dart';
import 'package:quickpalo/core/services/storage/token_service.dart';
import 'package:quickpalo/features/profile/data/datasources/profile_datasource.dart';
import 'package:quickpalo/features/profile/data/models/profile_api_model.dart';

final profileRemoteDatasourceProvider =
    Provider<IProfileRemoteDataSource>((ref) {
  return ProfileRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class ProfileRemoteDatasource implements IProfileRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  ProfileRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService;

  @override
  Future<bool> deleteProfile(String userId) async {
    final token = await _tokenService.getToken();
    await _apiClient.delete(
      ApiEndpoints.profileById(userId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return true;
  }

  @override
  Future<List<ProfileApiModel>> getAllProfiles() async {
    final response = await _apiClient.get(ApiEndpoints.profiles);
    final data = response.data['data'] as List;
    return data.map((json) => ProfileApiModel.fromJson(json)).toList();
  }

  @override
  Future<ProfileApiModel> getProfileById(String userId) async {
    final response = await _apiClient.get(ApiEndpoints.profileById(userId));
    return ProfileApiModel.fromJson(response.data['data']);
  }

  @override
  Future<bool> updateProfile(ProfileApiModel profile) async {
    final token = await _tokenService.getToken();
    await _apiClient.put(
      ApiEndpoints.profileById(profile.id),
      data: profile.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return true;
  }

  @override
  Future<String> uploadPhoto(File photo) async {
    final fileName = photo.path.split('/').last;
    final formData = FormData.fromMap({
      'profilePhoto':
          await MultipartFile.fromFile(photo.path, filename: fileName),
    });
    // Get token from token service
    final token = await _tokenService.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.profileUploadPhoto,
      formData: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data['data'];
  }
}
