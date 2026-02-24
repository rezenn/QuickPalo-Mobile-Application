import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import 'package:quickpalo/core/usecases/app_usecase.dart';
import 'package:quickpalo/features/appointment/data/repositories/appointment_repository.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';
import 'package:quickpalo/features/appointment/domain/repositories/appointment_repository.dart';

final checkAvailabilityUsecaseProvider =
    Provider<CheckAvailabilityUsecase>((ref) {
  return CheckAvailabilityUsecase(
    repository: ref.read(appointmentRepositoryProvider),
  );
});

class CheckAvailabilityUsecase
    implements UsecaseWithParams<AvailabilityEntity, CheckAvailabilityParams> {
  final IAppointmentRepository _repository;

  CheckAvailabilityUsecase({required IAppointmentRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, AvailabilityEntity>> call(
      CheckAvailabilityParams params) {
    return _repository.checkAvailability(params);
  }
}
