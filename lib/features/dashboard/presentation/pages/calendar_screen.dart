import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/app/theme/app_colors.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';
import 'package:quickpalo/features/appointment/presentation/view_model/appointment_viewmodel.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appointmentViewModelProvider.notifier).getUserAppointments();
    });
  }

  Map<DateTime, List<AppointmentEntity>> _groupByDate(
      List<AppointmentEntity> appointments) {
    final map = <DateTime, List<AppointmentEntity>>{};
    for (final a in appointments) {
      final key = DateTime(a.date.year, a.date.month, a.date.day);
      map[key] = [...(map[key] ?? []), a];
    }
    return map;
  }

  List<AppointmentEntity> _getEventsForDay(
    DateTime day,
    Map<DateTime, List<AppointmentEntity>> grouped,
  ) {
    final key = DateTime(day.year, day.month, day.day);
    return grouped[key] ?? [];
  }

  Color _statusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return const Color(0xFFF59E0B);
      case AppointmentStatus.confirmed:
        return const Color(0xFF3B82F6);
      case AppointmentStatus.completed:
        return const Color(0xFF10B981);
      case AppointmentStatus.cancelled:
        return const Color(0xFFEF4444);
      case AppointmentStatus.noShow:
        return const Color(0xFF6B7280);
    }
  }

  Color _statusBgColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return const Color(0xFFFEF3C7);
      case AppointmentStatus.confirmed:
        return const Color(0xFFDBEAFE);
      case AppointmentStatus.completed:
        return const Color(0xFFD1FAE5);
      case AppointmentStatus.cancelled:
        return const Color(0xFFFEE2E2);
      case AppointmentStatus.noShow:
        return const Color(0xFFF3F4F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentViewModelProvider);
    final grouped = _groupByDate(state.appointments);
    final selectedEvents = _selectedDay != null
        ? _getEventsForDay(_selectedDay!, grouped)
        : <AppointmentEntity>[];
    return Scaffold(
      backgroundColor: const Color.fromARGB(15, 23, 112, 201),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "My Calendar",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TableCalendar<AppointmentEntity>(
                    focusedDay: _focusedDay,
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    eventLoader: (day) => _getEventsForDay(day, grouped),
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: const {
                      CalendarFormat.month: "Month",
                    },
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      todayDecoration: BoxDecoration(
                          color: lightPurpleColor2.withAlpha(100),
                          shape: BoxShape.circle),
                      todayTextStyle: const TextStyle(
                          color: lightPurpleColor2,
                          fontWeight: FontWeight.bold),
                      selectedDecoration: const BoxDecoration(
                          color: lightPurpleColor2, shape: BoxShape.circle),
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: lightPurpleColor2,
                        shape: BoxShape.circle,
                      ),
                      markerSize: 5,
                      markersMaxCount: 3,
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      leftChevronIcon:
                          Icon(Icons.chevron_left, color: Colors.black),
                      rightChevronIcon:
                          Icon(Icons.chevron_right, color: Colors.black),
                    ),
                  ),
                ),
                const Divider(height: 1, color: Colors.white),
                if (_selectedDay != null)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Text(
                          _formatSelectedDay(_selectedDay!),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        if (selectedEvents.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: lightPurpleColor2,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              '${selectedEvents.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                const Divider(
                  height: 1,
                  color: Colors.white,
                ),
                Expanded(
                  child: selectedEvents.isEmpty
                      ? _buildEmpty()
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: selectedEvents.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final appt = selectedEvents[index];
                            return _AppointmentCard(
                              appointment: appt,
                              statusColor: _statusColor(appt.status),
                              statusBgColor: _statusBgColor(appt.status),
                              onTap: () => _showDetail(context, appt),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  String _formatSelectedDay(DateTime day) {
    final months = [
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
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final weekday = days[day.weekday - 1];
    return '$weekday, ${months[day.month - 1]} ${day.day}';
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 40,
            color: Colors.grey[300],
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "No appointments on this day",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, AppointmentEntity appt) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AppointmentDetailSheet(appointment: appt),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final Color statusColor;
  final Color statusBgColor;
  final VoidCallback onTap;

  const _AppointmentCard({
    required this.appointment,
    required this.statusColor,
    required this.statusBgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 72,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.departmentName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 12, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                appointment.timeslot.displayTime,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Rs ${appointment.paymentAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          appointment.statusDisplayName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _AppointmentDetailSheet extends StatelessWidget {
  final AppointmentEntity appointment;

  const _AppointmentDetailSheet({required this.appointment});

  Color get _statusColor {
    switch (appointment.status) {
      case AppointmentStatus.pending:
        return const Color(0xFFF59E0B);
      case AppointmentStatus.confirmed:
        return const Color(0xFF3B82F6);
      case AppointmentStatus.completed:
        return const Color(0xFF10B981);
      case AppointmentStatus.cancelled:
        return const Color(0xFFEF4444);
      case AppointmentStatus.noShow:
        return const Color(0xFF6B7280);
    }
  }

  Color get _statusBgColor {
    switch (appointment.status) {
      case AppointmentStatus.pending:
        return const Color(0xFFFEF3C7);
      case AppointmentStatus.confirmed:
        return const Color(0xFFDBEAFE);
      case AppointmentStatus.completed:
        return const Color(0xFFD1FAE5);
      case AppointmentStatus.cancelled:
        return const Color(0xFFFEE2E2);
      case AppointmentStatus.noShow:
        return const Color(0xFFF3F4F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            height: 4,
            color: _statusColor,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.clientName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color(0xFF111827),
                            ),
                          ),
                          Text(
                            appointment.clientEmail,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _statusBgColor,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        appointment.statusDisplayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Color(0xFFF3F4F6)),
                const SizedBox(height: 16),
                _DetailRow(
                  icon: Icons.calendar_month_outlined,
                  label: 'Date',
                  value: _formatDate(appointment.date),
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.access_time_outlined,
                  label: 'Time',
                  value: appointment.timeslot.displayTime,
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.business_center_outlined,
                  label: 'Department',
                  value: appointment.departmentName,
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: appointment.clientPhoneNumber,
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.payment_outlined,
                  label: 'Payment',
                  value:
                      'Rs ${appointment.paymentAmount.toStringAsFixed(0)} · ${appointment.paymentMethod == PaymentMethod.cash ? "Cash" : "Online"}',
                ),
                if (appointment.notes != null &&
                    appointment.notes!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.notes_outlined,
                    label: 'Notes',
                    value: appointment.notes!,
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 10),
        SizedBox(
          width: 90,
          child: Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF111827),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
