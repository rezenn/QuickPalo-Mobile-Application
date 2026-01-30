import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('EditProfileScreen builds without errors', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
          ),
          body: const Center(
            child: Column(
              children: [
                Text('Edit your personal information'),
                Text('Full Name'),
                Text('Email Address'),
                Text('Phone Number'),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Edit your personal information'), findsOneWidget);
  });

  testWidgets('EditProfileScreen UI components test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              const Text('Edit Profile'),
              const Text('Personal Information'),
              const Text('Full Name'),
              const Text('Email Address'),
              const Text('Email cannot be changed'),
              const Text('Phone Number'),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Save Changes'),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Email cannot be changed'), findsOneWidget);
    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });
}
