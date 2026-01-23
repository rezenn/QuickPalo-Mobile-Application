import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice = false;
  static const String computerIpAddress = "192.168.101.3";

  static String get baseUrl {
    if (isPhysicalDevice) {
      return "http://$computerIpAddress:3000/api/v1";
    }
    if (kIsWeb) {
      return "http://localhost:3000/api/v1";
    } else if (Platform.isAndroid) {
      return "http://10.0.2.2:3000/api/v1";
    } else if (Platform.isIOS) {
      return "http://localhost:3000/api/v1";
    } else {
      return "http://10.0.2.2:3000/api/v1";
    }
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth
  static const String auth = '/auth';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static String userById(String id) => '/auth/$id';
}
