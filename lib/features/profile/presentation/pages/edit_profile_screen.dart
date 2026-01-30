// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:quickpalo/app/theme/app_colors.dart';
// import 'package:quickpalo/core/services/storage/user_session_service.dart';
// import 'package:quickpalo/core/utils/snackbar_utils.dart';
// import 'package:quickpalo/core/widgets/custom_button.dart';
// import 'package:quickpalo/core/widgets/custom_label.dart';
// import 'package:quickpalo/core/widgets/custom_text_field.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:quickpalo/features/profile/presentation/state/profile_state.dart';
// import 'package:quickpalo/features/profile/presentation/view_model/profile_viewmodel.dart';

// class EditProfileScreen extends ConsumerStatefulWidget {
//   const EditProfileScreen({super.key});

//   @override
//   ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneNumberController = TextEditingController();
//   final _formKey1 = GlobalKey<FormState>();

//   File? _selectedImage;
//   final ImagePicker _imagePicker = ImagePicker();
//   bool _isLoading = false;
//   bool _isUploadingImage = false;
//   String? _uploadedImageUrl;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadUserData();
//     });
//   }

//   void _loadUserData() {
//     final session = ref.read(userSessionServiceProvider);

//     final fullName = session.getuserFullName();
//     final email = session.getuserEmail();
//     final phoneNumber = session.getuserPhoneNumber();
//     final profileImageUrl = session.getuserProfileImage();

//     if (mounted) {
//       setState(() {
//         _fullNameController.text = fullName ?? '';
//         _emailController.text = email ?? '';
//         _phoneNumberController.text = phoneNumber ?? '';
//         _uploadedImageUrl = profileImageUrl;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _phoneNumberController.dispose();
//     super.dispose();
//   }

//   Future<bool> _requestPermission(Permission permission) async {
//     final status = await permission.status;
//     if (status.isGranted) return true;

//     if (status.isDenied) {
//       final result = await permission.request();
//       return result.isGranted;
//     }

//     if (status.isPermanentlyDenied) {
//       _showPermissionDeniedDialog();
//       return false;
//     }

//     return false;
//   }

//   void _showPermissionDeniedDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Permission Required"),
//         content: const Text(
//             "Permission to access your camera or gallery is required. Please enable it from the setting of your device"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               openAppSettings();
//             },
//             child: const Text('Open Settings'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _pickFromCamera() async {
//     final hasPermission = await _requestPermission(Permission.camera);
//     if (!hasPermission) return;

//     final XFile? photo = await _imagePicker.pickImage(
//       source: ImageSource.camera,
//       imageQuality: 80,
//     );

//     if (photo != null) {
//       _uploadPhoto(File(photo.path));
//     }
//   }

//   Future<void> _pickFromGallery() async {
//     try {
//       final XFile? image = await _imagePicker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//       );

//       if (image != null) {
//         _uploadPhoto(File(image.path));
//       }
//     } catch (e) {
//       debugPrint('Gallery Error $e');
//       if (mounted) {
//         SnackbarUtils.showError(
//           context,
//           'Unable to access gallery. Please try using the camera instead.',
//         );
//       }
//     }
//   }

//   Future<void> _uploadPhoto(File photo) async {
//     if (!mounted) return;

//     setState(() {
//       _selectedImage = photo;
//       _isUploadingImage = true;
//     });

//     try {
//       final result =
//           await ref.read(profileViewModelProvider.notifier).uploadPhoto(photo);

//       if (result != null && mounted) {
//         setState(() {
//           _uploadedImageUrl = result;
//         });
//         SnackbarUtils.showSuccess(
//             context, 'Profile photo updated successfully!');
//       } else if (mounted) {
//         SnackbarUtils.showError(context, 'Failed to upload photo');
//       }
//     } catch (e) {
//       if (mounted) {
//         SnackbarUtils.showError(context, 'Error uploading photo: $e');
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isUploadingImage = false;
//         });
//       }
//     }
//   }

//   Future<void> _pickMedia() async {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera),
//                 title: const Text('Open Camera'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickFromCamera();
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.browse_gallery),
//                 title: const Text('Open Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickFromGallery();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _updateProfile() async {
//     if (!_formKey1.currentState!.validate()) {
//       SnackbarUtils.showError(
//           context, 'Please fill all required fields correctly');
//       return;
//     }

//     final session = ref.read(userSessionServiceProvider);
//     final userId = session.getuserId();

//     if (userId == null || userId.isEmpty) {
//       SnackbarUtils.showError(context, 'User not found. Please login again.');
//       return;
//     }

//     if (!mounted) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await ref.read(profileViewModelProvider.notifier).updateProfile(
//             id: userId,
//             fullName: _fullNameController.text.trim(),
//             email: _emailController.text.trim(),
//             phoneNumber: _phoneNumberController.text.trim(),
//             profilePicture: _uploadedImageUrl,
//           );

//       // Update local session
//       await session.saveUserSession(
//         userId: userId,
//         email: _emailController.text.trim(),
//         fullName: _fullNameController.text.trim(),
//         phoneNumber: _phoneNumberController.text.trim(),
//         profileImage: _uploadedImageUrl,
//       );

//       if (mounted) {
//         SnackbarUtils.showSuccess(context, 'Profile updated successfully!');
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted) {
//         SnackbarUtils.showError(context, 'Failed to update profile: $e');
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(profileViewModelProvider);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white70,
//         title: const Text("Edit Profile"),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         bottom: const PreferredSize(
//           preferredSize: Size.fromHeight(1.0),
//           child: Divider(
//             color: Colors.black,
//             height: 1.0,
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 // Profile Image Section
//                 Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: Colors.black87,
//                       width: 2,
//                     ),
//                   ),
//                   child: Stack(
//                     children: [
//                       CircleAvatar(
//                         radius: 60,
//                         backgroundColor: Colors.white,
//                         backgroundImage: _selectedImage != null
//                             ? FileImage(_selectedImage!)
//                             : (_uploadedImageUrl != null &&
//                                     _uploadedImageUrl!.isNotEmpty
//                                 ? NetworkImage(_uploadedImageUrl!)
//                                 : null) as ImageProvider?,
//                         child: _selectedImage == null &&
//                                 (_uploadedImageUrl == null ||
//                                     _uploadedImageUrl!.isEmpty)
//                             ? Text(
//                                 _fullNameController.text.isNotEmpty
//                                     ? _fullNameController.text[0].toUpperCase()
//                                     : "U",
//                                 style: const TextStyle(
//                                   fontSize: 48,
//                                   fontWeight: FontWeight.bold,
//                                   color: lightPurpleColor3,
//                                 ),
//                               )
//                             : null,
//                       ),
//                       if (_isUploadingImage)
//                         Positioned.fill(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.black54,
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Center(
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // Change Profile Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       backgroundColor: lightPurpleColor3,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                     ),
//                     onPressed: _isLoading ? null : _pickMedia,
//                     child: const Text(
//                       "Change Profile",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 // Form Fields
//                 Form(
//                   key: _formKey1,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const CustomLabel(text: "Full Name"),
//                       const SizedBox(height: 8),
//                       CustomTextField(
//                         controller: _fullNameController,
//                         hintText: "Enter your full name",
//                         errortext: "Please enter a valid full name",
//                         keyboardType: TextInputType.text,
//                         obscureText: false,
//                         fieldType: FieldType.text,
//                       ),
//                       const SizedBox(height: 20),

//                       const CustomLabel(text: "Phone Number"),
//                       const SizedBox(height: 8),
//                       CustomTextField(
//                         controller: _phoneNumberController,
//                         hintText: "Enter your phone number",
//                         errortext: "Please enter a valid phone number",
//                         keyboardType: TextInputType.number,
//                         obscureText: false,
//                         fieldType: FieldType.text,
//                       ),
//                       const SizedBox(height: 20),

//                       const CustomLabel(text: "Phone Number"),
//                       const SizedBox(height: 8),
//                       CustomTextField(
//                         controller: _emailController,
//                         hintText: "Enter your email",
//                         errortext: "Please enter a valid email",
//                         keyboardType: TextInputType.emailAddress,
//                         obscureText: false,
//                         fieldType: FieldType.email,
//                       ),

//                       const SizedBox(height: 40),

//                       // Save Button
//                       SizedBox(
//                         width: double.infinity,
//                         child: CustomButton(
//                           onPressed: _isLoading ? null : _updateProfile,
//                           text: _isLoading ? "Saving..." : "Save Profile",
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Loading Overlay
//           if (_isLoading || state.status == ProfileStatus.loading)
//             Container(
//               color: Colors.black.withAlpha(103),
//               child: const Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickpalo/app/theme/app_colors.dart';
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
  bool _isUploadingImage = false;
  String? _uploadedImageUrl;

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

    if (mounted) {
      setState(() {
        _fullNameController.text = fullName ?? '';
        _emailController.text = email ?? '';
        _phoneNumberController.text = phoneNumber ?? '';
        _uploadedImageUrl = profileImageUrl;
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
      _uploadPhoto(File(photo.path));
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        _uploadPhoto(File(image.path));
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

  Future<void> _uploadPhoto(File photo) async {
    if (!mounted) return;

    setState(() {
      _selectedImage = photo;
      _isUploadingImage = true;
    });

    try {
      final result =
          await ref.read(profileViewModelProvider.notifier).uploadPhoto(photo);

      if (result != null && mounted) {
        setState(() {
          _uploadedImageUrl = result;
        });
        SnackbarUtils.showSuccess(
            context, 'Profile photo updated successfully!');
      } else if (mounted) {
        SnackbarUtils.showError(context, 'Failed to upload photo');
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showError(context, 'Error uploading photo: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
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
              const Text(
                'Choose Photo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: lightPurpleColor3.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt,
                      color: lightPurpleColor3, size: 24),
                ),
                title: const Text(
                  'Take Photo',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                subtitle: const Text('Use your camera to take a new photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: lightPurpleColor3.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library,
                      color: lightPurpleColor3, size: 24),
                ),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                subtitle: const Text('Select a photo from your gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
              const SizedBox(height: 10),
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

    if (userId == null || userId.isEmpty) {
      SnackbarUtils.showError(context, 'User not found. Please login again.');
      return;
    }

    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(profileViewModelProvider.notifier).updateProfile(
            id: userId,
            fullName: _fullNameController.text.trim(),
            phoneNumber: _phoneNumberController.text.trim(),
            profilePicture: _uploadedImageUrl,
            email: _emailController.text.trim(),
          );

      // Update local session - keep existing email
      await session.saveUserSession(
        userId: userId,
        email: _emailController.text.trim(),
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        profileImage: _uploadedImageUrl,
      );

      if (mounted) {
        SnackbarUtils.showSuccess(context, 'Profile updated successfully!');
        Navigator.pop(context);
      }
    } catch (e) {
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.black87, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    "Update your personal information",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Profile Image Section
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: lightPurpleColor3.withAlpha(70),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: lightPurpleColor3.withAlpha(30),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 64,
                                backgroundColor: Colors.white,
                                backgroundImage: _selectedImage != null
                                    ? FileImage(_selectedImage!)
                                    : (_uploadedImageUrl != null &&
                                            _uploadedImageUrl!.isNotEmpty
                                        ? NetworkImage(_uploadedImageUrl!)
                                        : null) as ImageProvider?,
                                child: _selectedImage == null &&
                                        (_uploadedImageUrl == null ||
                                            _uploadedImageUrl!.isEmpty)
                                    ? Text(
                                        _fullNameController.text.isNotEmpty
                                            ? _fullNameController.text[0]
                                                .toUpperCase()
                                            : "U",
                                        style: const TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.w700,
                                          color: lightPurpleColor3,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                            if (_isUploadingImage)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _isLoading ? null : _pickMedia,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: lightPurpleColor3,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(30),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _isLoading ? null : _pickMedia,
                          style: TextButton.styleFrom(
                            foregroundColor: lightPurpleColor3,
                          ),
                          child: const Text(
                            "Change Profile Photo",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  const Divider(height: 1),

                  const SizedBox(height: 30),

                  // Form Section Header
                  const Text(
                    "Personal Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Update your contact details",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 25),

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
                        ),
                        const SizedBox(height: 20),
                        const CustomLabel(text: "Email Address"),
                        const SizedBox(height: 8),
                        // Disabled Email Field
                        AbsorbPointer(
                          absorbing: true, // Disables all interactions
                          child: CustomTextField(
                            controller: _emailController,
                            hintText: "Enter your email address",
                            errortext: "Please enter a valid email",
                            keyboardType: TextInputType.emailAddress,
                            textColor: Colors.grey.shade600,
                            fillColor: Colors.grey.shade200,
                            obscureText: false,
                            fieldType: FieldType.email,
                            enabled: false,
                            // Disables the field
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: lightPurpleColor2,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Email cannot be changed",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: lightPurpleColor3,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        const CustomLabel(text: "Phone Number"),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: _phoneNumberController,
                          hintText: "Enter your phone number",
                          errortext: "Please enter a valid phone number",
                          keyboardType: TextInputType.phone,
                          obscureText: false,
                          fieldType: FieldType.text,
                        ),

                        const SizedBox(height: 50),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomButton(
                                onPressed: _isLoading ? null : _updateProfile,
                                text: _isLoading ? "Saving..." : "Save Changes",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading Overlay
          if (_isLoading || state.status == ProfileStatus.loading)
            Container(
              color: Colors.black.withAlpha(155),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(30),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: lightPurpleColor3,
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isUploadingImage
                            ? 'Uploading Photo...'
                            : 'Saving Changes...',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
