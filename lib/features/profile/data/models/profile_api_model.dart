import 'package:quickpalo/features/profile/domain/entities/profile_entity.dart';

class ProfileApiModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? profilePicture;

  const ProfileApiModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profilePicture,
  });

  // from json
  factory ProfileApiModel.fromJson(Map<String, dynamic> json) {
    return ProfileApiModel(
      id: json['_id'] as String,
      fullName: json['fullname'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      profilePicture: json['profilePicture'] as String?,
    );
  }

  // to json (for update profile)
  Map<String, dynamic> toJson() {
    return {
      "fullname": fullName,
      "email": email,
      "phoneNumber": phoneNumber,
      "profilePicture": profilePicture,
    };
  }

  // to entity
  ProfileEntity toEntity() {
    return ProfileEntity(
      userId: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
    );
  }

  // from entity (for update requests)
  factory ProfileApiModel.fromEntity(ProfileEntity entity) {
    return ProfileApiModel(
      id: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      profilePicture: entity.profilePicture,
    );
  }

  // to entity list
  static List<ProfileEntity> toEntityList(List<ProfileApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
