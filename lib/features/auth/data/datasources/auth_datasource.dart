import 'package:quickpalo/features/auth/data/model/auth_register_api_model.dart';
import 'package:quickpalo/features/auth/data/model/auth_hive_model.dart';

abstract interface class IAuthDataSource {
  Future<AuthHiveModel> register(AuthHiveModel user);
  Future<AuthHiveModel?> login(String email, String password);
  Future<AuthHiveModel?> getCurrentUser();
  Future<AuthHiveModel?> getUserByEmail(String email);
  Future<bool> logout();

  Future<bool> isEmailExist(String email);
}

abstract interface class IAuthRemoteDataSource {
  Future<AuthRegisterApiModel> register(AuthRegisterApiModel user);
  Future<AuthRegisterApiModel?> login(String email, String password);
  Future<AuthRegisterApiModel?> getUserById(String authId);
  Future<bool> logout();
}
