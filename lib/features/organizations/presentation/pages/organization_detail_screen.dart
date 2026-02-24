import 'package:flutter/material.dart';
import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';
import 'package:quickpalo/features/organizations/presentation/widgets/date_selector.dart';
import 'package:quickpalo/features/organizations/presentation/widgets/department_selector.dart';
import 'package:quickpalo/features/organizations/presentation/widgets/time_selector.dart';
import 'package:quickpalo/app/theme/app_colors.dart';
import 'package:quickpalo/features/appointment/presentation/pages/appointment_detail_screen.dart';
import 'package:quickpalo/core/widgets/custom_button.dart';
import 'package:quickpalo/core/widgets/custom_detail_action.dart';
import 'package:quickpalo/features/messages/presentation/pages/chat_screen.dart';
import 'package:quickpalo/core/api/api_endpoints.dart';

class OrganizationDetailScreen extends StatefulWidget {
  final OrganizationEntity organization;

  const OrganizationDetailScreen({super.key, required this.organization});

  @override
  State<OrganizationDetailScreen> createState() =>
      _OrganizationDetailScreenState();
}

class _OrganizationDetailScreenState extends State<OrganizationDetailScreen> {
  String? _selectedDepartment;
  String? _selectedDepartmentId;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final org = widget.organization;

        final address = [org.street, org.city, org.state]
            .where((part) => part != null && part.isNotEmpty)
            .join(', ');

        final contactPhone =
            org.contactPhone != null && org.contactPhone!.isNotEmpty
                ? org.contactPhone!
                : 'Phone Number not available';
        final workingHours = org.workingHours.isNotEmpty
            ? '${org.workingHours.first.openingTime} - ${org.workingHours.first.closingTime}'
            : 'Hours not available';

        String getFormattedFees(int? fees) {
          if (fees == null) return 'Fees not available';
          if (fees == 0) return 'Free';
          return 'Rs $fees';
        }

        final fees = getFormattedFees(org.fees);
        final departmentNames =
            org.departments.map((dept) => dept.name).toList();

        final timeSlotStrings = org.timeSlots
            .where((slot) => slot.isAvailable)
            .map((slot) => '${slot.startTime} - ${slot.endTime}')
            .toList();

        final imageUrl = org.user?.profilePicture != null
            ? ApiEndpoints.imageUrl(org.user!.profilePicture!)
            : 'https://via.placeholder.com/800x400';

        final bool isBookingEnabled = _selectedDepartment != null &&
            _selectedDate != null &&
            _selectedTimeSlot != null;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Book Appointment"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: isTablet
                  ? const EdgeInsets.symmetric(horizontal: 25)
                  : const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: double.infinity,
                      height: isTablet ? 500 : 250,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(
                                org.organizationName,
                                style: TextStyle(
                                  fontFamily: "Inter Bold 18",
                                  fontSize: isTablet ? 34 : 22,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (address.isNotEmpty)
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: isTablet ? 20 : 13,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      address,
                                      style: TextStyle(
                                        fontSize: isTablet ? 22 : 14,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone_outlined,
                                  color: Colors.grey,
                                  size: isTablet ? 20 : 13,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  contactPhone,
                                  style: TextStyle(
                                    fontSize: isTablet ? 22 : 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.grey,
                                  size: isTablet ? 20 : 13,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  workingHours,
                                  style: TextStyle(
                                    fontSize: isTablet ? 22 : 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.payments,
                                  color: Colors.grey,
                                  size: isTablet ? 20 : 13,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  fees,
                                  style: TextStyle(
                                    fontSize: isTablet ? 22 : 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 246, 244, 244),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            CustomDetailAction(
                              icon: Icons.message,
                              label: "Message",
                              isTablet: isTablet,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      orgUserId: org.user?.id ?? '',
                                      orgName: org.organizationName,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  if (org.description != null &&
                      org.description!.isNotEmpty) ...[
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: isTablet ? 30 : 20,
                        fontFamily: "Inter Bold 24",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        org.description!,
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 16,
                          height: 1.5,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (departmentNames.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Text(
                        "Department",
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: "Inter Bold 24",
                        ),
                      ),
                    ),
                    DepartmentSelector(
                      departments: org.departments,
                      onDepartmentSelected: (dept) {
                        setState(() {
                          _selectedDepartment = dept.name;
                          _selectedDepartmentId = dept.id;
                        });
                      },
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8, 5, 0, 0),
                    child: Text(
                      "Slots",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Inter Bold 24",
                      ),
                    ),
                  ),
                  DateSelector(
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                  if (timeSlotStrings.isNotEmpty)
                    TimeSelector(
                      timeSlots: timeSlotStrings,
                      onTimeSelected: (timeSlot) {
                        setState(() {
                          _selectedTimeSlot = timeSlot;
                        });
                      },
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No time slots available'),
                    ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomButton(
                      text: "Book Appointment",
                      onPressed: isBookingEnabled
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AppointmentDetailScreen(
                                    organization: org,
                                    selectedDepartment: _selectedDepartment!,
                                    selectedDate: _selectedDate!,
                                    selectedTimeSlot: _selectedTimeSlot!,
                                    selectedDepartmentId:
                                        _selectedDepartmentId!,
                                  ),
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                  if (!isBookingEnabled)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Please select department, date, and time to continue',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
