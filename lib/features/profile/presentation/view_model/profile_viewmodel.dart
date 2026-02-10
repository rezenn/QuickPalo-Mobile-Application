import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/features/profile/domain/usecases/get_profile_by_id_usecase.dart';
import 'package:quickpalo/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:quickpalo/features/profile/domain/usecases/upload_photo_usecase.dart';
import 'package:quickpalo/features/profile/presentation/state/profile_state.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(
  ProfileViewModel.new,
);

class ProfileViewModel extends Notifier<ProfileState> {
  // late final GetAllProfilesUsecase _getAllProfilesUsecase;
  late final GetProfileByIdUsecase _getProfileByIdUsecase;
  late final UpdateProfileUsecase _updateProfileUsecase;
  late final UploadPhotoUsecase _uploadPhotoUsecase;

  @override
  ProfileState build() {
    // _getAllProfilesUsecase = ref.read(getAllProfilesUsecaseProvider);
    _getProfileByIdUsecase = ref.read(getProfileByIdUsecaseProvider);
    _updateProfileUsecase = ref.read(updateProfileUsecaseProvider);
    _uploadPhotoUsecase = ref.read(uploadPhotoUsecaseProvider);

    return const ProfileState();
  }

  // Future<void> getAllProfiles() async {
  //   state = state.copyWith(status: ProfileStatus.loading);

  //   final result = await _getAllProfilesUsecase();

  //   result.fold(
  //     (failure) => state = state.copyWith(
  //       status: ProfileStatus.error,
  //       errorMessage: failure.message,
  //     ),
  //     (profiles) => state = state.copyWith(
  //       status: ProfileStatus.loaded,
  //       profiles: profiles,
  //     ),
  //   );
  // }

  Future<void> getProfileById(String userId) async {
    state = state.copyWith(status: ProfileStatus.loading);

    final result = await _getProfileByIdUsecase(
      GetProfileByIdParams(userId: userId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: failure.message,
      ),
      (profile) => state = state.copyWith(
        status: ProfileStatus.loaded,
        selectedProfile: profile,
      ),
    );
  }

  Future<bool?> updateProfile({
    required String id,
    required String fullName,
    required String email,
    required String phoneNumber,
    String? profilePicture,
  }) async {
    state = state.copyWith(status: ProfileStatus.loading);

    final result = await _updateProfileUsecase(
      UpdateProfileParams(
        id: id,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        profilePicture: profilePicture,
      ),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (success) {
        state = state.copyWith(status: ProfileStatus.updated);
        return true;
      },
    );
  }

  Future<String?> uploadPhoto(File photo) async {
    state = state.copyWith(status: ProfileStatus.loading);

    final result = await _uploadPhotoUsecase(photo);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
        return null;
      },
      (filename) {
        state = state.copyWith(
          status: ProfileStatus.loaded,
          uploadedPhotoUrl: filename,
        );
        return filename;
      },
    );
  }

  void clearError() {
    state = state.copyWith(resetErrorMessage: true);
  }

  void clearSelectedProfile() {
    state = state.copyWith(resetSelectedProfile: true);
  }

  void clearState() {
    state = state.copyWith(
      status: ProfileStatus.initial,
      resetErrorMessage: true,
      resetUploadedPhotoUrl: true,
      resetSelectedProfile: true,
    );
  }
}
