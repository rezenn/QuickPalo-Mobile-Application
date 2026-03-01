import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickpalo/core/widgets/custom_button.dart';
import 'package:quickpalo/core/widgets/custom_detail_action.dart';
import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';
import 'package:quickpalo/features/organizations/presentation/pages/organization_detail_screen.dart';
import 'package:quickpalo/features/organizations/presentation/widgets/date_selector.dart';
import 'package:quickpalo/features/organizations/presentation/widgets/time_selector.dart';

void main() {
  late OrganizationEntity testOrganization;

  setUp(() {
    testOrganization = OrganizationEntity(
      id: 'org123',
      organizationName: 'Test Hospital',
      description: 'A comprehensive healthcare facility',
      street: '123 Main St',
      city: 'New York',
      state: 'NY',
      contactPhone: '555-0123',
      fees: 500,
      departments: [
        DepartmentEntity(id: 'dept1', name: 'Cardiology'),
        DepartmentEntity(id: 'dept2', name: 'Neurology'),
      ],
      timeSlots: [
        TimeSlotEntity(startTime: '09:00', endTime: '10:00', isAvailable: true),
        TimeSlotEntity(startTime: '10:00', endTime: '11:00', isAvailable: true),
      ],
      workingHours: [
        WorkingHourEntity(day: 'Monday', openingTime: '09:00', closingTime: '17:00'),
      ],
      user: UserEntity(
        id: 'user123',
        fullName: 'Dr. Smith',
        profilePicture: 'profile.jpg',
      ),
      organizationType: OrganizationType.hospital, // Add this
    );
  });

  group('OrganizationDetailScreen', () {
    testWidgets('displays organization name and details', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OrganizationDetailScreen(organization: testOrganization),
        ),
      );

      expect(find.text('Test Hospital'), findsOneWidget);
      expect(find.text('123 Main St, New York, NY'), findsOneWidget);
      expect(find.text('555-0123'), findsOneWidget);
      expect(find.text('09:00 - 17:00'), findsOneWidget);
      expect(find.text('Rs 500'), findsOneWidget);
    });

    testWidgets('displays description when available', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OrganizationDetailScreen(organization: testOrganization),
        ),
      );

      expect(find.text('Description'), findsOneWidget);
      expect(find.text('A comprehensive healthcare facility'), findsOneWidget);
    });

    testWidgets('displays departments selector', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OrganizationDetailScreen(organization: testOrganization),
        ),
      );

      expect(find.text('Department'), findsOneWidget);
      expect(find.text('Cardiology'), findsOneWidget);
      expect(find.text('Neurology'), findsOneWidget);
    });

    testWidgets('displays date and time selectors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OrganizationDetailScreen(organization: testOrganization),
        ),
      );

      expect(find.text('Slots'), findsOneWidget);
      expect(find.byType(DateSelector), findsOneWidget);
      expect(find.byType(TimeSelector), findsOneWidget);
    });

    testWidgets('book button is disabled until selections are made', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OrganizationDetailScreen(organization: testOrganization),
        ),
      );

      final bookButton = find.widgetWithText(CustomButton, 'Book Appointment');
      expect(tester.widget<CustomButton>(bookButton).onPressed, isNull);
    });

    testWidgets('shows message button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OrganizationDetailScreen(organization: testOrganization),
        ),
      );

      expect(find.widgetWithText(CustomDetailAction, 'Message'), findsOneWidget);
      expect(find.byIcon(Icons.message), findsOneWidget);
    });

    testWidgets('shows hint when booking incomplete', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OrganizationDetailScreen(organization: testOrganization),
        ),
      );

      expect(
        find.text('Please select department, date, and time to continue'),
        findsOneWidget,
      );
    });
  });
}