import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';

class OrganizationApiModel {
  final String? id;
  final String? userId;
  final String organizationName;
  final String organizationType;
  final String? description;
  final String street;
  final String city;
  final String? state;
  final String? contactEmail;
  final String? contactPhone;
  final List<WorkingHourEntity> workingHours;
  final List<DepartmentEntity> departments;
  final int fees;
  final int appointmentDuration;
  final int advanceBookingDays;
  final List<TimeSlotEntity> timeSlots;
  final bool isActive;
  final bool isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserEntity? user;

  OrganizationApiModel({
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

  factory OrganizationApiModel.fromJson(Map<String, dynamic> json) {
    List<WorkingHourEntity> workingHours = [];
    if (json.containsKey('workingHours') && json['workingHours'] != null) {
      try {
        final workingHoursList = json['workingHours'];
        if (workingHoursList is List) {
          workingHours = workingHoursList
              .where((item) => item is Map<String, dynamic>)
              .map((item) =>
                  WorkingHourEntity.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      } catch (e) {
        throw Exception('Failed to fetch working hours: $e');
      }
    }

    List<DepartmentEntity> departments = [];
    if (json.containsKey('departments') && json['departments'] != null) {
      try {
        final departmentsList = json['departments'];
        if (departmentsList is List) {
          departments = departmentsList
              .where((item) => item is Map<String, dynamic>)
              .map((item) =>
                  DepartmentEntity.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      } catch (e) {
        throw Exception('Failed to fetch department: $e');
      }
    }

    List<TimeSlotEntity> timeSlots = [];
    if (json.containsKey('timeSlots') && json['timeSlots'] != null) {
      try {
        final timeSlotsList = json['timeSlots'];
        if (timeSlotsList is List) {
          timeSlots = timeSlotsList
              .where((item) => item is Map<String, dynamic>)
              .map((item) =>
                  TimeSlotEntity.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      } catch (e) {
        throw Exception('Failed to fetch timeslots: $e');
      }
    }

    UserEntity? user;
    if (json.containsKey('user') && json['user'] != null) {
      try {
        final userData = json['user'];
        if (userData is Map<String, dynamic>) {
          user = UserEntity.fromJson(userData);
        }
      } catch (e) {
        throw Exception('Failed to fetch users: $e');
      }
    }

    DateTime? createdAt;
    if (json.containsKey('createdAt') && json['createdAt'] != null) {
      try {
        createdAt = DateTime.parse(json['createdAt'].toString());
      } catch (e) {
        throw Exception('Failed to fetch created at: $e');
      }
    }

    DateTime? updatedAt;
    if (json.containsKey('updatedAt') && json['updatedAt'] != null) {
      try {
        updatedAt = DateTime.parse(json['updatedAt'].toString());
      } catch (e) {
        throw Exception('Failed to fetch updated at: $e');
      }
    }

    String? userId;
    if (json.containsKey('userId') && json['userId'] != null) {
      try {
        final userIdData = json['userId'];
        if (userIdData is Map) {
          userId = userIdData['_id']?.toString();
        } else {
          userId = userIdData.toString();
        }
      } catch (e) {
        throw Exception('Failed to fetch userId: $e');
      }
    }

    int fees = 1;
    if (json.containsKey('fees') && json['fees'] != null) {
      try {
        final feesValue = json['fees'];
        if (feesValue is int) {
          fees = feesValue;
        } else if (feesValue is double) {
          fees = feesValue.toInt();
        } else if (feesValue is String) {
          fees = int.tryParse(feesValue) ?? 1;
        } else {
          fees = int.tryParse(feesValue.toString()) ?? 1;
        }
      } catch (e) {
        throw Exception('Failed to parse fees in fromJson: $e');
      }
    }
    int appointmentDuration = 30;
    if (json.containsKey('appointmentDuration') &&
        json['appointmentDuration'] != null) {
      try {
        appointmentDuration = json['appointmentDuration'] is int
            ? json['appointmentDuration']
            : int.tryParse(json['appointmentDuration'].toString()) ?? 30;
      } catch (e) {
        throw Exception('Failed to fetch appointemnt duration: $e');
      }
    }

    int advanceBookingDays = 7;
    if (json.containsKey('advanceBookingDays') &&
        json['advanceBookingDays'] != null) {
      try {
        advanceBookingDays = json['advanceBookingDays'] is int
            ? json['advanceBookingDays']
            : int.tryParse(json['advanceBookingDays'].toString()) ?? 7;
      } catch (e) {
        throw Exception('Failed to fetch appointment booking: $e');
      }
    }

    bool isActive = true;
    if (json.containsKey('isActive') && json['isActive'] != null) {
      try {
        isActive = json['isActive'] is bool
            ? json['isActive']
            : json['isActive'].toString().toLowerCase() == 'true';
      } catch (e) {
        throw Exception('Failed to fetch isActive: $e');
      }
    }

    bool isVerified = false;
    if (json.containsKey('isVerified') && json['isVerified'] != null) {
      try {
        isVerified = json['isVerified'] is bool
            ? json['isVerified']
            : json['isVerified'].toString().toLowerCase() == 'true';
      } catch (e) {
        throw Exception('Failed to fetch isVerified: $e');
      }
    }

    return OrganizationApiModel(
      id: json.containsKey('_id') ? json['_id']?.toString() : null,
      userId: userId,
      organizationName: json.containsKey('organizationName')
          ? json['organizationName']?.toString() ?? ''
          : '',
      organizationType: json.containsKey('organizationType')
          ? json['organizationType']?.toString() ?? 'others'
          : 'others',
      description: json.containsKey('description')
          ? json['description']?.toString()
          : null,
      street:
          json.containsKey('street') ? json['street']?.toString() ?? '' : '',
      city: json.containsKey('city') ? json['city']?.toString() ?? '' : '',
      state: json.containsKey('state') ? json['state']?.toString() : null,
      contactEmail: json.containsKey('contactEmail')
          ? json['contactEmail']?.toString()
          : null,
      contactPhone: json.containsKey('contactPhone')
          ? json['contactPhone']?.toString()
          : null,
      workingHours: workingHours,
      departments: departments,
      fees: fees,
      appointmentDuration: appointmentDuration,
      advanceBookingDays: advanceBookingDays,
      timeSlots: timeSlots,
      isActive: isActive,
      isVerified: isVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
      user: user,
    );
  }

  OrganizationEntity toEntity() {
    return OrganizationEntity(
      id: id,
      userId: userId,
      organizationName: organizationName,
      organizationType: _parseOrganizationType(organizationType),
      description: description,
      street: street,
      city: city,
      state: state,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      workingHours: workingHours,
      departments: departments,
      fees: fees,
      appointmentDuration: appointmentDuration,
      advanceBookingDays: advanceBookingDays,
      timeSlots: timeSlots,
      isActive: isActive,
      isVerified: isVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
      user: user,
    );
  }

  OrganizationType _parseOrganizationType(String type) {
    switch (type.toLowerCase()) {
      case 'hospital':
        return OrganizationType.hospital;
      case 'clinic':
        return OrganizationType.clinic;
      case 'government_office':
        return OrganizationType.governmentOffice;
      case 'service_center':
        return OrganizationType.serviceCenter;
      case 'bank':
        return OrganizationType.bank;
      case 'school':
        return OrganizationType.school;
      case 'college':
        return OrganizationType.college;
      case 'university':
        return OrganizationType.university;
      default:
        return OrganizationType.others;
    }
  }

  static List<OrganizationEntity> toEntityList(
      List<OrganizationApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
