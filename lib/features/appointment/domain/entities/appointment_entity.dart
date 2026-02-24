import 'package:equatable/equatable.dart';

enum AppointmentStatus { pending, confirmed, cancelled, completed, noShow }

enum PaymentMethod { online, cash }

enum PaymentStatus { pending, paid, refunded }

class TimeSlotEntity extends Equatable {
  final String startTime;
  final String endTime;
  final bool isAvailable;

  const TimeSlotEntity(
      {required this.startTime,
      required this.endTime,
      this.isAvailable = true});

  @override
  List<Object?> get props => [startTime, endTime, isAvailable];

  factory TimeSlotEntity.fromJson(Map<String, dynamic> json) {
    return TimeSlotEntity(
        startTime: json['startTime'] ?? '',
        endTime: json['endTime'] ?? '',
        isAvailable: json['isAvailable'] ?? true);
  }
  Map<String, dynamic> toJson() =>
      {'startTime': startTime, 'endTime': endTime, 'isAvailable': isAvailable};
  String get displayTime => '$startTime - $endTime';
}

class AppointmentEntity extends Equatable {
  final String? id;
  final String organizationId;
  final String userId;
  final String departmentId;
  final String departmentName;
  final String clientName;
  final String clientEmail;
  final String clientPhoneNumber;
  final String? notes;
  final TimeSlotEntity timeslot;
  final DateTime date;
  final AppointmentStatus status;
  final double paymentAmount;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AppointmentEntity(
      {this.id,
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
      this.status = AppointmentStatus.pending,
      this.paymentAmount = 0,
      this.paymentMethod = PaymentMethod.online,
      this.paymentStatus = PaymentStatus.pending,
      this.createdAt,
      this.updatedAt});

  @override
  List<Object?> get props => [
        id,
        organizationId,
        userId,
        departmentId,
        departmentName,
        clientName,
        clientEmail,
        clientPhoneNumber,
        notes,
        timeslot,
        date,
        status,
        paymentAmount,
        paymentMethod,
        paymentStatus,
        createdAt,
        updatedAt
      ];
  AppointmentEntity copyWith({
    String? id,
    String? organizationId,
    String? userId,
    String? departmentId,
    String? departmentName,
    String? clientName,
    String? clientEmail,
    String? clientPhoneNumber,
    String? notes,
    TimeSlotEntity? timeslot,
    DateTime? date,
    AppointmentStatus? status,
    double? paymentAmount,
    PaymentMethod? paymentMethod,
    PaymentStatus? paymentStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentEntity(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      userId: userId ?? this.userId,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      clientName: clientName ?? this.clientName,
      clientEmail: clientEmail ?? this.clientEmail,
      clientPhoneNumber: clientPhoneNumber ?? this.clientPhoneNumber,
      notes: notes ?? this.notes,
      timeslot: timeslot ?? this.timeslot,
      date: date ?? this.date,
      status: status ?? this.status,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get statusDisplayName {
    switch (status) {
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.noShow:
        return 'No Show';
    }
  }

  bool get isCancellable =>
      status != AppointmentStatus.cancelled &&
      status != AppointmentStatus.completed;
}

class AvailabilityEntity extends Equatable {
  final bool isAvailable;
  final int? bookedCount;
  final String? departmentName;

  const AvailabilityEntity({
    required this.isAvailable,
    this.bookedCount,
    this.departmentName,
  });

  @override
  List<Object?> get props => [isAvailable, bookedCount, departmentName];
}

class CreateAppointmentParams extends Equatable {
  final String organizationId;
  final String departmentId;
  final String clientName;
  final String clientEmail;
  final String clientPhoneNumber;
  final String? notes;
  final TimeSlotEntity timeslot;
  final DateTime date;
  final double paymentAmount;
  final PaymentMethod paymentMethod;

  const CreateAppointmentParams({
    required this.organizationId,
    required this.departmentId,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhoneNumber,
    this.notes,
    required this.timeslot,
    required this.date,
    this.paymentAmount = 0,
    this.paymentMethod = PaymentMethod.online,
  });

  @override
  List<Object?> get props => [
        organizationId,
        departmentId,
        clientName,
        clientEmail,
        clientPhoneNumber,
        notes,
        timeslot,
        date,
        paymentAmount,
        paymentMethod,
      ];

  Map<String, dynamic> toJson() => {
        'organizationId': organizationId,
        'departmentId': departmentId,
        'clientName': clientName,
        'clientEmail': clientEmail,
        'clientPhoneNumber': clientPhoneNumber,
        if (notes != null && notes!.isNotEmpty) 'notes': notes,
        'timeslot': timeslot.toJson(),
        'date': date.toIso8601String(),
        'paymentAmount': paymentAmount,
        'paymentMethod':
            paymentMethod == PaymentMethod.online ? 'online' : 'cash',
      };
}

class CheckAvailabilityParams extends Equatable {
  final String organizationId;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String? departmentId;

  const CheckAvailabilityParams({
    required this.organizationId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.departmentId,
  });

  @override
  List<Object?> get props => [
        organizationId,
        date,
        startTime,
        endTime,
        departmentId,
      ];
}
