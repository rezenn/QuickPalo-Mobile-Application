import 'package:flutter/material.dart';
import 'package:quickpalo/constant/colors.dart';

class CustomChipSelection extends StatelessWidget {
  const CustomChipSelection({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    // this.hasBorder = false,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  // final bool hasBorder;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? darkSelectClipColor : lightSelectClipColor,
          borderRadius: BorderRadius.circular(12),
          // border: hasBorder ? Border.all(color: boderColor) : null,
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Inter Bold 24",
            color: isSelected ? Colors.white : darkSelectClipColor,
          ),
        ),
      ),
    );
  }
}
