import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/api/api_client.dart';
import 'package:quickpalo/core/api/api_endpoints.dart';
import 'package:quickpalo/core/services/storage/token_service.dart';
import 'package:quickpalo/core/services/storage/user_session_service.dart';
import 'package:quickpalo/features/auth/data/datasources/auth_datasource.dart';
import 'package:quickpalo/features/auth/data/model/auth_register_api_model.dart';

final authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _userSessionService = userSessionService,
        _tokenService = tokenService;

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
        final token = response.data['token'] as String;

        // Save token
        await _tokenService.saveToken(token);

        final user = AuthRegisterApiModel.fromJson(data);

        // Save session only if user has an ID
        if (user.id != null) {
          await _userSessionService.saveUserSession(
            userId: user.id!,
            email: user.email,
            fullName: user.fullName,
            phoneNumber: user.phoneNumber,
            profileImage: user.profilePicture != null
                ? ApiEndpoints.imageUrl(user.profilePicture!)
                : null,
          );
        }

        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null; // network failure fallback
    }
  }

  @override
  Future<AuthRegisterApiModel> register(AuthRegisterApiModel user) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: user.toJson(),
      );

      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final token = response.data['token'] as String?;

        // Save token if provided
        if (token != null) {
          await _tokenService.saveToken(token);
        }

        final registeredUser = AuthRegisterApiModel.fromJson(data);

        // Save session immediately after registration if we have user ID
        if (registeredUser.id != null && registeredUser.id!.isNotEmpty) {
          await _userSessionService.saveUserSession(
            userId: registeredUser.id!,
            email: registeredUser.email,
            fullName: registeredUser.fullName,
            phoneNumber: registeredUser.phoneNumber,
            profileImage: registeredUser.profilePicture != null
                ? ApiEndpoints.imageUrl(registeredUser.profilePicture!)
                : null,
          );
        } else {}

        return registeredUser;
      } else {
        final errorMessage = response.data['message'] ?? "Registration failed";
        throw Exception(errorMessage);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> logout() async {
    await _tokenService.removeToken();
    await _userSessionService.clearSession();
    return true;
  }
}
