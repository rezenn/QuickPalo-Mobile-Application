// provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/api/api_client.dart';
import 'package:quickpalo/core/api/api_endpoints.dart';
import 'package:quickpalo/core/services/storage/user_session_service.dart';
import 'package:quickpalo/features/auth/data/datasources/auth_datasource.dart';
import 'package:quickpalo/features/auth/data/model/auth_register_api_model.dart';

final authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  })  : _apiClient = apiClient,
        _userSessionService = userSessionService;

  @override
  Future<AuthRegisterApiModel?> getUserById(String authId) {
    throw UnimplementedError();
  }

  @override
  Future<AuthRegisterApiModel?> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {"email": email, "password": password},
      );

      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final user = AuthRegisterApiModel.fromJson(data);

        // Save session
        await _userSessionService.saveUserSession(
          userId: user.id!,
          email: user.email,
          fullName: user.fullName,
          phoneNumber: user.phoneNumber,
          profileImage: user.profilePicture != null
              ? ApiEndpoints.imageUrl(user.profilePicture!)
              : null,
        );

        return user;
      } else {
        return null;
      }
    } catch (_) {
      return null; // network failure fallback
    }
  }

  @override
  Future<AuthRegisterApiModel> register(AuthRegisterApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.register, // Use the correct endpoint
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = AuthRegisterApiModel.fromJson(data);

      // Optional: save session immediately after registration
      await _userSessionService.saveUserSession(
        userId: user.id!,
        email: user.email,
        fullName: user.fullName,
        phoneNumber: user.phoneNumber,
        profileImage: user.profilePicture != null
            ? ApiEndpoints.imageUrl(user.profilePicture!)
            : null,
      );

      return registeredUser;
    } else {
      throw Exception(response.data['message'] ?? "Registration failed");
    }
  }

  @override
  Future<bool> logout() async {
    await _userSessionService.clearSession();
    return true;
  }

  // @override
  // Future<AuthApiModel?> getUserById(String authId) {
  //   throw UnimplementedError();
  // }
}
