import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';
import 'package:quickpalo/features/appointment/presentation/pages/appointment_success_screen.dart';

void main() {
  late AppointmentEntity testAppointment;

  setUp(() {
    testAppointment = AppointmentEntity(
      id: 'apt123',
      organizationId: 'org123',
      userId: 'user123',
      departmentId: 'dept123',
      departmentName: 'Cardiology',
      clientName: 'John Doe',
      clientEmail: 'john@example.com',
      clientPhoneNumber: '1234567890',
      notes: 'Test notes',
      timeslot: TimeSlotEntity(
        startTime: '09:00',
        endTime: '10:00',
      ),
      date: DateTime(2024, 1, 15),
      status: AppointmentStatus.confirmed,
      paymentAmount: 500,
      paymentMethod: PaymentMethod.online,
      paymentStatus: PaymentStatus.paid,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  });

  group('AppointmentSuccessScreen', () {
    testWidgets('displays success message and appointment details', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppointmentSuccessScreen(
            appointment: testAppointment,
            organizationName: 'Test Hospital',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Appointment Booked!'), findsOneWidget);
      expect(find.text('Your appointment at Test Hospital is confirmed.'), findsOneWidget);
      expect(find.text('Cardiology'), findsOneWidget);
      expect(find.text('January 15, 2024'), findsOneWidget);
      expect(find.text('09:00 - 10:00'), findsOneWidget);
      expect(find.text('Confirmed'), findsOneWidget);
      expect(find.text('Online  •  Rs 500'), findsOneWidget);
    });

    testWidgets('shows QR code', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppointmentSuccessScreen(
            appointment: testAppointment,
            organizationName: 'Test Hospital',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Appointment QR'), findsOneWidget);
      expect(find.byType(QrImageView), findsOneWidget);
    });

    testWidgets('shows download QR button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppointmentSuccessScreen(
            appointment: testAppointment,
            organizationName: 'Test Hospital',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.widgetWithText(OutlinedButton, 'Download QR'), findsOneWidget);
    });

    testWidgets('shows view appointments button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppointmentSuccessScreen(
            appointment: testAppointment,
            organizationName: 'Test Hospital',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.widgetWithText(ElevatedButton, 'View My Appointments'), findsOneWidget);
    });

    testWidgets('shows back to home button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppointmentSuccessScreen(
            appointment: testAppointment,
            organizationName: 'Test Hospital',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextButton, 'Back to Home'), findsOneWidget);
    });
  });
}