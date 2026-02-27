import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/api/api_client.dart';
import 'package:quickpalo/core/api/api_endpoints.dart';

final paymentRemoteDatasourceProvider =
    Provider<IPaymentRemoteDataSource>((ref) {
  return PaymentRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
  );
});

abstract interface class IPaymentRemoteDataSource {
  Future<String> createPaymentIntent({
    required double amount,
    String currency,
  });
}

class PaymentRemoteDataSource implements IPaymentRemoteDataSource {
  final ApiClient _apiClient;

  PaymentRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<String> createPaymentIntent({
    required double amount,
    String currency = 'npr',
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.createPaymentIntent,
        data: {
          'amount': amount,
          'currency': currency,
        },
      );

      if (response.data['success'] == true) {
        return response.data['data']['clientSecret'] as String;
      }

      throw Exception(
          response.data['message'] ?? 'Failed to create payment intent');
    } catch (e) {
      throw Exception('Failed to create payment intent: $e');
    }
  }
}
