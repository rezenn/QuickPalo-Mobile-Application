import 'package:local_auth/local_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isAvailable() async {
    try {
      // On Xiaomi/MIUI devices isDeviceSupported is the most reliable check
      final isSupported = await _auth.isDeviceSupported();
      if (!isSupported) return false;

      // Try canCheckBiometrics — on Xiaomi this may still return false
      // so we also try to get enrolled list
      final canCheck = await _auth.canCheckBiometrics;
      if (canCheck) return true;

      // Last resort: try getAvailableBiometrics
      // Xiaomi face unlock sometimes shows up here as BiometricType.face
      // or BiometricType.weak
      final enrolled = await _auth.getAvailableBiometrics();
      return enrolled.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<BiometricType?> getBiometricType() async {
    try {
      final enrolled = await _auth.getAvailableBiometrics();
      if (enrolled.contains(BiometricType.face)) return BiometricType.face;
      if (enrolled.contains(BiometricType.fingerprint))
        return BiometricType.fingerprint;
      if (enrolled.contains(BiometricType.strong)) return BiometricType.strong;
      if (enrolled.contains(BiometricType.weak)) return BiometricType.weak;
      return BiometricType.face; // Xiaomi face default
    } catch (_) {
      return BiometricType.face;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Authenticate to log in to QuickPalo',
      );
    } catch (_) {
      return false;
    }
  }
}
