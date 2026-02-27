import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/app/theme/app_colors.dart';
import 'package:quickpalo/core/services/biometric/biometric_preference_service.dart';
import 'package:quickpalo/core/services/biometric/biometric_service.dart';
import 'package:quickpalo/core/services/storage/user_session_service.dart';
import 'package:quickpalo/core/utils/snackbar_utils.dart';
import 'package:quickpalo/features/auth/presentation/pages/login_page.dart';
import 'package:quickpalo/features/auth/presentation/state/auth_state.dart';
import 'package:quickpalo/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:quickpalo/features/dashboard/presentation/pages/calendar_screen.dart';
import 'package:quickpalo/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:quickpalo/features/profile/presentation/widgets/profile_action_button.dart';
import 'package:quickpalo/features/sensor/presentation/providers/proximity_toggle_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // Biometric state managed here so it can be updated
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricState();
  }

  Future<void> _loadBiometricState() async {
    final biometricService = ref.read(biometricServiceProvider);
    final prefService = ref.read(biometricPreferenceServiceProvider);

    final available = await biometricService.isAvailable();
    final enabled = await prefService.isEnabled();

    if (mounted) {
      setState(() {
        _biometricAvailable = available;
        _biometricEnabled = enabled;
      });
    }
  }

  Future<void> _toggleBiometric() async {
    final prefService = ref.read(biometricPreferenceServiceProvider);

    if (_biometricEnabled) {
      await prefService.disable();
      if (mounted) {
        setState(() => _biometricEnabled = false);
        SnackbarUtils.showSuccess(context, 'Biometric login disabled');
      }
    } else {
      _showReEnableDialog();
    }
  }

  void _showReEnableDialog() {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Enable Biometric Login'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your credentials to enable biometric login'),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailCtrl.text.trim().isEmpty ||
                  passCtrl.text.trim().isEmpty) {
                return;
              }
              Navigator.pop(ctx);
              await ref
                  .read(biometricPreferenceServiceProvider)
                  .enable(emailCtrl.text.trim(), passCtrl.text.trim());
              if (mounted) {
                setState(() => _biometricEnabled = true);
                SnackbarUtils.showSuccess(context, 'Biometric login enabled!');
              }
            },
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black45,
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
              await ref.read(authViewModelProvider.notifier).logout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.bold),
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

    final session = ref.read(userSessionServiceProvider);
    final fullName = session.getuserFullName() ?? 'User';
    final email = session.getuserEmail() ?? 'User@mail.com';
    final phoneNumber = session.getuserPhoneNumber() ?? '9877654321';
    final profileImageUrl = session.getuserProfileImage();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: Text(
                    'Profile',
                    style: const TextStyle(
                      fontFamily: 'Inter Bold 24',
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const Divider(color: Colors.black, height: 2),
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
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                lightBlueColor,
                                lightBlueColor2,
                                lightPurpleColor,
                                lightPurpleColor2,
                                lightPurpleColor3,
                              ],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              stops: [0.0, 0.13, 0.5, 0.78, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: lightPurpleColor,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: profileImageUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  profileImageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Text(
                                fullName[0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 60,
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
                fullName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter bold 24',
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Phone', style: TextStyle(fontSize: 18)),
                    Text(phoneNumber,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87.withAlpha(200),
                            fontSize: 18)),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Email', style: TextStyle(fontSize: 18)),
                    Text(email,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87.withAlpha(200),
                            fontSize: 18)),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(color: Colors.black, height: 3),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ProfileActionButton(
                      icon: Icons.dark_mode_outlined,
                      label: 'Dark Mode',
                      onPressed: () {},
                    ),
                    //     Consumer(
                    //   builder: (context, ref, _) {
                    //     final isDark = ref.watch(themeModeProvider);
                    //     return ProfileActionButton(
                    //       icon: isDark
                    //           ? Icons.light_mode_outlined
                    //           : Icons.dark_mode_outlined,
                    //       label: 'Dark Mode',
                    //       onPressed: () =>
                    //           ref.read(themeModeProvider.notifier).toggle(),
                    //       trailing: Switch(
                    //         value: isDark,
                    //         activeThumbColor: lightPurpleColor3,
                    //         onChanged: (_) =>
                    //             ref.read(themeModeProvider.notifier).toggle(),
                    //       ),
                    //     );
                    //   },
                    // ),

                    const SizedBox(height: 10),
                    ProfileActionButton(
                      icon: Icons.person,
                      label: 'Edit Profile',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditProfileScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    ProfileActionButton(
                      icon: Icons.calendar_month_outlined,
                      label: 'Calendar',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CalendarScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Consumer(
                      builder: (context, ref, _) {
                        final isEnabled = ref.watch(proximityToggleProvider);
                        return ProfileActionButton(
                          icon: Icons.sensors,
                          label: 'Proximity Logout',
                          onPressed: () => ref
                              .read(proximityToggleProvider.notifier)
                              .toggle(),
                          trailing: Switch(
                            value: isEnabled,
                            activeThumbColor: lightPurpleColor3,
                            onChanged: (_) => ref
                                .read(proximityToggleProvider.notifier)
                                .toggle(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),

                    if (_biometricAvailable) ...[
                      ProfileActionButton(
                        icon: Icons.fingerprint,
                        label: 'Biometric Login',
                        onPressed: _toggleBiometric,
                        trailing: Switch(
                          value: _biometricEnabled,
                          activeThumbColor: lightPurpleColor3,
                          onChanged: (_) => _toggleBiometric(),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Debug: show even if unavailable so you can see it
                    if (!_biometricAvailable)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.fingerprint,
                                  color: Colors.orange.shade400),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Biometric not available on this device',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.orange),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ProfileActionButton(
                      icon: Icons.logout,
                      label: 'Logout',
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
