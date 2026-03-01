import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';
import 'package:quickpalo/features/appointment/domain/usecases/cancel_appointment_usecase.dart';
import 'package:quickpalo/features/appointment/domain/usecases/check_availability_usecase.dart';
import 'package:quickpalo/features/appointment/domain/usecases/create_appointment_usecase.dart';
import 'package:quickpalo/features/appointment/domain/usecases/get_appointment_by_id_usecase.dart';
import 'package:quickpalo/features/appointment/domain/usecases/get_user_appointments_usecase.dart';
import 'package:quickpalo/features/appointment/presentation/state/appointment_state.dart';
import 'package:quickpalo/features/appointment/presentation/view_model/appointment_viewmodel.dart';

class MockCreateAppointmentUsecase extends Mock implements CreateAppointmentUsecase {}
class MockGetAppointmentByIdUsecase extends Mock implements GetAppointmentByIdUsecase {}
class MockGetUserAppointmentsUsecase extends Mock implements GetUserAppointmentsUsecase {}
class MockCancelAppointmentUsecase extends Mock implements CancelAppointmentUsecase {}
class MockCheckAvailabilityUsecase extends Mock implements CheckAvailabilityUsecase {}

void main() {
  late ProviderContainer container;
  late MockCreateAppointmentUsecase mockCreate;
  late MockGetAppointmentByIdUsecase mockGetById;
  late MockGetUserAppointmentsUsecase mockGetUser;
  late MockCancelAppointmentUsecase mockCancel;
  late MockCheckAvailabilityUsecase mockCheck;

  final tTimeslot = TimeSlotEntity(startTime: '09:00', endTime: '10:00');
  
  final tCreateParams = CreateAppointmentParams(
    organizationId: 'org123',
    departmentId: 'dept123',
    clientName: 'John Doe',
    clientEmail: 'john@example.com',
    clientPhoneNumber: '1234567890',
    timeslot: tTimeslot,
    date: DateTime(2024, 1, 15),
  );

  final tAppointment = AppointmentEntity(
    id: 'apt123',
    organizationId: 'org123',
    userId: 'user123',
    departmentId: 'dept123',
    departmentName: 'General Dentistry',
    clientName: 'John Doe',
    clientEmail: 'john@example.com',
    clientPhoneNumber: '1234567890',
    timeslot: tTimeslot,
    date: DateTime(2024, 1, 15),
  );

  setUp(() {
    mockCreate = MockCreateAppointmentUsecase();
    mockGetById = MockGetAppointmentByIdUsecase();
    mockGetUser = MockGetUserAppointmentsUsecase();
    mockCancel = MockCancelAppointmentUsecase();
    mockCheck = MockCheckAvailabilityUsecase();

    container = ProviderContainer(overrides: [
      createAppointmentUsecaseProvider.overrideWithValue(mockCreate),
      getAppointmentByIdUsecaseProvider.overrideWithValue(mockGetById),
      getUserAppointmentsUsecaseProvider.overrideWithValue(mockGetUser),
      cancelAppointmentUsecaseProvider.overrideWithValue(mockCancel),
      checkAvailabilityUsecaseProvider.overrideWithValue(mockCheck),
    ]);
  });

  tearDown(() {
    container.dispose();
  });


  group('AppointmentViewModel - cancelAppointment', () {
    test('should update appointments list when cancellation succeeds', () async {
      // Setup initial state with appointments
      final cancelledAppointment = tAppointment.copyWith(status: AppointmentStatus.cancelled);
      container.read(appointmentViewModelProvider.notifier).state = 
          container.read(appointmentViewModelProvider).copyWith(
        appointments: [tAppointment],
      );

      when(() => mockCancel.call('apt123'))
          .thenAnswer((_) async => Right(cancelledAppointment));

      final result = await container.read(appointmentViewModelProvider.notifier)
          .cancelAppointment('apt123');

      expect(result, true);
      final state = container.read(appointmentViewModelProvider);
      expect(state.appointments.first.status, AppointmentStatus.cancelled);
      expect(state.successMessage, 'Appointment cancelled.');
    });
  });

  group('AppointmentViewModel - getUserAppointments', () {
    test('should load appointments successfully', () async {
      when(() => mockGetUser.call())
          .thenAnswer((_) async => Right([tAppointment]));

      await container.read(appointmentViewModelProvider.notifier)
          .getUserAppointments();

      final state = container.read(appointmentViewModelProvider);
      expect(state.status, AppointmentScreenStatus.loaded);
      expect(state.appointments.length, 1);
      expect(state.appointments.first, tAppointment);
    });
  });
}