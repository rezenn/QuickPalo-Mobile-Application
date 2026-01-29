import 'package:flutter/material.dart';

enum FieldType { email, password, text }

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.errortext,
    required this.obscureText,
    required this.keyboardType,
    required this.fieldType,
    this.enabled = true,
    this.fillColor,
    this.textColor,
    this.suffixIcon,
    this.validator,
  });
  final TextEditingController controller;
  final String hintText;
  final String errortext;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool enabled;
  final FieldType fieldType;
  final Color? fillColor;
  final Color? textColor;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(
        // Add this to change the text color
        color: textColor, // Or use Colors.grey.shade700 for darker grey
      ),
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        filled: fillColor != null,
        fillColor: fillColor,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.purple),
        ),
      ),
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator ??
          (value) {
            if (!enabled) return null;

            if (value == null || value.trim().isEmpty) {
              return errortext;
            }

            if (fieldType == FieldType.email &&
                !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return "Enter a valid email address";
            }

            if (fieldType == FieldType.password && value.length < 8) {
              return "Password must be at least 8 characters";
            }

            return null;
          },
    );
  }
}
