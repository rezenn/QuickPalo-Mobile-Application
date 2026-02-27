import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final biometricPreferenceServiceProvider =
    Provider<BiometricPreferenceService>((ref) {
  return BiometricPreferenceService();
});

class BiometricPreferenceService {
  static const _storage = FlutterSecureStorage();
  static const _enabledKey = 'biometric_enabled';
  static const _savedEmailKey = 'biometric_email';
  static const _savedPasswordKey = 'biometric_password';

  Future<void> enable(String email, String password) async {
    await _storage.write(key: _enabledKey, value: 'true');
    await _storage.write(key: _savedEmailKey, value: email);
    await _storage.write(key: _savedPasswordKey, value: password);
  }

  Future<void> disable() async {
    await _storage.delete(key: _enabledKey);
    await _storage.delete(key: _savedEmailKey);
    await _storage.delete(key: _savedPasswordKey);
  }

  Future<bool> isEnabled() async {
    final val = await _storage.read(key: _enabledKey);
    return val == 'true';
  }

  Future<({String email, String password})?> getCredentials() async {
    final email = await _storage.read(key: _savedEmailKey);
    final password = await _storage.read(key: _savedPasswordKey);
    if (email == null || password == null) return null;
    return (email: email, password: password);
  }
}
