import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickpalo/features/auth/presentation/pages/forgot_password_page.dart';

void main() {
  testWidgets('ForgotPasswordScreen renders without crashing', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ForgotPasswordScreen(),
      ),
    );

    await tester.pump();

    expect(find.byType(ForgotPasswordScreen), findsOneWidget);
  });

  testWidgets('ForgotPasswordScreen shows Verify OTP title', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ForgotPasswordScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Verify OTP'), findsAtLeast(1));
  });

  testWidgets('ForgotPasswordScreen has OTP Code label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ForgotPasswordScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('OTP Code'), findsOneWidget);
  });

  testWidgets('ForgotPasswordScreen has Verify OTP button', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ForgotPasswordScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Verify OTP'), findsAtLeast(1));
  });

  testWidgets('ForgotPasswordScreen shows instruction text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ForgotPasswordScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(
        find.text(
            'We have sent a 6-digit verification code to your email address he*************m'),
        findsOneWidget);
  });

  testWidgets('ForgotPasswordScreen shows logo', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ForgotPasswordScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
  });
}
