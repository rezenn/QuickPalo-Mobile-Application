import 'package:flutter/material.dart';
import 'package:quickpalo/constant/colors.dart';
import 'package:quickpalo/screens/dashboard_screen.dart';
import 'package:quickpalo/screens/register_screen.dart';
import 'package:quickpalo/widgets/custom_button.dart';
import 'package:quickpalo/widgets/custom_button2.dart';
import 'package:quickpalo/widgets/custom_label.dart';
import 'package:quickpalo/widgets/custom_text_button.dart';
import 'package:quickpalo/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  bool _obscurePassword = true;

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
                          key: _formKey1,
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
                                controller: emailController,
                                hintText: "hemraj@mail.com",
                                errortext: "Please enter a valid email",
                                // keyboardType: TextInputType.,
                                obscureText: false,
                              ),
                              SizedBox(height: 25),
                              CustomLabel(text: "Password", fontSize: 16),
                              SizedBox(height: 5),
                              CustomTextField(
                                controller: passwordController,
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
                              ),
                              SizedBox(height: 15),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: CustomTextButton(
                                  text: "Forgot Password?",
                                  onPressed: () {},
                                ),
                              ),
                              CustomButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardScreen(),
                                    ),
                                  );
                                },
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
                              SizedBox(height: 15),
                              CustomButton2(
                                onPressed: () {},
                                text: "Continue with Facebook",
                                imagePath: 'assets/images/facebook.png',
                              ),
                              SizedBox(height: 30),
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
