import 'package:hive/hive.dart';
import 'package:quickpalo/core/constants/hive_table_constants.dart';
import 'package:quickpalo/features/profile/domain/entities/profile_entity.dart';

part 'profile_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.profileTypeId)
class ProfileHiveModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final String? profilePicture;

  ProfileHiveModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profilePicture,
  });

  // From entity
  factory ProfileHiveModel.fromEntity(ProfileEntity entity) {
    return ProfileHiveModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      profilePicture: entity.profilePicture,
    );
  }

  // to entity list
  ProfileEntity toEntity() {
    return ProfileEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
    );
  }

  // to entity list
  static List<ProfileEntity> toEntityList(List<ProfileHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
