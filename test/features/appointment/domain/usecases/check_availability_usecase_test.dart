import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';
import 'package:quickpalo/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:quickpalo/features/appointment/domain/usecases/check_availability_usecase.dart';

class MockAppointmentRepository extends Mock
    implements IAppointmentRepository {}

void main() {
  late CheckAvailabilityUsecase usecase;
  late MockAppointmentRepository mockRepository;

  final tParams = CheckAvailabilityParams(
    organizationId: 'org123',
    date: DateTime(2024, 1, 15),
    startTime: '09:00',
    endTime: '10:00',
    departmentId: 'dept123',
  );

  final tAvailabilityEntity = AvailabilityEntity(
    isAvailable: true,
    bookedCount: 0,
    departmentName: 'General Dentistry',
  );

  setUp(() {
    mockRepository = MockAppointmentRepository();
    usecase = CheckAvailabilityUsecase(repository: mockRepository);
  });

  group('CheckAvailabilityUsecase', () {
  
    test('should return AvailabilityEntity when check succeeds', () async {
      when(() => mockRepository.checkAvailability(tParams))
          .thenAnswer((_) async => Right(tAvailabilityEntity));

      final result = await usecase(tParams);

      expect(result, Right(tAvailabilityEntity));
    });

    test('should return failure when check fails', () async {
      final failure = ApiFailure(message: 'Server error');
      when(() => mockRepository.checkAvailability(tParams))
          .thenAnswer((_) async => Left(failure));

      final result = await usecase(tParams);

      expect(result, Left(failure));
    });
  });
}
