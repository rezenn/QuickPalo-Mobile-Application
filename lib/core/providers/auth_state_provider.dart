import 'package:flutter_riverpod/legacy.dart';
import 'package:quickpalo/core/services/storage/user_session_service.dart';

final authStateProvider = StateProvider<bool>((ref) {
  final session = ref.read(userSessionServiceProvider);
  return session.isLoggedIn();
});
