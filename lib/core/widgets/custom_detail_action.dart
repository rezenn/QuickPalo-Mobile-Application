import 'package:flutter/material.dart';

class CustomDetailAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isTablet;
  final VoidCallback? onTap;

  const CustomDetailAction({
    super.key,
    required this.icon,
    required this.label,
    required this.isTablet,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isTablet ? 40 : 28, color: Colors.black),
          SizedBox(height: isTablet ? 10 : 6),
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 20 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
