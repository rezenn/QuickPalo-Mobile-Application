import 'package:flutter/material.dart';
import 'package:quickpalo/constant/colors.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w700,
    this.color = textColorBlue,
  });

  final VoidCallback onPressed;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textColorBlue,
          ),
        ),
      ),
    );
  }
}
