import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quickpalo/app/theme/app_colors.dart';
import 'package:quickpalo/core/widgets/custom_button.dart';
import 'package:quickpalo/core/widgets/custom_label.dart';
import 'package:quickpalo/core/widgets/custom_text_field.dart';
import 'package:quickpalo/core/api/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.post(
        '/auth/request-password-reset',
        data: {"email": emailController.text.trim()},
      );

      if (response.data['success'] == true) {
        setState(() => _emailSent = true);
      } else {
        _showError(response.data['message'] ?? 'Something went wrong');
      }
    } on DioException catch (e) {
      final serverMessage = e.response?.data?['message'];
      final statusCode = e.response?.statusCode;
      _showError(
          '[$statusCode] ${serverMessage ?? e.message ?? 'DioException'}');
    } catch (e) {
      _showError('Unexpected error: ${e.runtimeType}: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  lightBlueColor,
                  lightBlueColor2,
                  lightPurpleColor,
                  lightPurpleColor2,
                  lightPurpleColor3,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Center(
                        child: SizedBox(
                          width: isTablet ? 250 : 200,
                          child: Image.asset(
                            "assets/images/quickpalo_logo.png",
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: isTablet ? 400 : double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child:
                            _emailSent ? _buildSuccessView() : _buildFormView(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "Forgot Password",
              style: TextStyle(
                fontSize: 28,
                fontFamily: "Inter Bold 24",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              "Enter your email address and we'll send you a link to reset your password.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          const SizedBox(height: 28),
          const CustomLabel(text: "Email Address"),
          const SizedBox(height: 6),
          CustomTextField(
            controller: emailController,
            hintText: "your@email.com",
            errortext: "Please enter your email",
            keyboardType: TextInputType.emailAddress,
            fieldType: FieldType.email,
            obscureText: false,
          ),
          const SizedBox(height: 28),
          CustomButton(
            text: "Send Reset Link",
            isLoading: _isLoading,
            onPressed: _isLoading ? null : _sendResetLink,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Back to Login",
                style: TextStyle(color: lightPurpleColor2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      children: [
        const Icon(
          Icons.mark_email_read_outlined,
          size: 64,
          color: lightPurpleColor2,
        ),
        const SizedBox(height: 20),
        const Text(
          "Check Your Email",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          "We've sent a password reset link to\n${emailController.text.trim()}",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 8),
        const Text(
          "The link will expire in 1 hour.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 28),
        CustomButton(
          text: "Back to Login",
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => setState(() {
            _emailSent = false;
            emailController.clear();
          }),
          child: const Text(
            "Try a different email",
            style: TextStyle(color: lightPurpleColor2),
          ),
        ),
      ],
    );
  }
}
