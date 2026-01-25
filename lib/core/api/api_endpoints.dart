import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // MUST be true for physical device
  static const bool isPhysicalDevice = true;

  static const String computerIpAddress = "192.168.101.6";

  static const int port = 5050;

  static String get baseUrl {
    if (isPhysicalDevice) {
      return "http://$computerIpAddress:$port/api";
    }

    if (kIsWeb) {
      return "http://localhost:$port/api";
    }

    if (Platform.isAndroid) {
      return "http://10.0.2.2:$port/api";
    }

    if (Platform.isIOS) {
      return "http://localhost:$port/api";
    }

    return "http://localhost:$port/api";
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static String userById(String id) => '/auth/$id';

  // Profile
  static const String profiles = '/profiles';
  static String profileById(String id) => '/profiles/$id';
  static const String profileUploadPhoto = '/profiles/upload-photo';
}
