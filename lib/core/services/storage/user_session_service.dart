import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/api/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError("Shared prefs initilization");
});

final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  return UserSessionService(prefs: ref.read(sharedPreferencesProvider));
});

class UserSessionService {
  final SharedPreferences _prefs;
  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  // keys to storage
  static const String _keyIsLoggedIn = "is_logged_in";
  static const String _keyUserId = "user_id";
  static const String _keyUserEmail = "username";
  static const String _keyUserFullName = "user_full_name";
  static const String _keyUserPhoneNumber = "user_phone_number";
  static const String _keyUserProfileImage = "user_profile_image";

  // store user session
  // Future<void> saveUserSession({
  //   required String userId,
  //   required String email,
  //   required String fullName,
  //   required String? phoneNumber,
  //   String? profileImage,
  // }) async {
  //   await _prefs.setBool(_keyIsLoggedIn, true);
  //   await _prefs.setString(_keyUserId, userId);
  //   await _prefs.setString(_keyUserEmail, email);
  //   await _prefs.setString(_keyUserFullName, fullName);

  //   if (phoneNumber != null) {
  //     await _prefs.setString(_keyUserPhoneNumber, phoneNumber);
  //   }
  //   if (profileImage != null) {
  //     await _prefs.setString(_keyUserProfileImage, profileImage);
  //   }
  // }

Future<void> saveUserSession({
    required String userId,
    required String email,
    required String fullName,
    required String? phoneNumber,
    String? profileImage,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setString(_keyUserFullName, fullName);

    if (phoneNumber != null) {
      await _prefs.setString(_keyUserPhoneNumber, phoneNumber);
    }
    
    if (profileImage != null) {
      // Store only the filename, not the full URL
      final fileName = profileImage.contains('/') 
          ? profileImage.split('/').last 
          : profileImage;
      await _prefs.setString(_keyUserProfileImage, fileName);
    }
  }

  


  // clear session
  Future<void> clearSession() async {
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserFullName);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserPhoneNumber);
    await _prefs.remove(_keyUserProfileImage);
  }

  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  String? getuserId() {
    return _prefs.getString(_keyUserId);
  }

  String? getuserEmail() {
    return _prefs.getString(_keyUserEmail);
  }

  String? getuserFullName() {
    return _prefs.getString(_keyUserFullName);
  }

  String? getuserPhoneNumber() {
    return _prefs.getString(_keyUserPhoneNumber);
  }

  // String? getuserProfileImage() {
  //   return _prefs.getString(_keyUserProfileImage);
  // }
  String? getuserProfileImage() {
    final fileName = _prefs.getString(_keyUserProfileImage);
    if (fileName == null || fileName.isEmpty) return null;
    
    // Convert filename to full URL when retrieving
    return ApiEndpoints.imageUrl(fileName);
  }
}
