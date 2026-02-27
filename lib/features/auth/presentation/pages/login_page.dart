import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
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
import 'package:quickpalo/core/services/biometric/biometric_service.dart';
import 'package:quickpalo/core/services/biometric/biometric_preference_service.dart';

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
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  BiometricType? _biometricType;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final biometricService = ref.read(biometricServiceProvider);
    final prefService = ref.read(biometricPreferenceServiceProvider);

    final available = await biometricService.isAvailable();
    final enabled = await prefService.isEnabled();
    final type = await biometricService.getBiometricType();

    if (mounted) {
      setState(() {
        _biometricAvailable = available;
        _biometricEnabled = enabled;
        _biometricType = type;
      });

      // Auto-trigger biometric if previously enabled
      if (available && enabled) {
        _loginWithBiometrics();
      }
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    await ref.read(authViewModelProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

    // Offer to enable biometrics after successful login
    final state = ref.read(authViewModelProvider);
    if (state.status == AuthStatus.authenticated && _biometricAvailable) {
      final prefService = ref.read(biometricPreferenceServiceProvider);
      final alreadyEnabled = await prefService.isEnabled();
      if (!alreadyEnabled && mounted) {
        _offerBiometricSetup(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loginWithBiometrics() async {
    final biometricService = ref.read(biometricServiceProvider);
    final prefService = ref.read(biometricPreferenceServiceProvider);

    final authenticated = await biometricService.authenticate();
    if (!authenticated) return;

    final credentials = await prefService.getCredentials();
    if (credentials == null) {
      if (mounted) {
        SnackbarUtils.showError(
            context, 'No saved credentials. Please log in manually.');
      }
      return;
    }

    if (mounted) setState(() => _isLoading = true);

    await ref.read(authViewModelProvider.notifier).login(
          email: credentials.email,
          password: credentials.password,
        );

    if (mounted) setState(() => _isLoading = false);
  }

  void _offerBiometricSetup(String email, String password) {
    final typeLabel =
        _biometricType == BiometricType.face ? 'Face ID' : 'Fingerprint';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Enable $typeLabel?'),
        content: Text(
            'Would you like to use $typeLabel to log in faster next time?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Not now', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final prefService = ref.read(biometricPreferenceServiceProvider);
              await prefService.enable(email, password);
              if (mounted) {
                SnackbarUtils.showSuccess(context, '$typeLabel login enabled!');
              }
            },
            child: Text('Enable $typeLabel'),
          ),
        ],
      ),
    );
  }

  IconData get _biometricIcon {
    if (_biometricType == BiometricType.face) return Icons.face;
    return Icons.fingerprint;
  }

  String get _biometricLabel {
    if (_biometricType == BiometricType.face) return 'Face ID';
    return 'Fingerprint';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        SnackbarUtils.showSuccess(context, 'Login successful');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
          (route) => false,
        );
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          width: isTablet ? 250 : 200,
                          child: ClipRRect(
                            borderRadius: const BorderRadiusDirectional.only(
                              topEnd: Radius.circular(25),
                              bottomStart: Radius.circular(25),
                            ),
                            child:
                                Image.asset('assets/images/quickpalo_logo.png'),
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
                          key: _formKey,
                          child: Column(
                            children: [
                              const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontFamily: 'Inter Bold 24',
                                ),
                              ),
                              const SizedBox(height: 15),
                              CustomLabel(text: 'Email', fontSize: 16),
                              const SizedBox(height: 5),
                              CustomTextField(
                                controller: _emailController,
                                hintText: 'user@mail.com',
                                errortext: 'Please enter a valid email',
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                fieldType: FieldType.email,
                              ),
                              const SizedBox(height: 25),
                              CustomLabel(text: 'Password', fontSize: 16),
                              const SizedBox(height: 5),
                              CustomTextField(
                                controller: _passwordController,
                                hintText: '********',
                                errortext: 'Please enter a password',
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => setState(() =>
                                      _obscurePassword = !_obscurePassword),
                                ),
                                keyboardType: TextInputType.text,
                                fieldType: FieldType.password,
                              ),
                              const SizedBox(height: 15),
                              Align(
                                alignment: Alignment.centerRight,
                                child: CustomTextButton(
                                  text: 'Forgot Password?',
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const ForgotPasswordScreen()),
                                  ),
                                ),
                              ),
                              CustomButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                text: 'Login',
                              ),

                              // ── Biometric button ─────────────────────────
                              if (_biometricAvailable && _biometricEnabled) ...[
                                const SizedBox(height: 12),
                                OutlinedButton.icon(
                                  onPressed:
                                      _isLoading ? null : _loginWithBiometrics,
                                  icon: Icon(_biometricIcon,
                                      color: lightPurpleColor3),
                                  label: Text(
                                    'Login with $_biometricLabel',
                                    style: TextStyle(color: lightPurpleColor3),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 48),
                                    side: BorderSide(color: lightPurpleColor3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],

                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Don't have an account?",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: textColorGrey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  CustomTextButton(
                                    text: 'Sign Up',
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const RegisterScreen()),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Expanded(
                                      child: Divider(
                                          color: Colors.grey, thickness: 1)),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text('OR'),
                                  ),
                                  Expanded(
                                      child: Divider(
                                          color: Colors.grey, thickness: 1)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              CustomButton2(
                                onPressed: () {},
                                text: 'Continue with Google',
                                imagePath: 'assets/images/google.png',
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
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
