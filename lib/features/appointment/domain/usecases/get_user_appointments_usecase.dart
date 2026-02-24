import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/core/usecases/app_usecase.dart';
import 'package:quickpalo/features/appointment/data/repositories/appointment_repository.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';
import 'package:quickpalo/features/appointment/domain/repositories/appointment_repository.dart';

final getUserAppointmentsUsecaseProvider =
    Provider<GetUserAppointmentsUsecase>((ref) {
  return GetUserAppointmentsUsecase(
    repository: ref.read(appointmentRepositoryProvider),
  );
});

class GetUserAppointmentsUsecase
    implements UsecaseWithoutParams<List<AppointmentEntity>> {
  final IAppointmentRepository _repository;

  GetUserAppointmentsUsecase({required IAppointmentRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call() {
    return _repository.getUserAppointments();
  }
}
