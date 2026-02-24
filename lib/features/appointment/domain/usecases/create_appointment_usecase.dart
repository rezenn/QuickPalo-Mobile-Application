import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/core/usecases/app_usecase.dart';
import 'package:quickpalo/features/appointment/data/repositories/appointment_repository.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';
import 'package:quickpalo/features/appointment/domain/repositories/appointment_repository.dart';

final createAppointmentUsecaseProvider =
    Provider<CreateAppointmentUsecase>((ref) {
  return CreateAppointmentUsecase(
    repository: ref.read(appointmentRepositoryProvider),
  );
});

class CreateAppointmentUsecase
    implements UsecaseWithParams<AppointmentEntity, CreateAppointmentParams> {
  final IAppointmentRepository _repository;

  CreateAppointmentUsecase({required IAppointmentRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, AppointmentEntity>> call(
      CreateAppointmentParams params) {
    return _repository.createAppointment(params);
  }
}
