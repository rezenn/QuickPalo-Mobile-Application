import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/profile/domain/entities/profile_entity.dart';
import 'package:quickpalo/features/profile/domain/usecases/get_profile_by_id_usecase.dart';
import 'package:quickpalo/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:quickpalo/features/profile/domain/usecases/upload_photo_usecase.dart';
import 'package:quickpalo/features/profile/presentation/view_model/profile_viewmodel.dart';
import 'package:quickpalo/features/profile/presentation/state/profile_state.dart';

class MockGetProfileByIdUsecase extends Mock implements GetProfileByIdUsecase {}

class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}

class MockUploadPhotoUsecase extends Mock implements UploadPhotoUsecase {}

class MockFile extends Mock implements File {}

void main() {
  late ProviderContainer container;
  late MockGetProfileByIdUsecase mockGetProfileById;
  late MockUpdateProfileUsecase mockUpdateProfile;
  late MockUploadPhotoUsecase mockUploadPhoto;
  late MockFile mockFile;

  // Test data
  const tUserId = 'user123';
  final tProfileEntity = ProfileEntity(
    userId: tUserId,
    fullName: 'John Doe',
    email: 'john@example.com',
    phoneNumber: '1234567890',
    profilePicture: 'profile.jpg',
  );

  final tUpdateParams = UpdateProfileParams(
    id: tUserId,
    fullName: 'John Updated',
    email: 'john.updated@example.com',
    phoneNumber: '9876543210',
    profilePicture: 'new_profile.jpg',
  );

  setUp(() {
    mockGetProfileById = MockGetProfileByIdUsecase();
    mockUpdateProfile = MockUpdateProfileUsecase();
    mockUploadPhoto = MockUploadPhotoUsecase();
    mockFile = MockFile();

    container = ProviderContainer(overrides: [
      getProfileByIdUsecaseProvider.overrideWithValue(mockGetProfileById),
      updateProfileUsecaseProvider.overrideWithValue(mockUpdateProfile),
      uploadPhotoUsecaseProvider.overrideWithValue(mockUploadPhoto),
    ]);
  });

  tearDown(() {
    container.dispose();
  });

  group('ProfileViewModel - getProfileById', () {
    test('initial state should be correct', () {
      final state = container.read(profileViewModelProvider);
      expect(state.status, ProfileStatus.initial);
      expect(state.selectedProfile, isNull);
      expect(state.errorMessage, isNull);
      expect(state.uploadedPhotoUrl, isNull);
    });

    test('should update state to loaded with profile when fetch succeeds',
        () async {
      when(() => mockGetProfileById.call(
            GetProfileByIdParams(userId: tUserId),
          )).thenAnswer((_) async => Right(tProfileEntity));

      final viewModel = container.read(profileViewModelProvider.notifier);
      await viewModel.getProfileById(tUserId);

      final state = container.read(profileViewModelProvider);
      expect(state.status, ProfileStatus.loaded);
      expect(state.selectedProfile, tProfileEntity);
      expect(state.errorMessage, isNull);
    });

    test('should update state to error when fetch fails', () async {
      final failure = ApiFailure(message: 'Profile not found');
      when(() => mockGetProfileById.call(
            GetProfileByIdParams(userId: tUserId),
          )).thenAnswer((_) async => Left(failure));

      final viewModel = container.read(profileViewModelProvider.notifier);
      await viewModel.getProfileById(tUserId);

      final state = container.read(profileViewModelProvider);
      expect(state.status, ProfileStatus.error);
      expect(state.errorMessage, 'Profile not found');
      expect(state.selectedProfile, isNull);
    });
  });

  group('ProfileViewModel - updateProfile', () {
    test('should return true when update succeeds', () async {
      when(() => mockUpdateProfile.call(tUpdateParams))
          .thenAnswer((_) async => const Right(true));

      final viewModel = container.read(profileViewModelProvider.notifier);
      final result = await viewModel.updateProfile(
        id: tUpdateParams.id,
        fullName: tUpdateParams.fullName,
        email: tUpdateParams.email,
        phoneNumber: tUpdateParams.phoneNumber,
        profilePicture: tUpdateParams.profilePicture,
      );

      expect(result, isTrue);
    });

    test('should return false when update fails', () async {
      final failure = ApiFailure(message: 'Failed to update profile');
      when(() => mockUpdateProfile.call(tUpdateParams))
          .thenAnswer((_) async => Left(failure));

      final viewModel = container.read(profileViewModelProvider.notifier);
      final result = await viewModel.updateProfile(
        id: tUpdateParams.id,
        fullName: tUpdateParams.fullName,
        email: tUpdateParams.email,
        phoneNumber: tUpdateParams.phoneNumber,
        profilePicture: tUpdateParams.profilePicture,
      );

      expect(result, isFalse);
    });
  });
}
