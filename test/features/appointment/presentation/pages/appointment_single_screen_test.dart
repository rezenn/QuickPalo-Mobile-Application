import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';
import 'package:quickpalo/features/appointment/presentation/pages/appointment_single_screen.dart';

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
    );
  });

  group('AppointmentSingleScreen', () {
   
    testWidgets('displays client information card', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: AppointmentSingleScreen(appointment: testAppointment),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Client Information'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
      expect(find.text('1234567890'), findsOneWidget);
    });

    testWidgets('shows cancel button for cancellable appointments', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: AppointmentSingleScreen(appointment: testAppointment),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.widgetWithText(OutlinedButton, 'Cancel Appointment'), findsOneWidget);
    });

    testWidgets('does not show cancel button for completed appointments', (tester) async {
      final completedAppointment = AppointmentEntity(
        id: 'apt123',
        organizationId: 'org123',
        userId: 'user123',
        departmentId: 'dept123',
        departmentName: 'Cardiology',
        clientName: 'John Doe',
        clientEmail: 'john@example.com',
        clientPhoneNumber: '1234567890',
        timeslot: TimeSlotEntity(startTime: '09:00', endTime: '10:00'),
        date: DateTime(2024, 1, 15),
        status: AppointmentStatus.completed,
        paymentAmount: 500,
        paymentMethod: PaymentMethod.online,
        paymentStatus: PaymentStatus.paid,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: AppointmentSingleScreen(appointment: completedAppointment),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.widgetWithText(OutlinedButton, 'Cancel Appointment'), findsNothing);
    });
  });
}