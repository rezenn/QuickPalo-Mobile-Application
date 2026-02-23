import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // MUST be true for physical device
  static const bool isPhysicalDevice = true;

  static const String computerIpAddress = "192.168.101.12";

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

  static String imageUrl(String fileName) {
    if (fileName.startsWith('http')) return fileName;

    if (isPhysicalDevice) {
      return "http://$computerIpAddress:$port/uploads/profile/$fileName";
    }

    if (kIsWeb) {
      return "http://localhost:$port/uploads/profile/$fileName";
    }

    if (Platform.isAndroid) {
      return "http://10.0.2.2:$port/uploads/profile/$fileName";
    }

    if (Platform.isIOS) {
      return "http://localhost:$port/uploads/profile/$fileName";
    }

    return "http://localhost:$port/uploads/profile/$fileName";
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
  static const String profileUploadPhoto = '/auth/update-user';
  static const String currentUser = '/auth/get-user';

  // static String imageUrl(String fileName) {
  //   return "http://$computerIpAddress:$port/uploads/profile/$fileName";
  // }

  // Organization Endpoints
  static const String organizations = '/organizations';
  static const String organizationDetails = '/organizations/details';
  static String organizationById(String id) => '/organizations/$id';

  // message
  static const String streamToken = '/message/stream-token';
  static const String sendMessageToOrg = '/message/send-to-org';
  static const String getMessages = '/message/get-messages';
}
