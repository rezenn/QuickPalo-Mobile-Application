import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';
import 'package:quickpalo/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:quickpalo/features/appointment/domain/usecases/get_appointment_by_id_usecase.dart';

class MockAppointmentRepository extends Mock implements IAppointmentRepository {}

void main() {
  late GetAppointmentByIdUsecase usecase;
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
  );

  setUp(() {
    mockRepository = MockAppointmentRepository();
    usecase = GetAppointmentByIdUsecase(repository: mockRepository);
  });

  group('GetAppointmentByIdUsecase', () {
    test('should call repository with correct appointmentId', () async {
      when(() => mockRepository.getAppointmentById(any()))
          .thenAnswer((_) async => Right(tAppointmentEntity));

      await usecase(tAppointmentId);

      verify(() => mockRepository.getAppointmentById(tAppointmentId)).called(1);
    });

    test('should return AppointmentEntity when fetch succeeds', () async {
      when(() => mockRepository.getAppointmentById(tAppointmentId))
          .thenAnswer((_) async => Right(tAppointmentEntity));

      final result = await usecase(tAppointmentId);

      expect(result, Right(tAppointmentEntity));
    });

    test('should return failure when appointment not found', () async {
      final failure = ApiFailure(message: 'Appointment not found');
      when(() => mockRepository.getAppointmentById(tAppointmentId))
          .thenAnswer((_) async => Left(failure));

      final result = await usecase(tAppointmentId);

      expect(result, Left(failure));
    });
  });
}