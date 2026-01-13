class ApiEndpoints {
  ApiEndpoints._();

  // Base URL
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ================== Auth Endpoints ==============
  static const String auth = '/auth';
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static String userById(String id) => 'auth/$id';
  static String userPhoto(String id) => 'auth/$id/photo';
}
