import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/core/usecases/app_usecase.dart';
import 'package:quickpalo/features/appointment/data/repositories/appointment_repository.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';
import 'package:quickpalo/features/appointment/domain/repositories/appointment_repository.dart';

final getAppointmentByIdUsecaseProvider =
    Provider<GetAppointmentByIdUsecase>((ref) {
  return GetAppointmentByIdUsecase(
    repository: ref.read(appointmentRepositoryProvider),
  );
});

class GetAppointmentByIdUsecase
    implements UsecaseWithParams<AppointmentEntity, String> {
  final IAppointmentRepository _repository;
  GetAppointmentByIdUsecase({required IAppointmentRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, AppointmentEntity>> call(String appointmentId) {
    return _repository.getAppointmentById(appointmentId);
  }
}
