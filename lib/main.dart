import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/app/app.dart';
import 'package:quickpalo/core/services/hive/hive_service.dart';
import 'package:quickpalo/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_stripe/flutter_stripe.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
      'pk_test_51T5RMmCypol9DAadxqmffzLzHYcfQu09XOpLScr1wLzTR6XkI5j8u8rOsUJjpK0BL3m49Ew6GEenIQBxpWRrFrs800R7ZzbxvW';
  await Stripe.instance.applySettings();

  await HiveService().init();

  // shared perferences ko object
  final sharedPrefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
      child: App(),
    ),
  );
}
