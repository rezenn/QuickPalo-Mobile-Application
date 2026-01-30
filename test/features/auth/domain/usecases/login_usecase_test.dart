import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickpalo/features/auth/domain/entities/auth_entity.dart';
import 'package:quickpalo/features/auth/domain/repositories/auth_repository.dart';
import 'package:quickpalo/features/auth/domain/usecases/login_usecase.dart';
import 'package:quickpalo/core/error/failures.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginUsecase usecase;
  late MockAuthRepository mockRepository;

  // Test data
  const tEmail = "test@user.com";
  const tPassword = "password123";

  const tAuthEntity = AuthEntity(
    fullName: "Test User",
    email: tEmail,
    phoneNumber: "9876543210",
    password: "", 
    confirmPassword: "", 
  );

  const tLoginParams = LoginUsecaseParams(
    email: tEmail,
    password: tPassword,
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUsecase(authRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(const AuthEntity(
      fullName: "FALLBACK",
      email: "FALLBACK",
      phoneNumber: "FALLBACK",
      password: "FALLBACK",
      confirmPassword: "FALLBACK",
    ));
  });

  group('LoginUsecase', () {
    test('should pass correct email and password to repository', () async {
      // Arrange
      String? capturedEmail;
      String? capturedPassword;

      when(() => mockRepository.login(any(), any())).thenAnswer((invocation) {
        capturedEmail = invocation.positionalArguments[0] as String;
        capturedPassword = invocation.positionalArguments[1] as String;
        return Future.value(const Right(tAuthEntity));
      });

      // Act
      await usecase(tLoginParams);

      // Assert
      expect(capturedEmail, tEmail);
      expect(capturedPassword, tPassword);

      verify(() => mockRepository.login(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthEntity when login succeeds', () async {
      // Arrange
      when(() => mockRepository.login(tEmail, tPassword))
          .thenAnswer((_) async => const Right(tAuthEntity));

      // Act
      final result = await usecase(tLoginParams);

      // Assert
      expect(result, const Right(tAuthEntity));
      verify(() => mockRepository.login(tEmail, tPassword)).called(1);
    });

    test('should return failure when login fails', () async {
      // Arrange
      final failure = ServerFailure(message: "Invalid credentials");
      when(() => mockRepository.login(tEmail, tPassword))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase(tLoginParams);

      // Assert
      expect(result, Left(failure));
      verify(() => mockRepository.login(tEmail, tPassword)).called(1);
    });

    test('should handle empty email and password', () async {
      // Arrange
      const emptyParams = LoginUsecaseParams(email: "", password: "");
      when(() => mockRepository.login("", ""))
          .thenAnswer((_) async => const Right(tAuthEntity));

      // Act
      final result = await usecase(emptyParams);

      // Assert
      expect(result, const Right(tAuthEntity));
      verify(() => mockRepository.login("", "")).called(1);
    });

    test('should return failure for invalid email format', () async {
      // Arrange
      const invalidEmailParams = LoginUsecaseParams(
        email: "invalid-email",
        password: tPassword,
      );
      final failure = ServerFailure(message: "Invalid email format");
      when(() => mockRepository.login("invalid-email", tPassword))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase(invalidEmailParams);

      // Assert
      expect(result, Left(failure));
      verify(() => mockRepository.login("invalid-email", tPassword)).called(1);
    });

    test('should return failure for short password', () async {
      // Arrange
      const shortPasswordParams = LoginUsecaseParams(
        email: tEmail,
        password: "123",
      );
      final failure = ServerFailure(message: "Password too short");
      when(() => mockRepository.login(tEmail, "123"))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase(shortPasswordParams);

      // Assert
      expect(result, Left(failure));
      verify(() => mockRepository.login(tEmail, "123")).called(1);
    });
  });
}
