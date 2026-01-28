import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickpalo/app/theme/app_colors.dart';
import 'package:quickpalo/core/api/api_endpoints.dart';
import 'package:quickpalo/core/services/storage/token_service.dart';
import 'package:quickpalo/core/services/storage/user_session_service.dart';
import 'package:quickpalo/core/utils/snackbar_utils.dart';
import 'package:quickpalo/core/widgets/custom_button.dart';
import 'package:quickpalo/core/widgets/custom_label.dart';
import 'package:quickpalo/core/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickpalo/features/profile/presentation/state/profile_state.dart';
import 'package:quickpalo/features/profile/presentation/view_model/profile_viewmodel.dart';

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

  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;
  String? _uploadedImageFilename; // Store just the filename
  String? _currentProfileImageUrl; // Current image URL for display

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() {
    final session = ref.read(userSessionServiceProvider);

    final fullName = session.getuserFullName();
    final email = session.getuserEmail();
    final phoneNumber = session.getuserPhoneNumber();
    final profileImageUrl = session.getuserProfileImage();

    print('Loading user data:');
    print('Full Name: $fullName');
    print('Email: $email');
    print('Phone: $phoneNumber');
    print('Profile Image URL: $profileImageUrl');

    if (mounted) {
      setState(() {
        _fullNameController.text = fullName ?? '';
        _emailController.text = email ?? '';
        _phoneNumberController.text = phoneNumber ?? '';
        _currentProfileImageUrl = profileImageUrl;

        // Extract filename from URL
        if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
          final uri = Uri.tryParse(profileImageUrl);
          if (uri != null) {
            final pathSegments = uri.pathSegments;
            if (pathSegments.isNotEmpty) {
              _uploadedImageFilename = pathSegments.last;
              print('Extracted filename: $_uploadedImageFilename');
            }
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }

    return false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text(
            "Permission to access your camera or gallery is required. Please enable it from the setting of your device"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final hasPermission = await _requestPermission(Permission.camera);
    if (!hasPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _selectedImage = File(photo.path);
      });
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint('Gallery Error $e');
      if (mounted) {
        SnackbarUtils.showError(
          context,
          'Unable to access gallery. Please try using the camera instead.',
        );
      }
    }
  }

  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Open Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.browse_gallery),
                title: const Text('Open Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    if (!_formKey1.currentState!.validate()) {
      SnackbarUtils.showError(
          context, 'Please fill all required fields correctly');
      return;
    }

    final session = ref.read(userSessionServiceProvider);
    final userId = session.getuserId();
    final tokenService = ref.read(tokenServiceProvider);

    if (userId == null || userId.isEmpty) {
      SnackbarUtils.showError(context, 'User not found. Please login again.');
      return;
    }

    // Check token
    final token = await tokenService.getToken();
    print('Current token: $token');
    if (token == null || token.isEmpty) {
      SnackbarUtils.showError(context, 'Please login again. Token missing.');
      return;
    }

    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String? finalImageFilename = _uploadedImageFilename;

      // Upload image first if a new one is selected
      if (_selectedImage != null) {
        print('Uploading new image...');
        final uploadResult = await ref
            .read(profileViewModelProvider.notifier)
            .uploadPhoto(_selectedImage!);

        if (uploadResult != null) {
          print('Image uploaded successfully: $uploadResult');
          finalImageFilename = uploadResult;
        } else {
          SnackbarUtils.showError(context, 'Failed to upload image');
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      print('Updating profile with data:');
      print('ID: $userId');
      print('Full Name: ${_fullNameController.text.trim()}');
      print('Email: ${_emailController.text.trim()}');
      print('Phone: ${_phoneNumberController.text.trim()}');
      print('Profile Picture: $finalImageFilename');

      // Now update the profile with all data including the image filename
      final updateResult =
          await ref.read(profileViewModelProvider.notifier).updateProfile(
                id: userId,
                fullName: _fullNameController.text.trim(),
                email: _emailController.text.trim(),
                phoneNumber: _phoneNumberController.text.trim(),
                profilePicture: finalImageFilename, // Send only filename
              );

      if (updateResult == null || !updateResult) {
        throw Exception('Failed to update profile - no result from update');
      }

      print('Profile update successful');

      // Update local session
      final imageUrlForSession = finalImageFilename != null
          ? ApiEndpoints.imageUrl(finalImageFilename)
          : null;

      await session.saveUserSession(
        userId: userId,
        email: _emailController.text.trim(),
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        profileImage: finalImageFilename, // Store filename
      );

      print('Local session updated');

      if (mounted) {
        SnackbarUtils.showSuccess(context, 'Profile updated successfully!');
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('Update profile error: $e');
      if (mounted) {
        SnackbarUtils.showError(context, 'Failed to update profile: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: const Text("Edit Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile Image Section
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: _getProfileImage(),
                    child: _shouldShowInitials()
                        ? Text(
                            _getInitials(),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: lightPurpleColor3,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),

                // Change Profile Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: lightPurpleColor3,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: _isLoading ? null : _pickMedia,
                    child: const Text(
                      "Change Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Form Fields
                Form(
                  key: _formKey1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomLabel(text: "Full Name"),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _fullNameController,
                        hintText: "Enter your full name",
                        errortext: "Please enter a valid full name",
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        fieldType: FieldType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Full name is required';
                          }
                          if (value.length < 2) {
                            return 'Full name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      const CustomLabel(text: "Email"),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _emailController,
                        hintText: "Enter your email",
                        errortext: "Please enter a valid email",
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        fieldType: FieldType.email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      const CustomLabel(text: "Phone Number"),
                      const SizedBox(height: 8),
                      IntlPhoneField(
                        controller: _phoneNumberController,
                        initialCountryCode: 'NP',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: "9812345678",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        validator: (phone) {
                          if (phone == null || phone.number.isEmpty) {
                            return 'Phone number is required';
                          }
                          if (phone.number.length < 7) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          onPressed: _isLoading ? null : _updateProfile,
                          text: _isLoading ? "Saving..." : "Save Profile",
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Loading Overlay
          if (_isLoading || state.status == ProfileStatus.loading)
            Container(
              color: Colors.black.withAlpha(103),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    } else if (_currentProfileImageUrl != null &&
        _currentProfileImageUrl!.isNotEmpty) {
      return NetworkImage(_currentProfileImageUrl!);
    }
    return null;
  }

  bool _shouldShowInitials() {
    return _selectedImage == null &&
        (_currentProfileImageUrl == null || _currentProfileImageUrl!.isEmpty);
  }

  String _getInitials() {
    if (_fullNameController.text.isNotEmpty) {
      final names = _fullNameController.text.split(' ');
      if (names.length > 1) {
        return '${names[0][0]}${names[1][0]}'.toUpperCase();
      }
      return _fullNameController.text[0].toUpperCase();
    }
    return "U";
  }
}
