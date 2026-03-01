import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';
import 'package:quickpalo/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:quickpalo/features/appointment/domain/usecases/create_appointment_usecase.dart';

class MockAppointmentRepository extends Mock
    implements IAppointmentRepository {}

void main() {
  late CreateAppointmentUsecase usecase;
  late MockAppointmentRepository mockRepository;

  // Test data
  final tTimeslot = TimeSlotEntity(
    startTime: '09:00',
    endTime: '10:00',
    isAvailable: true,
  );

  final tParams = CreateAppointmentParams(
    organizationId: 'org123',
    departmentId: 'dept123',
    clientName: 'John Doe',
    clientEmail: 'john@example.com',
    clientPhoneNumber: '1234567890',
    notes: 'Test appointment',
    timeslot: tTimeslot,
    date: DateTime(2024, 1, 15),
    paymentAmount: 50.0,
    paymentMethod: PaymentMethod.online,
  );

  final tAppointmentEntity = AppointmentEntity(
    id: 'apt123',
    organizationId: 'org123',
    userId: 'user123',
    departmentId: 'dept123',
    departmentName: 'General Dentistry',
    clientName: 'John Doe',
    clientEmail: 'john@example.com',
    clientPhoneNumber: '1234567890',
    notes: 'Test appointment',
    timeslot: tTimeslot,
    date: DateTime(2024, 1, 15),
    status: AppointmentStatus.pending,
    paymentAmount: 50.0,
    paymentMethod: PaymentMethod.online,
    paymentStatus: PaymentStatus.pending,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  setUp(() {
    mockRepository = MockAppointmentRepository();
    usecase = CreateAppointmentUsecase(repository: mockRepository);
  });

  group('CreateAppointmentUsecase', () {
    test('should return AppointmentEntity when creation succeeds', () async {
      // Arrange
      when(() => mockRepository.createAppointment(tParams))
          .thenAnswer((_) async => Right(tAppointmentEntity));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, Right(tAppointmentEntity));
    });

    test('should return failure when creation fails', () async {
      // Arrange
      final failure = ApiFailure(message: 'Network error');
      when(() => mockRepository.createAppointment(tParams))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, Left(failure));
    });
  });
}
