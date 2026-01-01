import 'package:flutter/material.dart';
import 'package:quickpalo/constant/colors.dart';
import 'package:quickpalo/screens/change_password_screen.dart';
import 'package:quickpalo/widgets/custom_button.dart';
import 'package:quickpalo/widgets/custom_label.dart';
import 'package:quickpalo/widgets/custom_otp_input.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final otp1 = TextEditingController();
  final otp2 = TextEditingController();
  final otp3 = TextEditingController();
  final otp4 = TextEditingController();
  final otp5 = TextEditingController();
  final otp6 = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    otp1.dispose();
    otp2.dispose();
    otp3.dispose();
    otp4.dispose();
    otp5.dispose();
    otp6.dispose();
    super.dispose();
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
                  LightBlueColor,
                  LightBlueColor2,
                  LightPurpleColor,
                  LightPurpleColor2,
                  LightPurpleColor3,
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
                        padding: const EdgeInsets.fromLTRB(15, 70, 15, 20),
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  "Verify OTP",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontFamily: "Inter Bold 24",
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),

                              const Text(
                                "We have sent a 6-digit verification code to your email address he*************m",
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 20),

                              const CustomLabel(text: "OTP Code"),
                              const SizedBox(height: 5),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomOtpInput(
                                    controller: otp1,
                                    autoFocus: true,
                                  ),
                                  SizedBox(width: isTablet ? 14 : 8),
                                  CustomOtpInput(controller: otp2),
                                  SizedBox(width: isTablet ? 14 : 8),
                                  CustomOtpInput(controller: otp3),
                                  SizedBox(width: isTablet ? 14 : 8),
                                  CustomOtpInput(controller: otp4),
                                  SizedBox(width: isTablet ? 14 : 8),
                                  CustomOtpInput(controller: otp5),
                                  SizedBox(width: isTablet ? 14 : 8),
                                  CustomOtpInput(controller: otp6),
                                ],
                              ),

                              const SizedBox(height: 25),

                              CustomButton(
                                text: "Verify OTP",
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    final otpCode =
                                        otp1.text +
                                        otp2.text +
                                        otp3.text +
                                        otp4.text +
                                        otp5.text +
                                        otp6.text;

                                    if (otpCode.length != 6) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Enter complete OTP"),
                                        ),
                                      );
                                      return;
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ChangePasswordScreen(),
                                      ),
                                    );
                                  }
                                },
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
      },
    );
  }
}
