import 'package:quickpalo/features/auth/domain/entities/auth_entity.dart';

class AuthRegisterApiModel {
  final String? id;
  final String fullname;
  final String email;
  final String phoneNumber;
  final String? password;
  final String? confirmPassword;

  // final String? profilePicture;

  AuthRegisterApiModel(
      {this.id,
      required this.fullname,
      required this.email,
      required this.phoneNumber,
      this.password,
      this.confirmPassword});

  // ToJson
  Map<String, dynamic> toJson() {
    return {
      "fullname": fullname,
      "email": email,
      "phoneNumber": phoneNumber,
      "password": password,
      "confirmPassword": confirmPassword
      // "profilePicture": profilePicture,
    };
  }

  // from json
  factory AuthRegisterApiModel.fromJson(Map<String, dynamic> json) {
    return AuthRegisterApiModel(
      id: json['_id'] as String,
      fullname: json['fullname'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      password: json['password'] as String?,
      // profilePicture: json['profilePicture'] as String?,
    );
  }

  // to entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      email: email,
      phoneNumber: phoneNumber, fullName: fullname,
      // profilePicture: profilePicture,
    );
  }

  // from entity
  factory AuthRegisterApiModel.fromEntity(AuthEntity entity) {
    return AuthRegisterApiModel(
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      password: entity.password,
      fullname: entity.fullName,
      confirmPassword: entity.confirmPassword,
      // profilePicture: entity.profilePicture,
    );
  }
  // to entity list
  static List<AuthEntity> toEntityList(List<AuthRegisterApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
