import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/features/auth/domain/usecases/login_usecase.dart';
import 'package:quickpalo/features/auth/domain/usecases/logout_usecase.dart';
import 'package:quickpalo/features/auth/domain/usecases/register_usecase.dart';
import 'package:quickpalo/features/auth/presentation/state/auth_state.dart';

// provider
final authViewModelProvider = NotifierProvider<AuthViewmodel, AuthState>(
  AuthViewmodel.new,
);

class AuthViewmodel extends Notifier<AuthState> {
  late final LoginUsecase _loginUsecase;
  late final RegisterUsecase _registerUsecase;
  late final LogoutUsecase _logoutUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);

    return AuthState();
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final params = RegisterUsecaseParams(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        confirmPassword: confirmPassword);
    final result = await _registerUsecase.call(params);
    result.fold(
      (failure) {
        state = state.copyWith(
            status: AuthStatus.error, errorMessage: failure.message);
      },
      (isRegistered) {
        if (isRegistered) {
          state = state.copyWith(status: AuthStatus.registered);
        } else {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: "Registration failed",
          );
        }
      },
    );
  }

  // login
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = LoginUsecaseParams(email: email, password: password);
    final result = await _loginUsecase.call(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (authEntity) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: authEntity,
        );
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _logoutUsecase();
    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (success) => state = state.copyWith(
        status: AuthStatus.unauthenticated,
        authEntity: null,
      ),
    );
  }
}
