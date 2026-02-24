// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:local_auth/auth_strings.dart';

// final biometricServiceProvider = Provider<BiometricService>((ref) {
//   return BiometricService();
// });

// class BiometricService {
//   final LocalAuthentication _localAuth = LocalAuthentication();
//   final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

//   Future<bool> isBiometricAvailable() async {
//     try {
//       return await _localAuth.canCheckBiometrics &&
//           await _localAuth.isDeviceSupported();
//     } on PlatformException catch (e) {
//       print("Error getting biometrics: $e");
//       return false;
//     }
//   }

//   Future<List<BiometricType>> getAvailableBiometrics() async {
//     try {
//       return await _localAuth.getAvailableBiometrics();
//     } on PlatformException catch (e) {
//       print("Error getting biometrics: $e");
//       return [];
//     }
//   }

//   Future<bool> authenticateWithBiometrics({
//     required String reason,
//     String? cancleButton,
//     String? localizedReason,
//   }) async {
//     try {
//       return await _localAuth.authenticate(
//           localizedReason: localizedReason ?? reason,
//           options:
//               AuthenticationOptions(stickyAuth: true, biometricOnly: true));
//     } on PlatformException catch (e) {
//       print("Error authenticating $e");
//       return false;
//     }
//   }

//   Future<void> saveBiometricCredentials({
//     required String email,
//     required String password,
//   }) async {
//     await _secureStorage.write(key: "biometric_email", value: email);
//     await _secureStorage.write(key: "biometric_password", value: password);
//     await _secureStorage.write(key: "biometric_enabled", value: "true");
//   }

//   Future<Map<String, String>?> getBiometricCredentials() async {
//     final email = await _secureStorage.read(key: "biometric_email");
//     final password = await _secureStorage.read(key: "biometric_password");
//     final enabled = await _secureStorage.read(key: "biometric_enabled");
//     if (email != null && password != null && enabled == "true") {
//       return {"email": email, "password": password};
//     }
//     return null;
//   }

//   Future<bool> isBiometricLoginEnabled() async {
//     final enabled = await _secureStorage.read(key: 'biometric_enabled');
//     return enabled == 'true';
//   }

//   Future<void> disableBiometricLogin() async {
//     await _secureStorage.delete(key: 'biometric_email');
//     await _secureStorage.delete(key: 'biometric_password');
//     await _secureStorage.write(key: 'biometric_enabled', value: 'false');
//   }

//   Future<void> clearBiometricData() async {
//     await _secureStorage.deleteAll();
//   }
// }
