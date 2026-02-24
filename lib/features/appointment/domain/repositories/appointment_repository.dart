import 'package:dartz/dartz.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';

abstract interface class IAppointmentRepository {
  Future<Either<Failure, AppointmentEntity>> createAppointment(
    CreateAppointmentParams params,
  );

  Future<Either<Failure, AppointmentEntity>> getAppointmentById(
    String appointmentId,
  );

  Future<Either<Failure, List<AppointmentEntity>>> getUserAppointments();

  Future<Either<Failure, AppointmentEntity>> updateAppointment(
    String appointmentId,
    Map<String, dynamic> updateData,
  );

  Future<Either<Failure, AppointmentEntity>> cancelAppointment(
      String appointmentId);

  Future<Either<Failure, AvailabilityEntity>> checkAvailability(
      CheckAvailabilityParams params);
}
