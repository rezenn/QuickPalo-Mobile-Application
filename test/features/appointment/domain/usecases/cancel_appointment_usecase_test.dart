import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';
import 'package:quickpalo/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:quickpalo/features/appointment/domain/usecases/cancel_appointment_usecase.dart';

class MockAppointmentRepository extends Mock implements IAppointmentRepository {}

void main() {
  late CancelAppointmentUsecase usecase;
  late MockAppointmentRepository mockRepository;

  const tAppointmentId = 'apt123';

  final tAppointmentEntity = AppointmentEntity(
    id: tAppointmentId,
    organizationId: 'org123',
    userId: 'user123',
    departmentId: 'dept123',
    departmentName: 'General Dentistry',
    clientName: 'John Doe',
    clientEmail: 'john@example.com',
    clientPhoneNumber: '1234567890',
    timeslot: TimeSlotEntity(startTime: '09:00', endTime: '10:00'),
    date: DateTime(2024, 1, 15),
    status: AppointmentStatus.cancelled,
  );

  setUp(() {
    mockRepository = MockAppointmentRepository();
    usecase = CancelAppointmentUsecase(repository: mockRepository);
  });

  group('CancelAppointmentUsecase', () {
    test('should call repository with correct appointmentId', () async {
      when(() => mockRepository.cancelAppointment(any()))
          .thenAnswer((_) async => Right(tAppointmentEntity));

      await usecase(tAppointmentId);

      verify(() => mockRepository.cancelAppointment(tAppointmentId)).called(1);
    });

    test('should return cancelled AppointmentEntity when successful', () async {
      when(() => mockRepository.cancelAppointment(tAppointmentId))
          .thenAnswer((_) async => Right(tAppointmentEntity));

      final result = await usecase(tAppointmentId);

      expect(result, Right(tAppointmentEntity));
    });

    test('should return failure when cancellation fails', () async {
      final failure = ApiFailure(message: 'Cannot cancel confirmed appointment');
      when(() => mockRepository.cancelAppointment(tAppointmentId))
          .thenAnswer((_) async => Left(failure));

      final result = await usecase(tAppointmentId);

      expect(result, Left(failure));
    });
  });
}