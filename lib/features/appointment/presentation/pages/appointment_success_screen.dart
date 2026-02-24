import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
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

  final GlobalKey _qrKey = GlobalKey();

  bool _isDownloading = false;

  static const Color _accent = Color(0xFFBA7BF0);

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

  String get _qrData {
    final apt = widget.appointment;
    return [
      'QUICKPALO APPOINTMENT',
      'ID: ${apt.id ?? 'N/A'}',
      'Org: ${widget.organizationName}',
      'Dept: ${apt.departmentName}',
      'Client: ${apt.clientName}',
      'Email: ${apt.clientEmail}',
      'Phone: ${apt.clientPhoneNumber}',
      'Date: ${_formatDate(apt.date)}',
      'Time: ${apt.timeslot.displayTime}',
      'Status: ${apt.statusDisplayName}',
      'Payment: ${apt.paymentMethod == PaymentMethod.online ? 'Online' : 'Cash'} • Rs ${apt.paymentAmount.toInt()}',
      if (apt.notes != null && apt.notes!.isNotEmpty) 'Notes: ${apt.notes}',
    ].join('\n');
  }

  Future<void> _downloadQr() async {
    setState(() => _isDownloading = true);
    try {
      final boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/ appointment_qr.png');
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        subject: 'Appointment QR — ${widget.organizationName}',
        text:
            'My appointment at ${widget.organizationName} on ${_formatDate(widget.appointment.date)}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to save QR: $e"),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final apt = widget.appointment;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),

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
                          label: 'Organization',
                          value: widget.organizationName,
                        ),
                        _DetailRow(
                          icon: Icons.business_center_outlined,
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

                const SizedBox(
                  height: 10,
                ),
                FadeTransition(
                  opacity: _fadeAnim,
                  child: RepaintBoundary(
                    key: _qrKey,
                    child: _QrCard(
                      qrData: _qrData,
                      apt: apt,
                      organizationName: widget.organizationName,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                FadeTransition(
                  opacity: _fadeAnim,
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _accent,
                        side: const BorderSide(color: _accent, width: 1.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _isDownloading ? null : _downloadQr,
                      icon: _isDownloading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: _accent,
                              ),
                            )
                          : const Icon(Icons.download_rounded, size: 20),
                      label: Text(
                        _isDownloading ? 'Saving...' : 'Download QR',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

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

class _QrCard extends StatelessWidget {
  final String qrData;
  final AppointmentEntity apt;
  final String organizationName;
  const _QrCard(
      {required this.qrData,
      required this.apt,
      required this.organizationName});

  static const Color _accent = Color(0xFFBA7BF0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_2_rounded, color: _accent, size: 22),
              const SizedBox(width: 8),
              const Text(
                'Appointment QR',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _accent.withOpacity(0.25), width: 1.5),
            ),
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 250,
              backgroundColor: Colors.white,
              embeddedImage: const AssetImage('assets/images/logo.png'),
              embeddedImageStyle: const QrEmbeddedImageStyle(
                size: Size(30, 30),
              ),
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            ),
          ),
          const SizedBox(height: 16),
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6C5CE7)),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 14, color: Color(0xFF636E72)),
          ),
          const SizedBox(
            height: 10,
          ),
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
