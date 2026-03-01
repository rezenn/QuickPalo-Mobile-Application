import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';
import 'package:quickpalo/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:quickpalo/features/appointment/domain/usecases/get_user_appointments_usecase.dart';

class MockAppointmentRepository extends Mock
    implements IAppointmentRepository {}

void main() {
  late GetUserAppointmentsUsecase usecase;
  late MockAppointmentRepository mockRepository;

  final tAppointmentsList = [
    AppointmentEntity(
      id: 'apt123',
      organizationId: 'org123',
      userId: 'user123',
      departmentId: 'dept123',
      departmentName: 'General Dentistry',
      clientName: 'John Doe',
      clientEmail: 'john@example.com',
      clientPhoneNumber: '1234567890',
      timeslot: TimeSlotEntity(startTime: '09:00', endTime: '10:00'),
      date: DateTime(2024, 1, 15),
    ),
    AppointmentEntity(
      id: 'apt124',
      organizationId: 'org123',
      userId: 'user123',
      departmentId: 'dept124',
      departmentName: 'Cardiology',
      clientName: 'John Doe',
      clientEmail: 'john@example.com',
      clientPhoneNumber: '1234567890',
      timeslot: TimeSlotEntity(startTime: '11:00', endTime: '12:00'),
      date: DateTime(2024, 1, 16),
    ),
  ];

  setUp(() {
    mockRepository = MockAppointmentRepository();
    usecase = GetUserAppointmentsUsecase(repository: mockRepository);
  });

  group('GetUserAppointmentsUsecase', () {
    test('should call repository', () async {
      when(() => mockRepository.getUserAppointments())
          .thenAnswer((_) async => Right(tAppointmentsList));

      await usecase();

      verify(() => mockRepository.getUserAppointments()).called(1);
    });

    test('should return list of appointments when fetch succeeds', () async {
      when(() => mockRepository.getUserAppointments())
          .thenAnswer((_) async => Right(tAppointmentsList));

      final result = await usecase();

      expect(result, Right(tAppointmentsList));
    });

    test('should return failure when fetch fails', () async {
      final failure = ApiFailure(message: 'Network error');
      when(() => mockRepository.getUserAppointments())
          .thenAnswer((_) async => Left(failure));

      final result = await usecase();

      expect(result, Left(failure));
    });
  });
}
