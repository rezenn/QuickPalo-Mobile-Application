import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickpalo/core/constants/hive_table_constants.dart';
import 'package:quickpalo/features/auth/data/model/auth_hive_model.dart';
import 'package:quickpalo/features/organizations/data/models/organization_hive_model.dart';
import 'package:quickpalo/features/profile/data/models/profile_hive_model.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/${HiveTableConstant.dbName}";
    Hive.init(path);
    _registerAdapters();
    await _openBoxes();
  }

  // Register Hive adapters
  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.profileTypeId)) {
      Hive.registerAdapter(ProfileHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.organizationTypeId)) {
      Hive.registerAdapter(OrganizationHiveModelAdapter());
    }
  }

  // Open Hive boxes
  Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    await Hive.openBox<ProfileHiveModel>(HiveTableConstant.profileTable);
    await Hive.openBox<OrganizationHiveModel>(
        HiveTableConstant.organizationTable);
  }

  // Close Hive
  Future<void> close() async {
    await Hive.close();
  }

  // Access auth box
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  // Register user
  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
    return model;
  }

  // Login user
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users = _authBox.values.where(
      (user) => user.email == email && user.password == password,
    );
    return users.isNotEmpty ? users.first : null;
  }

  // logout user
  Future<void> logoutUser() async {}

  //get current user
  AuthHiveModel? getCurrentUser(String authId) {
    return _authBox.get(authId);
  }

  // email exists
  bool isEmailExist(String email) =>
      _authBox.values.any((user) => user.email == email);

  // Get user by email
  AuthHiveModel? getUserByEmail(String email) {
    try {
      return _authBox.values.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  // profile query

  Box<ProfileHiveModel> get _profileBox =>
      Hive.box<ProfileHiveModel>(HiveTableConstant.profileTable);

  List<ProfileHiveModel> getAllProfiles() {
    return _profileBox.values.toList();
  }

  ProfileHiveModel? getProfileById(String userId) {
    return _profileBox.get(userId);
  }

  Future<bool> updateProfile(ProfileHiveModel profile) async {
    if (_profileBox.containsKey(profile.userId)) {
      await _profileBox.put(profile.userId, profile);
      return true;
    }
    return false;
  }

  Future<void> deleteProfile(String userId) async {
    await _profileBox.delete(userId);
  }

  Future<void> saveProfile(ProfileHiveModel profile) async {
    await _profileBox.put(profile.userId, profile);
  }

  // Organization methods
  Box<OrganizationHiveModel> get _organizationBox =>
      Hive.box<OrganizationHiveModel>(HiveTableConstant.organizationTable);

  List<OrganizationHiveModel> getAllOrganizations() {
    return _organizationBox.values.toList();
  }

  OrganizationHiveModel? getOrganizationById(String id) {
    return _organizationBox.get(id);
  }

  Future<void> saveOrganization(OrganizationHiveModel organization) async {
    if (organization.id != null) {
      await _organizationBox.put(organization.id, organization);
    }
  }

  Future<void> saveOrganizations(
      List<OrganizationHiveModel> organizations) async {
    for (var org in organizations) {
      if (org.id != null) {
        await _organizationBox.put(org.id, org);
      }
    }
  }

  Future<void> deleteOrganization(String id) async {
    await _organizationBox.delete(id);
  }

  Future<void> clearOrganizations() async {
    await _organizationBox.clear();
  }
}
