import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/appointment/domain/usecases/cancel_appointmnet_usecase.dart';
import 'package:quickpalo/features/appointment/domain/usecases/check_availability_usecase.dart';
import 'package:quickpalo/features/appointment/domain/usecases/create_appointment_usecase.dart';
import 'package:quickpalo/features/appointment/domain/usecases/get_appointment_by_id_usecase.dart';
import 'package:quickpalo/features/appointment/domain/usecases/get_user_appointments_usecase.dart';
import '../../domain/entities/appointment_entity.dart';
import '../state/appointment_state.dart';

final appointmentViewModelProvider =
    NotifierProvider<AppointmentViewModel, AppointmentState>(
  AppointmentViewModel.new,
);

class AppointmentViewModel extends Notifier<AppointmentState> {
  late final CreateAppointmentUsecase _createAppointment;
  late final GetAppointmentByIdUsecase _getAppointmentById;
  late final GetUserAppointmentsUsecase _getUserAppointments;
  late final CancelAppointmentUsecase _cancelAppointment;
  late final CheckAvailabilityUsecase _checkAvailability;

  @override
  AppointmentState build() {
    _createAppointment = ref.read(createAppointmentUsecaseProvider);
    _getAppointmentById = ref.read(getAppointmentByIdUsecaseProvider);
    _getUserAppointments = ref.read(getUserAppointmentsUsecaseProvider);
    _cancelAppointment = ref.read(cancelAppointmentUsecaseProvider);
    _checkAvailability = ref.read(checkAvailabilityUsecaseProvider);
    return const AppointmentState();
  }

  Future<bool> createAppointment(CreateAppointmentParams params) async {
    state = state.copyWith(
      status: AppointmentScreenStatus.creating,
      resetError: true,
      resetSuccess: true,
    );

    final result = await _createAppointment(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AppointmentScreenStatus.error,
          errorMessage: _mapFailure(failure),
        );
        return false;
      },
      (appointment) {
        state = state.copyWith(
          status: AppointmentScreenStatus.success,
          selectedAppointment: appointment,
          successMessage: 'Appointment booked successfully!',
          appointments: [appointment, ...state.appointments],
        );
        return true;
      },
    );
  }

  Future<void> getUserAppointments() async {
    state = state.copyWith(
      status: AppointmentScreenStatus.loading,
      resetError: true,
    );

    final result = await _getUserAppointments();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AppointmentScreenStatus.error,
          errorMessage: _mapFailure(failure),
        );
      },
      (appointments) {
        state = state.copyWith(
          status: AppointmentScreenStatus.loaded,
          appointments: appointments,
        );
      },
    );
  }

  Future<void> getAppointmentById(String id) async {
    state = state.copyWith(
      status: AppointmentScreenStatus.loading,
      resetError: true,
    );

    final result = await _getAppointmentById(id);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AppointmentScreenStatus.error,
          errorMessage: _mapFailure(failure),
        );
      },
      (appointment) {
        state = state.copyWith(
          status: AppointmentScreenStatus.loaded,
          selectedAppointment: appointment,
        );
      },
    );
  }

  Future<bool> cancelAppointment(String appointmentId) async {
    state = state.copyWith(
      status: AppointmentScreenStatus.loading,
      resetError: true,
    );

    final result = await _cancelAppointment(appointmentId);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AppointmentScreenStatus.error,
          errorMessage: _mapFailure(failure),
        );
        return false;
      },
      (cancelled) {
        final updated = state.appointments
            .map((a) => a.id == cancelled.id ? cancelled : a)
            .toList();
        state = state.copyWith(
          status: AppointmentScreenStatus.loaded,
          appointments: updated,
          selectedAppointment: cancelled,
          successMessage: 'Appointment cancelled.',
        );
        return true;
      },
    );
  }

  Future<void> checkAvailability(CheckAvailabilityParams params) async {
    state = state.copyWith(
      status: AppointmentScreenStatus.checking,
      resetAvailability: true,
      resetError: true,
    );

    final result = await _checkAvailability(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AppointmentScreenStatus.error,
          errorMessage: _mapFailure(failure),
        );
      },
      (availability) {
        state = state.copyWith(
          status: AppointmentScreenStatus.loaded,
          availability: availability,
        );
      },
    );
  }

  void clearError() => state = state.copyWith(resetError: true);
  void clearSuccess() => state = state.copyWith(resetSuccess: true);
  void clearAvailability() => state = state.copyWith(resetAvailability: true);

  String _mapFailure(Failure failure) {
    if (failure is ApiFailure) {
      final msg = failure.message
          .replaceAll('Exception: Failed to', '')
          .replaceAll('Exception:', '')
          .trim();
      return msg.isNotEmpty ? msg : 'Something went wrong';
    }
    if (failure is NetworkFailure) return 'No internet connection';
    return failure.message.isNotEmpty ? failure.message : 'Unexpected error';
  }
}
