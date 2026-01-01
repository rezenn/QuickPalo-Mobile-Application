import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:quickpalo/app/theme/app_colors.dart';
import 'package:quickpalo/core/services/hive/hive_service.dart';
import 'package:quickpalo/core/utils/snackbar_utils.dart';
import 'package:quickpalo/features/auth/presentation/pages/login_page.dart';
import 'package:quickpalo/core/widgets/custom_button.dart';
import 'package:quickpalo/core/widgets/custom_button2.dart';
import 'package:quickpalo/core/widgets/custom_label.dart';
import 'package:quickpalo/core/widgets/custom_text_button.dart';
import 'package:quickpalo/core/widgets/custom_text_field.dart';
import 'package:quickpalo/features/auth/presentation/state/auth_state.dart';
import 'package:quickpalo/features/auth/presentation/view_model/auth_viewmodel.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignup() async {
    if (!_formKey1.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final hiveService = ref.read(hiveServiceProvider);

    // Check if email already exists
    if (hiveService.isEmailExist(email)) {
      SnackbarUtils.showError(context, "Email already registered");
      return;
    }

    ref.read(authViewmodelProvider.notifier).register(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewmodelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? 'Registration failed',
        );
      }

      if (next.status == AuthStatus.registered) {
        SnackbarUtils.showSuccess(context, 'Registration successful');
        Navigator.pop(context);
      }
    });

    final authState = ref.watch(authViewmodelProvider);
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              LightBlueColor,
              LightBlueColor2,
              LightPurpleColor,
              LightPurpleColor2,
              LightPurpleColor3,
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
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Form(
                      key: _formKey1,
                      child: Column(
                        children: [
                          const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: "Inter Bold 24",
                            ),
                          ),
                          const SizedBox(height: 5),
                          const CustomLabel(text: "Full Name"),
                          CustomTextField(
                            controller: _fullNameController,
                            hintText: "Hem Raj Shrestha",
                            errortext: "Please enter a valid full name",
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            fieldType: FieldType.text,
                          ),
                          const SizedBox(height: 5),
                          const CustomLabel(text: "Email"),
                          CustomTextField(
                            controller: _emailController,
                            hintText: "hemraj@mail.com",
                            errortext: "Please enter a valid email",
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            fieldType: FieldType.email,
                          ),
                          const SizedBox(height: 5),
                          const CustomLabel(text: "Phone Number"),
                          const SizedBox(height: 5),
                          IntlPhoneField(
                            controller: _phoneNumberController,
                            initialCountryCode: 'NP',
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              hintText: "9812345678",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            validator: (phone) {
                              if (phone == null || phone.number.isEmpty) {
                                return 'Phone number is required';
                              }
                              if (!phone.isValidNumber()) {
                                return 'Enter a valid phone number';
                              }
                              if (phone.number.length < 10) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 5),
                          const CustomLabel(text: "Password"),
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
                          const SizedBox(height: 20),
                          CustomButton(
                            onPressed: _handleSignup,
                            isLoading: authState.status == AuthStatus.loading,
                            text: "Sign up",
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textColorGrey,
                                ),
                              ),
                              CustomTextButton(
                                text: "Login",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
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
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Or",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: textColorGrey,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          CustomButton2(
                            onPressed: () {},
                            text: "Continue with Google",
                            imagePath: "assets/images/google.png",
                          ),
                          const SizedBox(height: 15),
                          CustomButton2(
                            onPressed: () {},
                            text: "Continue with Facebook",
                            imagePath: "assets/images/facebook.png",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
