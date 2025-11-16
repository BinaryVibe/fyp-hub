import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword, // Hides text if it's a password
        decoration: InputDecoration(
          // 1. Set the fill color to be different from the background
          fillColor: Colors.grey[900],
          filled: true,

          // 2. Make the enabled border very dark and subtle
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade800), // <-- CHANGED
            borderRadius: BorderRadius.circular(12),
          ),

          // 3. Keep the blue focused border
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(12),
          ),

          // 4. Keep the hint text style
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        style: const TextStyle(color: Colors.white), // Light text color
      ),
    );
  }
}
