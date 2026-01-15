// provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/api/api_client.dart';
import 'package:quickpalo/core/api/api_endpoints.dart';
import 'package:quickpalo/core/services/storage/user_session_service.dart';
import 'package:quickpalo/features/auth/data/datasources/auth_datasource.dart';
import 'package:quickpalo/features/auth/data/model/auth_api_model.dart';

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
  Future<AuthApiModel?> getUserById(String authId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient
        .post(ApiEndpoints.auth, data: {"email": email, "password": password});
    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = AuthApiModel.fromJson(data);

      await _userSessionService.saveUserSession(
          userId: user.id!,
          email: user.email,
          fullname: user.fullname,
          phoneNumber: user.phoneNumber);
      return user;
    }
    // return null;
    throw Exception(response.data['message'] ?? "Login failed");
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.register, // Use the correct endpoint
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = AuthApiModel.fromJson(data);

      // Optional: save session immediately after registration
      await _userSessionService.saveUserSession(
        userId: registeredUser.id!,
        email: registeredUser.email,
        fullname: registeredUser.fullname,
        phoneNumber: registeredUser.phoneNumber,
      );

      return registeredUser;
    } else {
      throw Exception(response.data['message'] ?? "Registration failed");
    }
  }

  // @override
  // Future<AuthApiModel?> getUserById(String authId) {
  //   throw UnimplementedError();
  // }
}
