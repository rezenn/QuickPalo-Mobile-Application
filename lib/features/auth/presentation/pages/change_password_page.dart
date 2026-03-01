import 'package:flutter/material.dart';
import 'package:quickpalo/app/theme/app_colors.dart';
import 'package:quickpalo/features/auth/presentation/pages/login_page.dart';
import 'package:quickpalo/core/widgets/custom_button.dart';
import 'package:quickpalo/core/widgets/custom_label.dart';
import 'package:quickpalo/core/widgets/custom_text_field.dart';
import 'package:quickpalo/core/api/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  final String token;

  const ChangePasswordScreen({super.key, required this.token});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.post(
        '/auth/reset-password/${widget.token}',
        data: {"newPassword": passwordController.text},
      );

      if (response.data['success'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password changed successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      } else {
        _showError(response.data['message'] ?? 'Failed to reset password');
      }
    } catch (e) {
      _showError('Something went wrong. The link may have expired.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                stops: [0.0, 0.13, 0.5, 0.78, 1.0],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          width: isTablet ? 250 : 200,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                            ),
                            child: Image.asset(
                              "assets/images/quickpalo_logo.png",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: isTablet ? 400 : double.infinity,
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
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const Text(
                                "Change Password",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontFamily: "Inter Bold 24",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Enter your new password below.",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              const SizedBox(height: 24),

                              // New Password
                              CustomLabel(text: "New Password", fontSize: 16),
                              const SizedBox(height: 6),
                              CustomTextField(
                                controller: passwordController,
                                hintText: "••••••••",
                                errortext: "Please enter a new password",
                                obscureText: _obscureNewPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureNewPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => setState(() {
                                    _obscureNewPassword = !_obscureNewPassword;
                                  }),
                                ),
                                keyboardType: TextInputType.text,
                                fieldType: FieldType.password,
                              ),
                              const SizedBox(height: 20),

                              // Confirm Password
                              CustomLabel(
                                  text: "Confirm New Password", fontSize: 16),
                              const SizedBox(height: 6),
                              CustomTextField(
                                controller: confirmPasswordController,
                                hintText: "••••••••",
                                errortext: "Please confirm your password",
                                obscureText: _obscureConfirmPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  }),
                                ),
                                keyboardType: TextInputType.text,
                                fieldType: FieldType.password,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please confirm your password";
                                  }
                                  if (value != passwordController.text) {
                                    return "Passwords do not match";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 28),

                              CustomButton(
                                text: "Change Password",
                                isLoading: _isLoading,
                                onPressed: _isLoading ? null : _changePassword,
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "Back to Login",
                                  style: TextStyle(color: lightPurpleColor2),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
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
}
