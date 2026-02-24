import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickpalo/core/services/storage/user_session_service.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart';
import 'package:quickpalo/features/appointment/presentation/pages/appointment_success_screen.dart';
import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';
import '../view_model/appointment_viewmodel.dart';
import '../state/appointment_state.dart';
import 'package:quickpalo/features/appointment/domain/entities/appointment_entity.dart'
    as appointment;

class AppointmentBookingScreen extends ConsumerStatefulWidget {
  final OrganizationEntity organization;
  final String selectedDepartment;
  final String selectedDepartmentId;
  final DateTime selectedDate;
  final appointment.TimeSlotEntity timeslot;

  const AppointmentBookingScreen({
    super.key,
    required this.organization,
    required this.selectedDepartment,
    required this.selectedDepartmentId,
    required this.selectedDate,
    required this.timeslot,
  });

  @override
  ConsumerState<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState
    extends ConsumerState<AppointmentBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _noteController = TextEditingController();
  String _paymentMethod = 'online';

  @override
  void initState() {
    super.initState();
    // Pre-fill from session
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(userSessionServiceProvider);
      _nameController.text = session.getuserFullName() ?? '';
      _emailController.text = session.getuserEmail() ?? '';
      _phoneController.text = session.getuserPhoneNumber() ?? '';
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final params = CreateAppointmentParams(
      organizationId: widget.organization.id ?? '',
      departmentId: widget.selectedDepartmentId,
      clientName: _nameController.text.trim(),
      clientEmail: _emailController.text.trim(),
      clientPhoneNumber: _phoneController.text.trim(),
      notes: _noteController.text.trim(),
      timeslot: widget.timeslot,
      date: widget.selectedDate,
      paymentAmount: widget.organization.fees.toDouble(),
      paymentMethod: _paymentMethod == 'online'
          ? PaymentMethod.online
          : PaymentMethod.cash,
    );

    final success = await ref
        .read(appointmentViewModelProvider.notifier)
        .createAppointment(params);

    if (success && mounted) {
      final appointment =
          ref.read(appointmentViewModelProvider).selectedAppointment;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => AppointmentSuccessScreen(
            appointment: appointment!,
            organizationName: widget.organization.organizationName,
          ),
        ),
        (route) => route.isFirst,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentViewModelProvider);
    final isLoading = state.status == AppointmentScreenStatus.creating;

    ref.listen(appointmentViewModelProvider, (prev, next) {
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        ref.read(appointmentViewModelProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      appBar: AppBar(
        title: const Text(
          'Book Appointment',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Slot banner
              _SlotBanner(
                department: widget.selectedDepartment,
                date: widget.selectedDate,
                timeslot: widget.timeslot,
              ),
              const SizedBox(height: 24),

              // Client Info
              _SectionLabel(label: 'Your Information'),
              const SizedBox(height: 12),
              _AppField(
                controller: _nameController,
                label: 'Full Name',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 14),
              _AppField(
                controller: _emailController,
                label: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              _AppField(
                controller: _phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Phone is required'
                    : null,
              ),
              const SizedBox(height: 14),
              _AppField(
                controller: _noteController,
                label: 'Notes (optional)',
                maxLines: 3,
                required: false,
              ),

              const SizedBox(height: 24),

              // Payment Method
              _SectionLabel(label: 'Payment Method'),
              const SizedBox(height: 12),
              _PaymentSelector(
                selected: _paymentMethod,
                fees: widget.organization.fees,
                onChanged: (v) => setState(() => _paymentMethod = v),
              ),

              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB61BE1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Confirm Appointment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 14),
              Center(
                child: Text(
                  'By confirming, you agree to our Terms & Conditions',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Color(0xFF2D3436),
        letterSpacing: 0.2,
      ),
    );
  }
}

class _AppField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool required;
  final String? Function(String?)? validator;

  const _AppField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.maxLines = 1,
    this.required = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDD8FF), width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDD8FF), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: Color.fromARGB(84, 182, 27, 225), width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _SlotBanner extends StatelessWidget {
  final String department;
  final DateTime date;
  final appointment.TimeSlotEntity timeslot;

  const _SlotBanner({
    required this.department,
    required this.date,
    required this.timeslot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(173, 182, 27, 225), Color(0xFFBA7BF0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB61BE1).withAlpha(100),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.event_available, color: Colors.white, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  department,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatDate(date)}  •  ${timeslot.displayTime}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
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
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

class _PaymentSelector extends StatelessWidget {
  final String selected;
  final int fees;
  final ValueChanged<String> onChanged;

  const _PaymentSelector({
    required this.selected,
    required this.fees,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDD8FF), width: 1.2),
      ),
      child: Column(
        children: [
          _PaymentTile(
            value: 'online',
            groupValue: selected,
            icon: Icons.credit_card_outlined,
            title: 'Online Payment',
            subtitle: 'Credit / Debit Card',
            onChanged: onChanged,
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          _PaymentTile(
            value: 'cash',
            groupValue: selected,
            icon: Icons.payments_outlined,
            title: 'Pay at Location',
            subtitle: 'Cash at reception  •  Rs $fees',
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final String value;
  final String groupValue;
  final IconData icon;
  final String title;
  final String subtitle;

  final ValueChanged<String> onChanged;

  const _PaymentTile({
    required this.value,
    required this.groupValue,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color.fromARGB(184, 182, 27, 225)
                  : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? const Color.fromARGB(210, 182, 27, 225)
                              : const Color(0xFF2D3436),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: (v) => onChanged(v!),
              activeColor: const Color(0xFFB61BE1),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}
