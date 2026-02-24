import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/api/api_client.dart';
import 'package:quickpalo/core/api/api_endpoints.dart';
import 'package:quickpalo/features/appointment/data/models/appointment_api_model.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';

final appointmentRemoteDatasourceProvider =
    Provider<IAppointmentRemoteDataSource>((ref) {
  return AppointmentRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
  );
});

abstract interface class IAppointmentRemoteDataSource {
  Future<AppointmentApiModel> createAppointment(CreateAppointmentParams params);
  Future<AppointmentApiModel> getAppointmentById(String appointmentId);
  Future<List<AppointmentApiModel>> getUserAppointments();
  Future<AppointmentApiModel> updateAppointment(
      String appointmentId, Map<String, dynamic> data);
  Future<AppointmentApiModel> cancelAppointment(String appointmentId);
  Future<AvailabilityApiModel> checkAvailability(
      CheckAvailabilityParams params);
}

class AppointmentRemoteDataSource implements IAppointmentRemoteDataSource {
  final ApiClient _apiClient;

  AppointmentRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<AppointmentApiModel> createAppointment(
      CreateAppointmentParams params) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.appointments,
        data: params.toJson(),
      );
      if (response.data['success'] == true) {
        return AppointmentApiModel.fromJson(response.data['data']);
      }
      throw Exception(
          response.data['message'] ?? 'Failed to create appointment');
    } catch (e) {
      throw Exception('Failed to create appointment: $e');
    }
  }

  @override
  Future<AppointmentApiModel> getAppointmentById(String appointmentId) async {
    try {
      final response =
          await _apiClient.get(ApiEndpoints.appointmentById(appointmentId));
      if (response.data['success'] == true) {
        return AppointmentApiModel.fromJson(response.data['data']);
      }
      throw Exception('Appointment not found');
    } catch (e) {
      throw Exception('Failed to get appointment: $e');
    }
  }

  @override
  Future<List<AppointmentApiModel>> getUserAppointments() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.userAppointments);
      if (response.data['success'] == true) {
        final data = response.data['data'];
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map((item) => AppointmentApiModel.fromJson(item))
              .toList();
        }
        return [];
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get user appointments: $e');
    }
  }

  @override
  Future<AppointmentApiModel> updateAppointment(
      String appointmentId, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.appointmentById(appointmentId),
        data: data,
      );
      if (response.data['success'] == true) {
        return AppointmentApiModel.fromJson(response.data['data']);
      }
      throw Exception(
          response.data['message'] ?? 'Failed to update appointment');
    } catch (e) {
      throw Exception('Failed to update appointment: $e');
    }
  }

  @override
  Future<AppointmentApiModel> cancelAppointment(String appointmentId) async {
    try {
      final response = await _apiClient.patch(
        ApiEndpoints.cancelAppointment(appointmentId),
      );
      if (response.data['success'] == true) {
        return AppointmentApiModel.fromJson(response.data['data']);
      }
      throw Exception(
          response.data['message'] ?? 'Failed to cancel appointment');
    } catch (e) {
      throw Exception('Failed to cancel appointment: $e');
    }
  }

  @override
  Future<AvailabilityApiModel> checkAvailability(
      CheckAvailabilityParams params) async {
    try {
      final queryParams = {
        'organizationId': params.organizationId,
        'date': params.date.toIso8601String(),
        'startTime': params.startTime,
        'endTime': params.endTime,
        if (params.departmentId != null) 'departmentId': params.departmentId,
      };
      final response = await _apiClient.get(
        ApiEndpoints.checkAvailability,
        queryParameters: queryParams,
      );
      if (response.data['success'] == true) {
        return AvailabilityApiModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to check availability');
    } catch (e) {
      throw Exception('Failed to check availability: $e');
    }
  }
}
