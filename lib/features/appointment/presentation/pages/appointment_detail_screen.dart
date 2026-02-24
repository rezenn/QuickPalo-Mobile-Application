import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';
import 'package:quickpalo/features/appointment/presentation/pages/appointment_booking_screen.dart';
import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';
import '../view_model/appointment_viewmodel.dart';
import '../state/appointment_state.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart'
    as appointment;

class AppointmentDetailScreen extends ConsumerStatefulWidget {
  final OrganizationEntity organization;
  final String selectedDepartment;
  final String selectedDepartmentId;
  final DateTime selectedDate;
  final String selectedTimeSlot;

  const AppointmentDetailScreen({
    super.key,
    required this.organization,
    required this.selectedDepartment,
    required this.selectedDepartmentId,
    required this.selectedDate,
    required this.selectedTimeSlot,
  });

  @override
  ConsumerState<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState
    extends ConsumerState<AppointmentDetailScreen> {
  bool _hasCheckedAvailability = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAvailability());
  }

  Future<void> _checkAvailability() async {
    final parts = widget.selectedTimeSlot.split(' - ');
    if (parts.length != 2) return;

    await ref.read(appointmentViewModelProvider.notifier).checkAvailability(
          CheckAvailabilityParams(
            organizationId: widget.organization.id ?? '',
            date: widget.selectedDate,
            startTime: parts[0].trim(),
            endTime: parts[1].trim(),
            departmentId: widget.selectedDepartmentId,
          ),
        );

    if (mounted) setState(() => _hasCheckedAvailability = true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentViewModelProvider);
    final isChecking = state.status == AppointmentScreenStatus.checking;
    final availability = state.availability;
    final isAvailable = availability?.isAvailable ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Slot'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OrgCard(organization: widget.organization),
            const SizedBox(height: 20),

            // Slot Summary Card
            _SlotSummaryCard(
              department: widget.selectedDepartment,
              date: widget.selectedDate,
              timeSlot: widget.selectedTimeSlot,
              fees: widget.organization.fees,
            ),
            const SizedBox(height: 20),

            // Availability Status
            if (isChecking)
              const _AvailabilityChecking()
            else if (_hasCheckedAvailability)
              _AvailabilityBadge(
                  isAvailable: isAvailable, availability: availability),

            const SizedBox(height: 28),

            // Proceed Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isAvailable ? const Color(0xFFB61BE1) : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: isAvailable ? 3 : 0,
                ),
                onPressed: (isAvailable && !isChecking)
                    ? () {
                        final parts = widget.selectedTimeSlot.split(' - ');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AppointmentBookingScreen(
                              organization: widget.organization,
                              selectedDepartment: widget.selectedDepartment,
                              selectedDepartmentId: widget.selectedDepartmentId,
                              selectedDate: widget.selectedDate,
                              timeslot: appointment.TimeSlotEntity(
                                startTime: parts[0].trim(),
                                endTime: parts[1].trim(),
                              ),
                            ),
                          ),
                        );
                      }
                    : null,
                child: Text(
                  isChecking
                      ? 'Checking...'
                      : isAvailable
                          ? 'Proceed to Book'
                          : 'Slot Unavailable',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),

            if (_hasCheckedAvailability && !isAvailable) ...[
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Choose Another Slot'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFB61BE1),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OrgCard extends StatelessWidget {
  final OrganizationEntity organization;
  const _OrgCard({required this.organization});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0DBFF), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFB61BE1).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.business_rounded,
                color: Color(0xFF6C5CE7), size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  organization.organizationName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  organization.fullAddress,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotSummaryCard extends StatelessWidget {
  final String department;
  final DateTime date;
  final String timeSlot;
  final int fees;

  const _SlotSummaryCard({
    required this.department,
    required this.date,
    required this.timeSlot,
    required this.fees,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Appointment Summary',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3436),
            ),
          ),
          const Divider(height: 24),
          _Row(
            icon: Icons.business,
            label: 'Department',
            value: department,
          ),
          const SizedBox(height: 12),
          _Row(
            icon: Icons.calendar_month_outlined,
            label: 'Date',
            value: _formatDate(date),
          ),
          const SizedBox(height: 12),
          _Row(
            icon: Icons.access_time_outlined,
            label: 'Time',
            value: timeSlot,
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Appointment Fee',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF636E72),
                ),
              ),
              Text(
                'Rs $fees',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB61BE1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _Row({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF6C5CE7)),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 14, color: Color(0xFF636E72)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3436),
            ),
          ),
        ),
      ],
    );
  }
}

class _AvailabilityChecking extends StatelessWidget {
  const _AvailabilityChecking();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(
            'Checking slot availability...',
            style: TextStyle(color: Colors.blue.shade700, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  final bool isAvailable;
  final AvailabilityEntity? availability;
  const _AvailabilityBadge({required this.isAvailable, this.availability});

  @override
  Widget build(BuildContext context) {
    final color = isAvailable ? Colors.green : Colors.red;
    final icon =
        isAvailable ? Icons.check_circle_outline : Icons.cancel_outlined;
    final title = isAvailable ? 'Slot Available!' : 'Slot Not Available';
    final subtitle = isAvailable
        ? 'This time slot is open for your selected department.'
        : (availability?.departmentName != null
            ? 'Department "${availability!.departmentName}" is booked at this time.'
            : 'This time slot is already booked.');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color.shade600, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: color.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
