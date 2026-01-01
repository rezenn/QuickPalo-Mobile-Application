import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/features/auth/domain/usecases/login_usecase.dart';
import 'package:quickpalo/features/auth/domain/usecases/register_usecase.dart';
import 'package:quickpalo/features/auth/presentation/state/auth_state.dart';

// provider
final authViewmodelProvider = NotifierProvider<AuthViewmodel, AuthState>(
  AuthViewmodel.new,
);

class AuthViewmodel extends Notifier<AuthState> {
  late final LoginUsecase _loginUsecase;
  late final RegisterUsecase _registerUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    return AuthState();
  }

  Future<void> register(
      {required String fullName,
      required String email,
      required String phoneNumber,
      required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);

    final params = RegisterUsecaseParams(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password);
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
            status: AuthStatus.error, errorMessage: failure.message);
      },
      (authEntity) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: authEntity,
        );
      },
    );
  }
}
