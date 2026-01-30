import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickpalo/features/auth/presentation/pages/change_password_page.dart';

void main() {
  testWidgets('ChangePasswordScreen renders without crashing', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ChangePasswordScreen(),
      ),
    );

    await tester.pump();

    expect(find.byType(ChangePasswordScreen), findsOneWidget);
  });

  testWidgets('ChangePasswordScreen shows title', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ChangePasswordScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Change Password'), findsAtLeast(1));
  });

  testWidgets('ChangePasswordScreen has password fields', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ChangePasswordScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('New Password'), findsOneWidget);
    expect(find.text('Confirm New Password'), findsOneWidget);
  });

  testWidgets('ChangePasswordScreen has change password button',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ChangePasswordScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Change Password'), findsAtLeast(1));
  });

  testWidgets('ChangePasswordScreen shows logo', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ChangePasswordScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
  });
}
