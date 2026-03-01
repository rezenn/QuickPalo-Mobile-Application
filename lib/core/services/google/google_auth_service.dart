// lib/core/services/google/google_auth_service.dart
// Works with google_sign_in: ^5.4.4
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});

class GoogleAuthResult {
  final String email;
  final String fullName;
  final String? photoUrl;
  final String googleId;
  final String idToken;

  GoogleAuthResult({
    required this.email,
    required this.fullName,
    this.photoUrl,
    required this.googleId,
    required this.idToken,
  });
}

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  Future<GoogleAuthResult?> signIn() async {
    try {
      await _googleSignIn.signOut(); // always show account picker
      final account = await _googleSignIn.signIn();
      if (account == null) return null; // user cancelled

      final auth = await account.authentication;
      if (auth.idToken == null) {
        throw Exception(
          'No ID token received. Ensure SHA-1 is registered in Google Cloud Console.',
        );
      }

      return GoogleAuthResult(
        email: account.email,
        fullName: account.displayName ?? account.email,
        photoUrl: account.photoUrl,
        googleId: account.id,
        idToken: auth.idToken!,
      );
    } catch (e) {
      debugPrint('[GoogleAuthService] signIn error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
