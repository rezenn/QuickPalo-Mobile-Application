import 'package:equatable/equatable.dart';

enum OrganizationType {
  hospital,
  clinic,
  governmentOffice,
  serviceCenter,
  bank,
  school,
  college,
  university,
  others,
}

class DepartmentEntity extends Equatable {
  final String name;
  final String? description;

  const DepartmentEntity({
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [name, description];

  factory DepartmentEntity.fromJson(Map<String, dynamic> json) {
    return DepartmentEntity(
      name: json['name'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
    };
  }
}

class TimeSlotEntity extends Equatable {
  final String startTime;
  final String endTime;
  final bool isAvailable;

  const TimeSlotEntity({
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [startTime, endTime, isAvailable];

  factory TimeSlotEntity.fromJson(Map<String, dynamic> json) {
    return TimeSlotEntity(
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'isAvailable': isAvailable,
    };
  }
}

class WorkingHourEntity extends Equatable {
  final String day;
  final String openingTime;
  final String closingTime;
  final bool isWorking;

  const WorkingHourEntity({
    required this.day,
    required this.openingTime,
    required this.closingTime,
    this.isWorking = true,
  });

  @override
  List<Object?> get props => [day, openingTime, closingTime, isWorking];

  factory WorkingHourEntity.fromJson(Map<String, dynamic> json) {
    return WorkingHourEntity(
      day: json['day'] ?? '',
      openingTime: json['openingTime'] ?? '',
      closingTime: json['closingTime'] ?? '',
      isWorking: json['isWorking'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'isWorking': isWorking,
    };
  }
}

class UserEntity extends Equatable {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? profilePicture;
  final String? role;

  const UserEntity({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.profilePicture,
    this.role,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phoneNumber,
        profilePicture,
        role,
      ];

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (profilePicture != null) 'profilePicture': profilePicture,
      if (role != null) 'role': role,
    };
  }
}

class OrganizationEntity extends Equatable {
  final String? id;
  final String? userId;
  final String organizationName;
  final OrganizationType organizationType;
  final String? description;
  final String street;
  final String city;
  final String? state;
  final String? contactEmail;
  final String? contactPhone;
  final List<WorkingHourEntity> workingHours;
  final List<DepartmentEntity> departments;
  final int appointmentDuration;
  final int advanceBookingDays;
  final List<TimeSlotEntity> timeSlots;
  final bool isActive;
  final bool isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserEntity? user;

  const OrganizationEntity({
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
    this.appointmentDuration = 30,
    this.advanceBookingDays = 7,
    required this.timeSlots,
    this.isActive = true,
    this.isVerified = false,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        organizationName,
        organizationType,
        description,
        street,
        city,
        state,
        contactEmail,
        contactPhone,
        workingHours,
        departments,
        appointmentDuration,
        advanceBookingDays,
        timeSlots,
        isActive,
        isVerified,
        createdAt,
        updatedAt,
        user,
      ];

  factory OrganizationEntity.fromJson(Map<String, dynamic> json) {
    OrganizationType parseOrganizationType(String type) {
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

    List<WorkingHourEntity> workingHours = [];
    if (json['workingHours'] is List) {
      workingHours = (json['workingHours'] as List)
          .map((item) => WorkingHourEntity.fromJson(item))
          .toList();
    }

    List<DepartmentEntity> departments = [];
    if (json['departments'] is List) {
      departments = (json['departments'] as List)
          .map((item) => DepartmentEntity.fromJson(item))
          .toList();
    }

    List<TimeSlotEntity> timeSlots = [];
    if (json['timeSlots'] is List) {
      timeSlots = (json['timeSlots'] as List)
          .map((item) => TimeSlotEntity.fromJson(item))
          .toList();
    }

    UserEntity? user;
    if (json['user'] != null && json['user'] is Map<String, dynamic>) {
      user = UserEntity.fromJson(json['user']);
    }

    DateTime? parseDate(dynamic date) {
      if (date == null) return null;
      if (date is DateTime) return date;
      if (date is String) return DateTime.tryParse(date);
      return null;
    }

    return OrganizationEntity(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      userId: json['userId']?.toString(),
      organizationName: json['organizationName'] ?? '',
      organizationType:
          parseOrganizationType(json['organizationType'] ?? 'others'),
      description: json['description'],
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'],
      contactEmail: json['contactEmail'],
      contactPhone: json['contactPhone'],
      workingHours: workingHours,
      departments: departments,
      appointmentDuration: json['appointmentDuration'] ?? 30,
      advanceBookingDays: json['advanceBookingDays'] ?? 7,
      timeSlots: timeSlots,
      isActive: json['isActive'] ?? true,
      isVerified: json['isVerified'] ?? false,
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      user: user,
    );
  }

  //entity to JSON
  Map<String, dynamic> toJson() {
    //organization type to string
    String organizationTypeToString(OrganizationType type) {
      switch (type) {
        case OrganizationType.hospital:
          return 'hospital';
        case OrganizationType.clinic:
          return 'clinic';
        case OrganizationType.governmentOffice:
          return 'government_office';
        case OrganizationType.serviceCenter:
          return 'service_center';
        case OrganizationType.bank:
          return 'bank';
        case OrganizationType.school:
          return 'school';
        case OrganizationType.college:
          return 'college';
        case OrganizationType.university:
          return 'university';
        case OrganizationType.others:
          return 'others';
      }
    }

    return {
      if (id != null) '_id': id,
      if (userId != null) 'userId': userId,
      'organizationName': organizationName,
      'organizationType': organizationTypeToString(organizationType),
      if (description != null) 'description': description,
      'street': street,
      'city': city,
      if (state != null) 'state': state,
      if (contactEmail != null) 'contactEmail': contactEmail,
      if (contactPhone != null) 'contactPhone': contactPhone,
      'workingHours': workingHours.map((hour) => hour.toJson()).toList(),
      'departments': departments.map((dept) => dept.toJson()).toList(),
      'appointmentDuration': appointmentDuration,
      'advanceBookingDays': advanceBookingDays,
      'timeSlots': timeSlots.map((slot) => slot.toJson()).toList(),
      'isActive': isActive,
      'isVerified': isVerified,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (user != null) 'user': user!.toJson(),
    };
  }

  OrganizationEntity copyWith({
    String? id,
    String? userId,
    String? organizationName,
    OrganizationType? organizationType,
    String? description,
    String? street,
    String? city,
    String? state,
    String? contactEmail,
    String? contactPhone,
    List<WorkingHourEntity>? workingHours,
    List<DepartmentEntity>? departments,
    int? appointmentDuration,
    int? advanceBookingDays,
    List<TimeSlotEntity>? timeSlots,
    bool? isActive,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserEntity? user,
  }) {
    return OrganizationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      organizationName: organizationName ?? this.organizationName,
      organizationType: organizationType ?? this.organizationType,
      description: description ?? this.description,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      workingHours: workingHours ?? this.workingHours,
      departments: departments ?? this.departments,
      appointmentDuration: appointmentDuration ?? this.appointmentDuration,
      advanceBookingDays: advanceBookingDays ?? this.advanceBookingDays,
      timeSlots: timeSlots ?? this.timeSlots,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }

  String get fullAddress {
    final parts = [street, city, state]
        .where((part) => part != null && part.isNotEmpty)
        .toList();
    return parts.join(', ');
  }

  bool get isOpenToday {
    final now = DateTime.now();
    final today = now.weekday;

    final Map<int, String> weekdayMap = {
      1: 'monday',
      2: 'tuesday',
      3: 'wednesday',
      4: 'thursday',
      5: 'friday',
      6: 'saturday',
      7: 'sunday',
    };

    final todayString = weekdayMap[today];
    final todayHours = workingHours.firstWhere(
      (hour) => hour.day.toLowerCase() == todayString?.toLowerCase(),
      orElse: () => WorkingHourEntity(
        day: todayString ?? '',
        openingTime: '00:00',
        closingTime: '00:00',
        isWorking: false,
      ),
    );

    return todayHours.isWorking;
  }

  List<TimeSlotEntity> get availableTimeSlots {
    return timeSlots.where((slot) => slot.isAvailable).toList();
  }
}
