import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/appointment_entity.dart';
import '../view_model/appointment_viewmodel.dart';

class AppointmentSingleScreen extends ConsumerWidget {
  final AppointmentEntity appointment;
  const AppointmentSingleScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appointmentViewModelProvider);
    final apt = state.appointments.firstWhere(
      (a) => a.id == appointment.id,
      orElse: () => appointment,
    );

    final statusColor = _statusColor(apt.status);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      appBar: AppBar(
        title: const Text(
          'Appointment Details',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Status Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [statusColor.withOpacity(0.85), statusColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withOpacity(0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    _statusIcon(apt.status),
                    color: Colors.white,
                    size: 44,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    apt.statusDisplayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    apt.departmentName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Details Card
            _Card(
              title: 'Appointment Info',
              children: [
                _DetailRow(
                  icon: Icons.calendar_month_outlined,
                  label: 'Date',
                  value: _formatDate(apt.date),
                ),
                _DetailRow(
                  icon: Icons.calendar_month_outlined,
                  label: 'Date',
                  value: _formatDate(apt.date),
                ),
                _DetailRow(
                  icon: Icons.access_time_outlined,
                  label: 'Time',
                  value: apt.timeslot.displayTime,
                ),
                _DetailRow(
                  icon: Icons.business_center_outlined,
                  label: 'Department',
                  value: apt.departmentName,
                ),
                if (apt.notes != null && apt.notes!.isNotEmpty)
                  _DetailRow(
                    icon: Icons.notes_outlined,
                    label: 'Notes',
                    value: apt.notes!,
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Client Card
            _Card(
              title: 'Client Information',
              children: [
                _DetailRow(
                  icon: Icons.person_outline,
                  label: 'Name',
                  value: apt.clientName,
                ),
                _DetailRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: apt.clientEmail,
                ),
                _DetailRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: apt.clientPhoneNumber,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Payment Card
            _Card(
              title: 'Payment',
              children: [
                _DetailRow(
                  icon: Icons.payments_outlined,
                  label: 'Method',
                  value: apt.paymentMethod == PaymentMethod.online
                      ? 'Online Payment'
                      : 'Pay at Location',
                ),
                _DetailRow(
                  icon: Icons.attach_money_outlined,
                  label: 'Amount',
                  value: 'Rs ${apt.paymentAmount.toInt()}',
                ),
                _DetailRow(
                  icon: Icons.receipt_outlined,
                  label: 'Payment Status',
                  value: apt.paymentStatus.name.toUpperCase(),
                  valueColor: apt.paymentStatus == PaymentStatus.paid
                      ? Colors.green
                      : Colors.orange,
                ),
              ],
            ),

            // Cancel button
            if (apt.isCancellable) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.shade300, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => _showCancelDialog(context, ref, apt.id!),
                  child: const Text(
                    'Cancel Appointment',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(
      BuildContext context, WidgetRef ref, String appointmentId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Appointment',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content:
            const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(appointmentViewModelProvider.notifier)
                  .cancelAppointment(appointmentId);
              if (success && context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Cancel It'),
          ),
        ],
      ),
    );
  }

  Color _statusColor(AppointmentStatus s) {
    switch (s) {
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.completed:
        return Colors.blue;
      case AppointmentStatus.noShow:
        return Colors.orange;
      default:
        return const Color(0xFFBA7BF0);
    }
  }

  IconData _statusIcon(AppointmentStatus s) {
    switch (s) {
      case AppointmentStatus.confirmed:
        return Icons.check_circle_outline;
      case AppointmentStatus.cancelled:
        return Icons.cancel_outlined;
      case AppointmentStatus.completed:
        return Icons.done_all;
      case AppointmentStatus.noShow:
        return Icons.person_off_outlined;
      default:
        return Icons.hourglass_empty_outlined;
    }
  }

  String _formatDate(DateTime d) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return '${days[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

class _Card extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Card({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFFBA7BF0),
              letterSpacing: 0.5,
            ),
          ),
          const Divider(height: 20),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  const _DetailRow(
      {required this.icon,
      required this.label,
      required this.value,
      this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: const Color(0xFF6C5CE7)),
          const SizedBox(width: 10),
          SizedBox(
            width: 85,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF636E72)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? const Color(0xFF2D3436),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
