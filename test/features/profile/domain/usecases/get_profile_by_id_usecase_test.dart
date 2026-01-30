import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickpalo/features/profile/domain/usecases/get_profile_by_id_usecase.dart';
import 'package:quickpalo/features/profile/domain/repositories/profile_repository.dart';
import 'package:quickpalo/features/profile/domain/entities/profile_entity.dart';
import 'package:quickpalo/core/error/failures.dart';

class MockProfileRepository extends Mock implements IProfileRepository {}

void main() {
  late GetProfileByIdUsecase usecase;
  late MockProfileRepository mockRepository;

  // Test data
  const tUserId = 'user_123';
  const tParams = GetProfileByIdParams(userId: tUserId);

  final tProfileEntity = ProfileEntity(
    userId: tUserId,
    fullName: 'Test User',
    email: 'test@example.com',
    phoneNumber: '+1234567890',
    profilePicture: 'https://example.com/avatar.jpg',
  );

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = GetProfileByIdUsecase(profileRepository: mockRepository);
  });

  test('should return ProfileEntity when profile is found', () async {
    // Arrange
    when(() => mockRepository.getProfileById(tUserId))
        .thenAnswer((_) async => Right(tProfileEntity));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Right(tProfileEntity));
    verify(() => mockRepository.getProfileById(tUserId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should forward userId parameter to repository', () async {
    // Arrange
    String? capturedUserId;
    when(() => mockRepository.getProfileById(any())).thenAnswer((invocation) {
      capturedUserId = invocation.positionalArguments[0] as String;
      return Future.value(Right(tProfileEntity));
    });

    // Act
    await usecase(tParams);

    // Assert
    expect(capturedUserId, tUserId);
    verify(() => mockRepository.getProfileById(tUserId)).called(1);
  });

  test('should return profile not found when profile does not exist', () async {
    // Arrange
    final failure = UserNotFoundFailure(message: 'Profile not found');
    when(() => mockRepository.getProfileById(tUserId))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.getProfileById(tUserId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return unauthorized when user doesnot have access', () async {
    // Arrange
    final failure = UnauthorizedFailure(message: 'unauthorized access denied');
    when(() => mockRepository.getProfileById(tUserId))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.getProfileById(tUserId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return NetworkFailure on connection error', () async {
    // Arrange
    final failure = NetworkFailure(message: 'Connection failed');
    when(() => mockRepository.getProfileById(tUserId))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.getProfileById(tUserId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure on server error', () async {
    // Arrange
    final failure = ServerFailure(message: 'Internal server error');
    when(() => mockRepository.getProfileById(tUserId))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.getProfileById(tUserId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should call repository exactly once per call', () async {
    // Arrange
    when(() => mockRepository.getProfileById(tUserId))
        .thenAnswer((_) async => Right(tProfileEntity));

    // Act
    await usecase(tParams);
    await usecase(tParams);
    await usecase(tParams);

    // Assert
    verify(() => mockRepository.getProfileById(tUserId)).called(3);
    verifyNoMoreInteractions(mockRepository);
  });
}
