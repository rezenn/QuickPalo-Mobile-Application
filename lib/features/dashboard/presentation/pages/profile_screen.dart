import 'package:flutter/material.dart';
import 'package:quickpalo/core/utils/snackbar_utils.dart';
import 'package:quickpalo/core/widgets/custom_button.dart';
import 'package:quickpalo/features/auth/presentation/pages/login_page.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          child: Column(
            children: [
              Center(
                child: Text(
                  "Profile",
                  style: const TextStyle(
                    fontFamily: "Inter Bold 24",
                    fontSize: 24,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Profile Screen"),
              CustomButton(
                  onPressed: () {
                    SnackbarUtils.showSuccess(context, 'Logout successful');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  text: "Logout"),
            ],
          ),
        ),
      ),
    );
  }
}
