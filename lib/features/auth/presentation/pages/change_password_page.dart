import 'package:flutter/material.dart';
import 'package:quickpalo/constant/colors.dart';
import 'package:quickpalo/screens/login_screen.dart';
import 'package:quickpalo/widgets/custom_button.dart';
import 'package:quickpalo/widgets/custom_label.dart';
import 'package:quickpalo/widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

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
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
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
                          key: _formKey1,
                          child: Column(
                            children: [
                              Text(
                                "Change Password",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontFamily: "Inter Bold 24",
                                ),
                              ),

                              SizedBox(height: 15),
                              CustomLabel(text: "New Password", fontSize: 16),
                              SizedBox(height: 5),
                              CustomTextField(
                                controller: passwordController,
                                hintText: "********",
                                errortext: "Please enter a new password",
                                obscureText: _obscureNewPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureNewPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureNewPassword =
                                          !_obscureNewPassword;
                                    });
                                  },
                                ),
                                keyboardType: TextInputType.text,
                                fieldType: FieldType.password,
                              ),
                              SizedBox(height: 25),
                              CustomLabel(
                                text: "Confirm New Password",
                                fontSize: 16,
                              ),
                              SizedBox(height: 5),
                              CustomTextField(
                                controller: confirmPasswordController,

                                hintText: "********",
                                errortext: "Please enter correct password",
                                obscureText: _obscureConfirmPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),

                                keyboardType: TextInputType.text,
                                fieldType: FieldType.password,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please confirm password";
                                  }
                                  if (value != passwordController.text) {
                                    return "Passwords do not match";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 15),
                              // Align(
                              //   alignment: Alignment.bottomRight,
                              //   child: CustomTextButton(
                              //     text: "Back to Login",
                              //     onPressed: () {
                              //       Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) =>
                              //               const LoginScreen(),
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // ),
                              CustomButton(
                                onPressed: () {
                                  if (_formKey1.currentState!.validate()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  }
                                },
                                text: "Change Password",
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
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
