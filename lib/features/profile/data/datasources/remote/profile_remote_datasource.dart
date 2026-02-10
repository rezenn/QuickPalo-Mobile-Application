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

  // @override
  // Future<List<ProfileApiModel>> getAllProfiles() async {
  //   final token = await _tokenService.getToken();
  //   if (token == null) throw Exception('No token found');

  //   final response = await _apiClient.get(
  //     ApiEndpoints.profiles,
  //     options: Options(headers: {'Authorization': 'Bearer $token'}),
  //   );
  //   final data = response.data['data'] as List;
  //   return data.map((json) => ProfileApiModel.fromJson(json)).toList();
  // }

  @override
  Future<ProfileApiModel> getProfileById(String userId) async {
    final token = await _tokenService.getToken();
    if (token == null) throw Exception('No token found');

    final response = await _apiClient.get(
      ApiEndpoints.profileById(userId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return ProfileApiModel.fromJson(response.data['data']);
  }

  @override
  Future<bool> updateProfile(ProfileApiModel profile) async {
    final token = await _tokenService.getToken();
    if (token == null) throw Exception('No token found');

    final updateData = {
      "fullName": profile.fullName,
      "email": profile.email,
      "phoneNumber": profile.phoneNumber,
      if (profile.profilePicture != null &&
          !profile.profilePicture!.startsWith('http'))
        "profilePicture": profile.profilePicture,
    };

    try {
      final response = await _apiClient.put(
        ApiEndpoints.profileUploadPhoto, // This is /auth/update-user
        data: updateData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> uploadPhoto(File photo) async {
    final token = await _tokenService.getToken();
    if (token == null) throw Exception('No token found');

    final fileName = photo.path.split('/').last;
    final formData = FormData.fromMap({
      'profilePicture':
          await MultipartFile.fromFile(photo.path, filename: fileName),
    });

    final response = await _apiClient.put(
      ApiEndpoints.profileUploadPhoto, // Use the same endpoint
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    // Extract filename from response
    final data = response.data['data'];
    if (data is Map<String, dynamic>) {
      return data['profilePicture'] as String;
    }
    throw Exception('Invalid response format');
  }
}
