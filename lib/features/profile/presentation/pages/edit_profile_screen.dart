import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:quickpalo/app/theme/app_colors.dart';
import 'package:quickpalo/core/widgets/custom_button.dart';
import 'package:quickpalo/core/widgets/custom_label.dart';
import 'package:quickpalo/core/widgets/custom_text_field.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Edit Profile",
        ),
        bottom: PreferredSize(
          preferredSize:
              const Size.fromHeight(1.0), // Set the height of the line
          child: Container(
            color: Colors.black, // Set the color of the line
            height: 1.0, // Set the height of the Container (line thickness)
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Background with blur
                ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      color: buttonColor3.withAlpha(120),
                    ),
                  ),
                ),

                // Overlay card
                Positioned(
                  bottom: -530,
                  child: Container(
                    width: 400,
                    height: 620,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Form(
                        key: _formKey1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black87,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: Text(
                                  "R",
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: lightPurpleColor3,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: lightPurpleColor3,
                                  foregroundColor: Colors.white),
                              onPressed: () {},
                              child: Text(
                                "Change Profile",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            const CustomLabel(text: "Full Name"),
                            CustomTextField(
                              controller: _fullNameController,
                              hintText: "Test User",
                              errortext: "Please enter a valid full name",
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              fieldType: FieldType.text,
                            ),
                            const SizedBox(height: 5),
                            const CustomLabel(text: "Email"),
                            CustomTextField(
                              controller: _fullNameController,
                              hintText: "testuser@gmail.com",
                              errortext: "Please enter a valid email",
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              fieldType: FieldType.text,
                            ),
                            const SizedBox(height: 5),
                            const CustomLabel(text: "Phone Number"),
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
                                  borderSide:
                                      const BorderSide(color: Colors.red),
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
                            CustomButton(
                              onPressed: () {},
                              text: "Save Profile",
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                              onPressed: () {},
                              text: "Change Password",
                              color: buttonColor3,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60), // must match overlay offset
          ],
        ),
      ),
    );
  }
}
