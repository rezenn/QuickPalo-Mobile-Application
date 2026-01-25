import 'package:quickpalo/features/auth/domain/entities/auth_entity.dart';

class AuthLoginApiModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final String role;
  final String token;

  AuthLoginApiModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.role,
    required this.token,
  });

  factory AuthLoginApiModel.fromJson(Map<String, dynamic> json, String token) {
    return AuthLoginApiModel(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
      token: token,
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );
  }
}
