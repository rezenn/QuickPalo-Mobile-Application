// core/sensors/presentation/providers/proximity_toggle_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kProximityKey = 'proximity_logout_enabled';

final proximityToggleProvider = NotifierProvider<ProximityToggleNotifier, bool>(
  ProximityToggleNotifier.new,
);

class ProximityToggleNotifier extends Notifier<bool> {
  @override
  bool build() {
    // Load saved preference, default to true
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getBool(_kProximityKey) ?? true;
  }

  Future<void> toggle() async {
    final prefs = ref.read(sharedPreferencesProvider);
    state = !state;
    await prefs.setBool(_kProximityKey, state);
  }
}
