import 'dart:io';

import 'package:quickpalo/features/profile/data/models/profile_api_model.dart';
import 'package:quickpalo/features/profile/data/models/profile_hive_model.dart';

abstract interface class IProfileLocalDataSource {
  // Future<List<ProfileHiveModel>> getAllProfiles();
  Future<ProfileHiveModel?> getProfileById(String userId);
  Future<bool> updateProfile(ProfileHiveModel profile);
  // Future<bool> deleteProfile(String userId);
}

abstract interface class IProfileRemoteDataSource {
  Future<String> uploadPhoto(File photo);
  // Future<List<ProfileApiModel>> getAllProfiles();
  Future<ProfileApiModel> getProfileById(String userId);
  Future<bool> updateProfile(ProfileApiModel profile);
  // Future<bool> deleteProfile(String userId);
}
