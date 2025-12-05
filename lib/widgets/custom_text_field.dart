import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.errortext,
    this.keyboardType = TextInputType.emailAddress,
    required this.obscureText,
    this.suffixIcon,
  });
  final TextEditingController controller;
  final String hintText;
  final String errortext;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,

        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.purple),
        ),

        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(10)),
        //   borderSide: BorderSide(color: Colors.green),
        // ),
        // filled: true,
        // fillColor: Colors.white,
      ),

      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return errortext;
        }
        return null;
      },
    );
  }
}
