import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/core/usecases/app_usecase.dart';
import 'package:quickpalo/features/appointment/data/repositories/appointment_repository.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';
import 'package:quickpalo/features/appointment/domain/repositories/appointment_repository.dart';

final cancelAppointmentUsecaseProvider =
    Provider<CancelAppointmentUsecase>((ref) {
  return CancelAppointmentUsecase(
    repository: ref.read(appointmentRepositoryProvider),
  );
});

class CancelAppointmentUsecase
    implements UsecaseWithParams<AppointmentEntity, String> {
  final IAppointmentRepository _repository;

  CancelAppointmentUsecase({required IAppointmentRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, AppointmentEntity>> call(String appointmentId) {
    return _repository.cancelAppointment(appointmentId);
  }
}
