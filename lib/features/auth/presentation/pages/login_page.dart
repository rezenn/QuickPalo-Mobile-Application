import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/app/theme/app_colors.dart';
import 'package:quickpalo/core/utils/snackbar_utils.dart';
import 'package:quickpalo/features/auth/presentation/state/auth_state.dart';
import 'package:quickpalo/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:quickpalo/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:quickpalo/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:quickpalo/features/auth/presentation/pages/register_page.dart';
import 'package:quickpalo/core/widgets/custom_button.dart';
import 'package:quickpalo/core/widgets/custom_button2.dart';
import 'package:quickpalo/core/widgets/custom_label.dart';
import 'package:quickpalo/core/widgets/custom_text_button.dart';
import 'package:quickpalo/core/widgets/custom_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await ref.read(authViewModelProvider.notifier).login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth changes
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        SnackbarUtils.showSuccess(context, "Login successful");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (route) => false,
        );
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });
    final authState = ref.watch(authViewModelProvider);

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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          width: isTablet ? 250 : 200,
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.only(
                              topRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                            ),
                            child: Image.asset(
                              "assets/images/quickpalo_logo.png",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: isTablet ? 400 : double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontFamily: "Inter Bold 24",
                                ),
                              ),
                              SizedBox(height: 15),
                              CustomLabel(text: "Email", fontSize: 16),
                              SizedBox(height: 5),
                              CustomTextField(
                                controller: _emailController,
                                hintText: "hemraj@mail.com",
                                errortext: "Please enter a valid email",
                                // keyboardType: TextInputType.,
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                fieldType: FieldType.email,
                              ),
                              SizedBox(height: 25),
                              CustomLabel(text: "Password", fontSize: 16),
                              SizedBox(height: 5),
                              CustomTextField(
                                controller: _passwordController,
                                hintText: "********",
                                errortext: "Please enter a password",
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                keyboardType: TextInputType.text,
                                fieldType: FieldType.password,
                              ),
                              SizedBox(height: 15),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: CustomTextButton(
                                  text: "Forgot Password?",
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPasswordScreen()),
                                    );
                                  },
                                ),
                              ),
                              CustomButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                text: "Login",
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: textColorGrey,
                                    ),
                                  ),
                                  CustomTextButton(
                                    text: "Sign Up",
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text("Or"),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              CustomButton2(
                                onPressed: () {},
                                text: "Continue with Google",
                                imagePath: "assets/images/google.png",
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      // Add login button here
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
