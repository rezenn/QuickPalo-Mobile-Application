import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:quickpalo/features/appointment/data/datasources/remote/payment_remote_datasource.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService(
    datasource: ref.read(paymentRemoteDatasourceProvider),
  );
});

class PaymentService {
  final IPaymentRemoteDataSource _datasource;

  PaymentService({required IPaymentRemoteDataSource datasource})
      : _datasource = datasource;

  /// Returns true if payment succeeded, false if cancelled/failed.
  /// Throws on unexpected errors.
  Future<bool> processPayment({
    required double amount,
    required String merchantName,
    String currency = 'npr',
  }) async {
    // 1. Create payment intent on backend
    final clientSecret = await _datasource.createPaymentIntent(
      amount: amount,
      currency: currency,
    );

    // 2. Initialize Stripe payment sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: merchantName,
      ),
    );

    // 3. Present the sheet — throws StripeException if cancelled/failed
    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return false; // user cancelled — not an error
      }
      // Re-throw real failures (card declined, etc.)
      throw Exception('Payment failed');
    }
  }
}
