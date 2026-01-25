import 'package:equatable/equatable.dart';
import 'package:quickpalo/features/profile/domain/entities/profile_entity.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  error,
  created,
  updated,
  deleted
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final List<ProfileEntity> profiles;
  final ProfileEntity? selectedProfile;
  final String? errorMessage;
  final String? uploadedPhotoUrl;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profiles = const [],
    this.selectedProfile,
    this.errorMessage,
    this.uploadedPhotoUrl,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    List<ProfileEntity>? profiles,
    ProfileEntity? selectedProfile,
    bool resetSelectedProfile = false,
    String? errorMessage,
    bool resetErrorMessage = false,
    String? uploadedPhotoUrl,
    bool resetUploadedPhotoUrl = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profiles: profiles ?? this.profiles,
      selectedProfile: resetSelectedProfile
          ? null
          : (selectedProfile ?? this.selectedProfile),
      errorMessage:
          resetErrorMessage ? null : (errorMessage ?? this.errorMessage),
      uploadedPhotoUrl: resetUploadedPhotoUrl
          ? null
          : (uploadedPhotoUrl ?? this.uploadedPhotoUrl),
    );
  }

  @override
  List<Object?> get props => [
        status,
        profiles,
        selectedProfile,
        errorMessage,
        uploadedPhotoUrl,
      ];
}
