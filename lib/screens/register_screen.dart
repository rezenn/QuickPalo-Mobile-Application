import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:quickpalo/constant/colors.dart';
import 'package:quickpalo/screens/login_screen.dart';
import 'package:quickpalo/widgets/custom_button.dart';
import 'package:quickpalo/widgets/custom_button2.dart';
import 'package:quickpalo/widgets/custom_label.dart';
import 'package:quickpalo/widgets/custom_text_button.dart';
import 'package:quickpalo/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.only(
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                        child: Image.asset("assets/images/quickpalo_logo.png"),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
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
                            "Register",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 5),
                          CustomLabel(text: "Full Name"),
                          CustomTextField(
                            controller: fullNameController,
                            hintText: "Hem Raj Shrestha",
                            errortext: "Please enter a valid full name",
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 5),
                          CustomLabel(text: "Email"),
                          CustomTextField(
                            controller: emailController,
                            hintText: "hemraj@mail.com",
                            errortext: "Please enter a valid email",
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 5),
                          CustomLabel(text: "Phone Number"),
                          const SizedBox(height: 5),
                          IntlPhoneField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              hintText: "9812345678",
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            initialCountryCode: "NP",
                            onChanged: (phone) {},
                            onCountryChanged: (country) {},
                          ),
                          SizedBox(height: 5),
                          CustomLabel(text: "Password"),
                          CustomTextField(
                            controller: passwordController,
                            hintText: "********",
                            errortext: "Please enter a password",
                          ),
                          SizedBox(height: 20),
                          CustomButton(onPressed: () {}, text: "Sign up"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
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
  }
}
