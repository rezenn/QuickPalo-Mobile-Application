import 'package:flutter/material.dart';
import 'package:quickpalo/features/appointment/presentation/pages/appointment_confirm_screen.dart';
import 'package:quickpalo/core/widgets/custom_button.dart';
import 'package:quickpalo/features/organizations/domain/entities/organization_entity.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final OrganizationEntity organization;
  final String selectedDepartment;
  final DateTime selectedDate;
  final String selectedTimeSlot;

  const AppointmentDetailScreen({
    super.key,
    required this.organization,
    required this.selectedDepartment,
    required this.selectedDate,
    required this.selectedTimeSlot,
  });

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  final TextEditingController _noteController = TextEditingController();

  String _selectedPaymentMethod = 'online';
  bool _isLoading = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _confirmAppointment() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        final appointmentData = {
          'organizationId': widget.organization.id,
          'organizationName': widget.organization.organizationName,
          'organizationLocation': widget.organization.fullAddress,
          'department': widget.selectedDepartment,
          'date': _formatDate(widget.selectedDate),
          'time': widget.selectedTimeSlot,
          'fee': widget.organization.fees.toString(),
          'currency': 'Rs',
          'note': _noteController.text,
          'paymentMethod': _selectedPaymentMethod,
        };

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentConfirmScreen(
              appointmentData: appointmentData,
            ),
          ),
        );
      }
    });
  }

  String _formatDate(DateTime date) {
    return '${_getMonth(date.month)} ${date.day}, ${date.year}';
  }

  String _getMonth(int month) {
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
    return months[month - 1];
  }

  Widget _buildInfoRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Colors.grey[600]),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final horizontalPadding = isTablet ? constraints.maxWidth * 0.2 : 16.0;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Appointment Details",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Organization Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.organization.organizationName,
                        style: const TextStyle(
                          fontFamily: "Inter",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: isTablet ? 20 : 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.organization.fullAddress,
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Appointment Details Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Appointment Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 24),

                      _buildInfoRow(
                        "Department:",
                        widget.selectedDepartment,
                        icon: Icons.local_hospital_outlined,
                      ),
                      _buildInfoRow(
                        "Date:",
                        _formatDate(widget.selectedDate),
                        icon: Icons.calendar_today_outlined,
                      ),
                      _buildInfoRow(
                        "Time:",
                        widget.selectedTimeSlot,
                        icon: Icons.access_time_outlined,
                      ),

                      const SizedBox(height: 16),

                      // Note field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextFormField(
                          controller: _noteController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Add any notes for the appointment...",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            prefixIcon: const Icon(
                              Icons.note_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Payment Section Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Appointment Fee",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "``Rs ``${widget.organization.fees}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      const Text(
                        "Select Payment Method:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            RadioListTile<String>(
                              title: const Row(
                                children: [
                                  Icon(Icons.payment,
                                      color: Colors.purple, size: 24),
                                  SizedBox(width: 12),
                                  Text(
                                    "Online Payment",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              subtitle: const Text(
                                "Pay via credit card, debit card",
                                style: TextStyle(fontSize: 13),
                              ),
                              value: 'online',
                              groupValue: _selectedPaymentMethod,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPaymentMethod = value!;
                                });
                              },
                              activeColor: Colors.purple,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              secondary: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.green[200]!),
                                ),
                                child: Text(
                                  "Recommended",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(height: 0, indent: 56),
                            RadioListTile<String>(
                              title: const Row(
                                children: [
                                  Icon(Icons.payments,
                                      color: Colors.amber, size: 24),
                                  SizedBox(width: 12),
                                  Text(
                                    "Physical Payment",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              subtitle: const Text(
                                "Pay with cash or card at the location",
                                style: TextStyle(fontSize: 13),
                              ),
                              value: 'physical',
                              groupValue: _selectedPaymentMethod,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPaymentMethod = value!;
                                });
                              },
                              activeColor: Colors.purple,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_selectedPaymentMethod == 'physical') ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.amber[700],
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  "Please ensure you have the exact amount or card ready at the reception.",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Confirm Button
                CustomButton(
                  onPressed: _isLoading ? null : _confirmAppointment,
                  text: _isLoading ? "Processing..." : "Confirm Appointment",
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 20),

                // Terms and conditions
                Center(
                  child: Text(
                    "By confirming, you agree to our Terms & Conditions",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
