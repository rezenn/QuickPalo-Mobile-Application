import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/auth/domain/repositories/auth_repository.dart';
import 'package:quickpalo/features/auth/domain/usecases/logout_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LogoutUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LogoutUsecase(authRepository: mockRepository);
  });

  test('should return true when logout is successful', () async {
    // Arrange
    when(() => mockRepository.logout())
        .thenAnswer((_) async => const Right(true));

    // Act
    final result = await usecase();

    // Assert
    expect(result, const Right(true));
    verify(() => mockRepository.logout()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test("Should return failure when logout fails", () async {
    // Arrange
    final failure = ServerFailure(message: "Logout failed");
    when(() => mockRepository.logout()).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.logout()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test("should call repository logout only once", () async {
    // Arrange
    when(() => mockRepository.logout()).thenAnswer((_) async => Right(true));

    // Act
    await usecase();

    // Assert
    verify(() => mockRepository.logout()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
