import 'package:quickpalo/core/api/api_endpoints.dart';
import 'package:quickpalo/features/auth/domain/entities/auth_entity.dart';

class AuthRegisterApiModel {
  final String? id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? password;
  final String? confirmPassword;
  final String? profilePicture;

  AuthRegisterApiModel(
      {this.id,
      required this.fullName,
      required this.email,
      required this.phoneNumber,
      this.password,
      this.confirmPassword,
      this.profilePicture});

  // ToJson
  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "phoneNumber": phoneNumber,
      "password": password,
      "confirmPassword": confirmPassword,
      "profilePicture": profilePicture,
    };
  }

  // from json
  factory AuthRegisterApiModel.fromJson(Map<String, dynamic> json) {
    return AuthRegisterApiModel(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      password: json['password'] as String?,
      profilePicture: json['profilePicture'] != null
          ? ApiEndpoints.imageUrl(json['profilePicture'])
          : null,
    );
  }

  // to entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      email: email,
      phoneNumber: phoneNumber,
      fullName: fullName,
      profilePicture: profilePicture,
    );
  }

  // from entity
  factory AuthRegisterApiModel.fromEntity(AuthEntity entity) {
    return AuthRegisterApiModel(
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      password: entity.password,
      fullName: entity.fullName,
      confirmPassword: entity.confirmPassword,
      profilePicture: entity.profilePicture,
    );
  }
  // to entity list
  static List<AuthEntity> toEntityList(List<AuthRegisterApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
