import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/services/hive/hive_service.dart';
import 'package:quickpalo/features/profile/data/datasources/profile_datasource.dart';
import 'package:quickpalo/features/profile/data/models/profile_hive_model.dart';

final profileLocalDatasourceProvider = Provider<ProfileLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return ProfileLocalDatasource(hiveService: hiveService);
});

class ProfileLocalDatasource implements IProfileLocalDataSource {
  final HiveService _hiveService;

  ProfileLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<bool> deleteProfile(String userId) async {
    try {
      await _hiveService.deleteProfile(userId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ProfileHiveModel>> getAllProfiles() async {
    try {
      return _hiveService.getAllProfiles();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ProfileHiveModel?> getProfileById(String userId) async {
    try {
      return _hiveService.getProfileById(userId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateProfile(ProfileHiveModel profile) async {
    return await _hiveService.updateProfile(profile);
  }
}
