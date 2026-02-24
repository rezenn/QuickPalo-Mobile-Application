import 'package:equatable/equatable.dart';
import '../../domain/entities/appointment_entity.dart';

enum AppointmentScreenStatus {
  initial,
  loading,
  loaded,
  creating,
  success,
  error,
  checking,
}

class AppointmentState extends Equatable {
  final AppointmentScreenStatus status;
  final List<AppointmentEntity> appointments;
  final AppointmentEntity? selectedAppointment;
  final AvailabilityEntity? availability;
  final String? errorMessage;
  final String? successMessage;

  const AppointmentState({
    this.status = AppointmentScreenStatus.initial,
    this.appointments = const [],
    this.selectedAppointment,
    this.availability,
    this.errorMessage,
    this.successMessage,
  });

  AppointmentState copyWith({
    AppointmentScreenStatus? status,
    List<AppointmentEntity>? appointments,
    AppointmentEntity? selectedAppointment,
    bool resetSelectedAppointment = false,
    AvailabilityEntity? availability,
    bool resetAvailability = false,
    String? errorMessage,
    bool resetError = false,
    String? successMessage,
    bool resetSuccess = false,
  }) {
    return AppointmentState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      selectedAppointment: resetSelectedAppointment
          ? null
          : (selectedAppointment ?? this.selectedAppointment),
      availability:
          resetAvailability ? null : (availability ?? this.availability),
      errorMessage: resetError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          resetSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  bool get isLoading =>
      status == AppointmentScreenStatus.loading ||
      status == AppointmentScreenStatus.creating ||
      status == AppointmentScreenStatus.checking;

  @override
  List<Object?> get props => [
        status,
        appointments,
        selectedAppointment,
        availability,
        errorMessage,
        successMessage,
      ];
}
