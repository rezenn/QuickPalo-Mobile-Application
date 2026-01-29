import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickpalo/features/auth/domain/entities/auth_entity.dart';
import 'package:quickpalo/features/auth/domain/repositories/auth_repository.dart';
import 'package:quickpalo/features/auth/domain/usecases/register_usecase.dart';
import 'package:quickpalo/core/error/failures.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class IBatchrepository {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(const AuthEntity(
        fullName: "FALLBACK",
        email: "FALLBACK",
        phoneNumber: "FALLBACK",
        password: "FALLBACK",
        confirmPassword: "FALLBACK"));
  });
  const tFullName = "TestUser";
  const tEmail = "test@user.com";
  const tPhoneNumber = "9876543210";
  const tPassword = "password123";
  const tConfirmPassword = "password123";
  const tAuthEntity = AuthEntity(
    fullName: tFullName,
    email: tEmail,
    phoneNumber: tPhoneNumber,
    password: tPassword,
    confirmPassword: tConfirmPassword,
  );
  const tRegisterParams = RegisterUsecaseParams(
    fullName: tFullName,
    email: tEmail,
    phoneNumber: tPhoneNumber,
    password: tPassword,
    confirmPassword: tConfirmPassword,
  );

  test("should pass AuthEntity with correct data to repository", () async {
    AuthEntity? capturedEntity;
    when(() => mockRepository.register(any())).thenAnswer((invocation) {
      capturedEntity = invocation.positionalArguments[0] as AuthEntity;
      return Future.value(const Right(true));
    });

    await usecase(const RegisterUsecaseParams(
        fullName: tFullName,
        email: tEmail,
        phoneNumber: tPhoneNumber,
        password: tPassword,
        confirmPassword: tConfirmPassword));

    expect(capturedEntity?.authId, isNull);
    expect(capturedEntity?.fullName, tFullName);
    expect(capturedEntity?.email, tEmail);
    expect(capturedEntity?.phoneNumber, tPhoneNumber);
    expect(capturedEntity?.password, tPassword);
    expect(capturedEntity?.confirmPassword, tConfirmPassword);
  });

  test('should return true when registration is successful', () async {
    when(() => mockRepository.register(tAuthEntity))
        .thenAnswer((_) async => const Right(true));

    final result = await usecase(tRegisterParams);

    expect(result, const Right(true));
    verify(() => mockRepository.register(tAuthEntity)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test("should return failure when registration  fails", () async {
    final failure = ServerFailure(message: "Registration failed");
    when(() => mockRepository.register(tAuthEntity))
        .thenAnswer((_) async => Left(failure));

    final result = await usecase(tRegisterParams);

    expect(result, Left(failure));
    verify(() => mockRepository.register(tAuthEntity)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
  test(
    'should forward repository call without modification',
    () async {
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => const Right(true));

      await usecase(tRegisterParams);

      verify(() => mockRepository.register(tAuthEntity)).called(1);
    },
  );
}
