import 'package:flutter/material.dart';
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

  Future<bool> processPayment({
    required double amount,
    required String merchantName,
  }) async {
    final clientSecret = await _datasource.createPaymentIntent(
      amount: amount,
      currency: 'npr',
    );

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: merchantName,
        paymentMethodOrder: ['card'],
        googlePay: null,
        applePay: null,
        appearance: const PaymentSheetAppearance(
          colors: PaymentSheetAppearanceColors(
            background: Color(0xFFFFFFFF),
            primary: Color(0xFFB61BE1),
            componentBackground: Color(0xFFF5F4FF),
            componentBorder: Color(0xFFDDD8FF),
            componentDivider: Color(0xFFDDD8FF),
            primaryText: Color(0xFF2D3436),
            secondaryText: Color(0xFF636E72),
            componentText: Color(0xFF2D3436),
            placeholderText: Color(0xFF636E72),
            icon: Color(0xFF6C5CE7),
          ),
          shapes: PaymentSheetShape(
            borderRadius: 12,
          ),
        ),
      ),
    );

    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return false; 
      }
      throw Exception('Payment failed');
    }
  }
}
