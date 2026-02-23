class AppointmentEntity {
  final String? id;
  final String? organizationId;
  final String? userId;
  final String? departmentId;
  final String departmentName;
  final String clientName;
  final String clientEmail;
  final String clientPhoneNumber;
  final String? notes;
  final TimeSlotEntity timeslot;
  final DateTime date;
  final String status;
  final double paymentAmount;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AppointmentEntity(
      {this.id,
      required this.organizationId,
      this.userId,
      required this.departmentId,
      required this.departmentName,
      required this.clientName,
      required this.clientEmail,
      required this.clientPhoneNumber,
      this.notes,
      required this.timeslot,
      required this.date,
      this.status = "pending",
      this.paymentAmount = 0,
      this.paymentMethod = "online",
      this.paymentStatus = "pending",
      this.createdAt,
      this.updatedAt});
}

class TimeSlotEntity {
  final String startTime;
  final String endTime;
  final bool isAvailable;

  const TimeSlotEntity({
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
  });
}

class AvailabilityEntity {
  final bool isAvailable;
  final int? bookedCount;
  final String? departmentName;

  const AvailabilityEntity({
    required this.isAvailable,
    this.bookedCount,
    this.departmentName,
  });
}
