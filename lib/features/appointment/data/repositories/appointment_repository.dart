import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/error/failures.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/remote/appointment_remote_datasource.dart';

final appointmentRepositoryProvider = Provider<IAppointmentRepository>((ref) {
  final remoteDatasource = ref.read(appointmentRemoteDatasourceProvider);
  return AppointmentRepository(remoteDatasource: remoteDatasource);
});

class AppointmentRepository implements IAppointmentRepository {
  final IAppointmentRemoteDataSource _remoteDatasource;

  AppointmentRepository({
    required IAppointmentRemoteDataSource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreateAppointmentParams params) async {
    try {
      final model = await _remoteDatasource.createAppointment(params);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> getAppointmentById(
      String appointmentId) async {
    try {
      final model = await _remoteDatasource.getAppointmentById(appointmentId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getUserAppointments() async {
    try {
      final models = await _remoteDatasource.getUserAppointments();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> updateAppointment(
      String appointmentId, Map<String, dynamic> updateData) async {
    try {
      final model =
          await _remoteDatasource.updateAppointment(appointmentId, updateData);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> cancelAppointment(
      String appointmentId) async {
    try {
      final model = await _remoteDatasource.cancelAppointment(appointmentId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AvailabilityEntity>> checkAvailability(
      CheckAvailabilityParams params) async {
    try {
      final model = await _remoteDatasource.checkAvailability(params);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
