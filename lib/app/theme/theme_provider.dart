// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:quickpalo/core/services/storage/user_session_service.dart'; // <-- imports the EXISTING sharedPreferencesProvider
// import 'package:shared_preferences/shared_preferences.dart';

// const _themeKey = 'dark_mode';

// final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, bool>((ref) {
//   // reads from the SAME sharedPreferencesProvider that main() overrides
//   final prefs = ref.read(sharedPreferencesProvider);
//   return ThemeModeNotifier(prefs);
// });

// class ThemeModeNotifier extends StateNotifier<bool> {
//   final SharedPreferences _prefs;

//   ThemeModeNotifier(this._prefs) : super(_prefs.getBool(_themeKey) ?? false);

//   void toggle() {
//     state = !state;
//     _prefs.setBool(_themeKey, state);
//   }
// }
