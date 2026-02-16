import 'package:hive/hive.dart';
import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';

part 'organization_hive_model.g.dart';

@HiveType(typeId: 1)
class OrganizationHiveModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? userId;
  @HiveField(2)
  final String organizationName;
  @HiveField(3)
  final String organizationType;
  @HiveField(4)
  final String? description;
  @HiveField(5)
  final String street;
  @HiveField(6)
  final String city;
  @HiveField(7)
  final String? state;
  @HiveField(8)
  final String? contactEmail;
  @HiveField(9)
  final String? contactPhone;
  @HiveField(10)
  final List<Map<String, dynamic>> workingHours;
  @HiveField(11)
  final List<Map<String, dynamic>> departments;
  @HiveField(12)
  final int fees;
  @HiveField(13)
  final int appointmentDuration;
  @HiveField(14)
  final int advanceBookingDays;
  @HiveField(15)
  final List<Map<String, dynamic>> timeSlots;
  @HiveField(16)
  final bool isActive;
  @HiveField(17)
  final bool isVerified;
  @HiveField(18)
  final String? createdAt;
  @HiveField(19)
  final String? updatedAt;
  @HiveField(20)
  final Map<String, dynamic>? user;

  OrganizationHiveModel({
    this.id,
    this.userId,
    required this.organizationName,
    required this.organizationType,
    this.description,
    required this.street,
    required this.city,
    this.state,
    this.contactEmail,
    this.contactPhone,
    required this.workingHours,
    required this.departments,
    required this.fees,
    required this.appointmentDuration,
    required this.advanceBookingDays,
    required this.timeSlots,
    required this.isActive,
    required this.isVerified,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory OrganizationHiveModel.fromEntity(OrganizationEntity entity) {
    return OrganizationHiveModel(
      id: entity.id,
      userId: entity.userId,
      organizationName: entity.organizationName,
      organizationType: entity.organizationType.toString().split('.').last,
      description: entity.description,
      street: entity.street,
      city: entity.city,
      state: entity.state,
      contactEmail: entity.contactEmail,
      contactPhone: entity.contactPhone,
      workingHours: entity.workingHours.map((e) => e.toJson()).toList(),
      departments: entity.departments.map((e) => e.toJson()).toList(),
      fees: entity.fees,
      appointmentDuration: entity.appointmentDuration,
      advanceBookingDays: entity.advanceBookingDays,
      timeSlots: entity.timeSlots.map((e) => e.toJson()).toList(),
      isActive: entity.isActive,
      isVerified: entity.isVerified,
      createdAt: entity.createdAt?.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
      user: entity.user?.toJson(),
    );
  }

  OrganizationEntity toEntity() {
    return OrganizationEntity.fromJson({
      '_id': id,
      'userId': userId,
      'organizationName': organizationName,
      'organizationType': organizationType,
      'description': description,
      'street': street,
      'city': city,
      'state': state,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'workingHours': workingHours,
      'departments': departments,
      'fees': fees,
      'appointmentDuration': appointmentDuration,
      'advanceBookingDays': advanceBookingDays,
      'timeSlots': timeSlots,
      'isActive': isActive,
      'isVerified': isVerified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'user': user,
    });
  }

  static List<OrganizationEntity> toEntityList(
      List<OrganizationHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
