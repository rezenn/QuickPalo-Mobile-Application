import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';

class AppointmentApiModel {
  final String? id;
  final String organizationId;
  final String userId;
  final String departmentId;
  final String departmentName;
  final String clientName;
  final String clientEmail;
  final String clientPhoneNumber;
  final String? notes;
  final Map<String, dynamic> timeslot;
  final String date;
  final String status;
  final double paymentAmount;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AppointmentApiModel({
    this.id,
    required this.organizationId,
    required this.userId,
    required this.departmentId,
    required this.departmentName,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhoneNumber,
    this.notes,
    required this.timeslot,
    required this.date,
    required this.status,
    required this.paymentAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory AppointmentApiModel.fromJson(Map<String, dynamic> json) {
    return AppointmentApiModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      organizationId: json['organizationId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      departmentId: json['departmentId']?.toString() ?? '',
      departmentName: json['departmentName']?.toString() ?? '',
      clientName: json['clientName']?.toString() ?? '',
      clientEmail: json['clientEmail']?.toString() ?? '',
      clientPhoneNumber: json['clientPhoneNumber']?.toString() ?? '',
      notes: json['notes']?.toString(),
      timeslot: json['timeslot'] is Map<String, dynamic>
          ? json['timeslot']
          : {'startTime': '', 'endTime': '', 'isAvailable': true},
      date: json['date']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      paymentAmount: _parseDouble(json['paymentAmount']),
      paymentMethod: json['paymentMethod']?.toString() ?? 'online',
      paymentStatus: json['paymentStatus']?.toString() ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  static DateTime _parseAppointmentDate(String raw) {
    if (raw.isEmpty) return DateTime.now();

    final jsDateRegex = RegExp(
      r'[A-Za-z]{3}\s+([A-Za-z]{3})\s+(\d{1,2})\s+(\d{4})',
    );
    final jsMatch = jsDateRegex.firstMatch(raw);
    if (jsMatch != null) {
      const months = {
        'Jan': 1,
        'Feb': 2,
        'Mar': 3,
        'Apr': 4,
        'May': 5,
        'Jun': 6,
        'Jul': 7,
        'Aug': 8,
        'Sep': 9,
        'Oct': 10,
        'Nov': 11,
        'Dec': 12,
      };
      final month = months[jsMatch.group(1)!];
      final day = int.parse(jsMatch.group(2)!);
      final year = int.parse(jsMatch.group(3)!);
      if (month != null) return DateTime(year, month, day);
    }

    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(raw)) {
      final p = raw.split('-');
      return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
    }

    return DateTime.tryParse(raw)?.toLocal() ?? DateTime.now();
  }

  static double _parseDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is double) return val;
    if (val is int) return val.toDouble();
    return double.tryParse(val.toString()) ?? 0.0;
  }

  AppointmentEntity toEntity() {
    return AppointmentEntity(
      id: id,
      organizationId: organizationId,
      userId: userId,
      departmentId: departmentId,
      departmentName: departmentName,
      clientName: clientName,
      clientEmail: clientEmail,
      clientPhoneNumber: clientPhoneNumber,
      notes: notes,
      timeslot: TimeSlotEntity.fromJson(timeslot),
      date: _parseAppointmentDate(date),
      status: _parseStatus(status),
      paymentAmount: paymentAmount,
      paymentMethod:
          paymentMethod == 'cash' ? PaymentMethod.cash : PaymentMethod.online,
      paymentStatus: _parsePaymentStatus(paymentStatus),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static AppointmentStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppointmentStatus.confirmed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'completed':
        return AppointmentStatus.completed;
      case 'no_show':
        return AppointmentStatus.noShow;
      default:
        return AppointmentStatus.pending;
    }
  }

  static PaymentStatus _parsePaymentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return PaymentStatus.paid;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }
}

class AvailabilityApiModel {
  final bool isAvailable;
  final int? bookedCount;
  final String? departmentName;

  AvailabilityApiModel({
    required this.isAvailable,
    this.bookedCount,
    this.departmentName,
  });

  factory AvailabilityApiModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityApiModel(
      isAvailable: json['isAvailable'] ?? true,
      bookedCount: json['bookedCount'],
      departmentName: json['departmentName']?.toString(),
    );
  }

  AvailabilityEntity toEntity() {
    return AvailabilityEntity(
      isAvailable: isAvailable,
      bookedCount: bookedCount,
      departmentName: departmentName,
    );
  }
}
