import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/app/theme/app_colors.dart';
import 'package:quickpalo/core/utils/snackbar_utils.dart';
import 'package:quickpalo/core/widgets/custom_button.dart';
import 'package:quickpalo/features/auth/presentation/pages/login_page.dart';
import 'package:quickpalo/features/auth/presentation/state/auth_state.dart';
import 'package:quickpalo/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:quickpalo/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:quickpalo/features/profile/presentation/widgets/profile_action_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
        title: Text(
          "Logout",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: lightPurpleColor2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              // Clear user session
              await ref.read(authViewModelProvider.notifier).logout();
            },
            child: Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.unauthenticated) {
        SnackbarUtils.showSuccess(context, 'Logout successful');

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }

      if (next.status == AuthStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? 'Something went wrong',
        );
      }
    });
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: Text(
                    "Profile",
                    style: const TextStyle(
                      fontFamily: "Inter Bold 24",
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
                height: 2,
              ),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                        child: Container(
                          height: 160,
                          width: double.infinity,
                          color: buttonColor3.withAlpha(120),
                        ),
                      ),
                    ),
                  ),

                  // Profile image overlay
                  Positioned(
                    bottom: -40,
                    child: Container(
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
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                "Test User",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inter bold 24",
                    fontSize: 26),
              ),
              const SizedBox(height: 16),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Phone",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: "Inter Regular",
                          fontSize: 18),
                    ),
                    Text(
                      "9877654321",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Inter bold 24",
                          color: Colors.black87.withAlpha(200),
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: "Inter Regular",
                          fontSize: 18),
                    ),
                    Text(
                      "testuser@gmail.com",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Inter bold 24",
                          color: Colors.black87.withAlpha(200),
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  color: Colors.black,
                  height: 3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ProfileActionButton(
                      icon: Icons.dark_mode_outlined,
                      label: "Dark Mode",
                      onPressed: () {},
                    ),
                    const SizedBox(height: 10),
                    ProfileActionButton(
                      icon: Icons.notifications_rounded,
                      label: "Notifications",
                      onPressed: () {},
                    ),
                    const SizedBox(height: 10),
                    ProfileActionButton(
                      icon: Icons.person,
                      label: "Edit Profile",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    ProfileActionButton(
                      icon: Icons.calendar_month_outlined,
                      label: "Calendar",
                      onPressed: () {},
                    ),
                    const SizedBox(height: 10),
                    ProfileActionButton(
                      icon: Icons.logout,
                      label: "Logout",
                      color: Colors.red,
                      onPressed: () => _showLogoutDialog(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
