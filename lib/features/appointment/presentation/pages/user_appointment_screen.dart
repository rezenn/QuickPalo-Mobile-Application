import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/appointment_entity.dart';
import '../view_model/appointment_viewmodel.dart';
import '../state/appointment_state.dart';
import 'appointment_single_screen.dart';

class UserAppointmentsScreen extends ConsumerStatefulWidget {
  const UserAppointmentsScreen({super.key});

  @override
  ConsumerState<UserAppointmentsScreen> createState() =>
      _UserAppointmentsScreenState();
}

class _UserAppointmentsScreenState extends ConsumerState<UserAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appointmentViewModelProvider.notifier).getUserAppointments();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentViewModelProvider);

    final active = state.appointments
        .where((a) =>
            a.status == AppointmentStatus.pending ||
            a.status == AppointmentStatus.confirmed)
        .toList();

    final past = state.appointments
        .where((a) =>
            a.status == AppointmentStatus.completed ||
            a.status == AppointmentStatus.noShow)
        .toList();

    final cancelled = state.appointments
        .where((a) => a.status == AppointmentStatus.cancelled)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      appBar: AppBar(
        title: const Text(
          'My Appointments',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFBA7BF0),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFBA7BF0),
          indicatorWeight: 3,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: [
            Tab(text: 'Active (${active.length})'),
            Tab(text: 'Past (${past.length})'),
            Tab(text: 'Cancelled (${cancelled.length})'),
          ],
        ),
      ),
      body: state.status == AppointmentScreenStatus.loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFB61BE1)))
          : state.status == AppointmentScreenStatus.error
              ? _ErrorView(
                  message: state.errorMessage ?? 'Something went wrong',
                  onRetry: () => ref
                      .read(appointmentViewModelProvider.notifier)
                      .getUserAppointments(),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _AppointmentList(appointments: active),
                    _AppointmentList(appointments: past),
                    _AppointmentList(appointments: cancelled),
                  ],
                ),
    );
  }
}

class _AppointmentList extends StatelessWidget {
  final List<AppointmentEntity> appointments;
  const _AppointmentList({required this.appointments});

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy_outlined,
                size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No appointments here',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return _AppointmentCard(appointment: appointments[index]);
      },
    );
  }
}

class _AppointmentCard extends ConsumerWidget {
  final AppointmentEntity appointment;
  const _AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _statusColor(appointment.status);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AppointmentSingleScreen(appointment: appointment),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Status bar
            Container(
              width: 1125,
              height: 5,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          appointment.departmentName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBA7BF0),
                          ),
                        ),
                      ),
                      _StatusChip(
                        label: appointment.statusDisplayName,
                        color: statusColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.calendar_month_outlined,
                    text: _formatDate(appointment.date),
                  ),
                  const SizedBox(height: 6),
                  _InfoRow(
                    icon: Icons.access_time_outlined,
                    text: appointment.timeslot.displayTime,
                  ),
                  const SizedBox(height: 6),
                  _InfoRow(
                    icon: Icons.payments_outlined,
                    text: appointment.paymentMethod == PaymentMethod.online
                        ? 'Online • Rs ${appointment.paymentAmount.toInt()}'
                        : 'Pay at Location',
                  ),
                  if (appointment.isCancellable) ...[
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red.shade500,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.red.shade200),
                          ),
                        ),
                        onPressed: () =>
                            _showCancelDialog(context, ref, appointment.id!),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
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
        content: const Text(
            'Are you sure you want to cancel this appointment? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, Keep It'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(appointmentViewModelProvider.notifier)
                  .cancelAppointment(appointmentId);
            },
            child: const Text('Yes, Cancel'),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                foregroundColor: Colors.white,
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
