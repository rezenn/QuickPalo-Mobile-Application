import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickpalo/features/appointment/presentation/pages/user_appointment_screen.dart';
import '../../domain/entities/appointment_entity.dart';

class AppointmentSuccessScreen extends StatefulWidget {
  final AppointmentEntity appointment;
  final String organizationName;

  const AppointmentSuccessScreen({
    super.key,
    required this.appointment,
    required this.organizationName,
  });

  @override
  State<AppointmentSuccessScreen> createState() =>
      _AppointmentSuccessScreenState();
}

class _AppointmentSuccessScreenState extends State<AppointmentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    HapticFeedback.mediumImpact();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apt = widget.appointment;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // Icon
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 189, 114, 254),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(126, 182, 27, 225)
                            .withAlpha(70),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 52,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    const Text(
                      'Appointment Booked!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your appointment at ${widget.organizationName} is confirmed.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Details Card
              FadeTransition(
                opacity: _fadeAnim,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _DetailRow(
                        icon: Icons.business,
                        label: 'Department',
                        value: apt.departmentName,
                      ),
                      _Divider(),
                      _DetailRow(
                        icon: Icons.calendar_month_outlined,
                        label: 'Date',
                        value: _formatDate(apt.date),
                      ),
                      _Divider(),
                      _DetailRow(
                        icon: Icons.access_time_outlined,
                        label: 'Time',
                        value: apt.timeslot.displayTime,
                      ),
                      _Divider(),
                      _DetailRow(
                        icon: Icons.pending_actions_outlined,
                        label: 'Status',
                        value: apt.statusDisplayName,
                        valueColor: _statusColor(apt.status),
                      ),
                      _Divider(),
                      _DetailRow(
                        icon: Icons.payments_outlined,
                        label: 'Payment',
                        value: apt.paymentMethod == PaymentMethod.online
                            ? 'Online  •  Rs ${apt.paymentAmount.toInt()}'
                            : 'Pay at Location',
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Actions
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBA7BF0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 3,
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const UserAppointmentsScreen(),
                          ),
                          (route) => route.isFirst,
                        );
                      },
                      child: const Text(
                        'View My Appointments',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        color: Color(0xFFBA7BF0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  Color _statusColor(AppointmentStatus s) {
    switch (s) {
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.completed:
        return Colors.blue;
      default:
        return Colors.orange;
    }
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6C5CE7)),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: const TextStyle(fontSize: 14, color: Color(0xFF636E72)),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? const Color(0xFF2D3436),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, color: Colors.grey.shade100);
}
