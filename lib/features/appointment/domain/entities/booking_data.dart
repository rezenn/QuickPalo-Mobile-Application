import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';

class BookingData {
  final OrganizationEntity organization;
  final String? selectedDepartment;
  final DateTime? selectedDate;
  final String? selectedTimeSlot;
  final String? note;
  final String? paymentMethod;

  BookingData({
    required this.organization,
    this.selectedDepartment,
    this.selectedDate,
    this.selectedTimeSlot,
    this.note,
    this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'organizationId': organization.id,
      'organizationName': organization.organizationName,
      'organizationLocation': organization.fullAddress,
      'clientName': 'Current User',
      'date': selectedDate != null
          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
          : 'Not selected',
      'time': selectedTimeSlot ?? 'Not selected',
      'department': selectedDepartment ?? 'Not selected',
      'fee': organization.fees.toString(),
      'currency': 'Rs',
      'note': note ?? '',
      'paymentMethod': paymentMethod ?? 'online',
    };
  }
}
