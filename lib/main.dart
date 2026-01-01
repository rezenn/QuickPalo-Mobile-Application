import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/app/app.dart';
import 'package:quickpalo/core/services/hive/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService().init();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
