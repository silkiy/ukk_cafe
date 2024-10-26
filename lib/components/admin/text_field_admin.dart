import 'package:flutter/material.dart';

Widget buildTextField(
    TextEditingController controller, String label, bool isNumber) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none, // Menghilangkan border default
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Color.fromRGBO(203, 24, 28, 1), // Warna border saat fokus
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey, // Warna border saat tidak fokus
            width: 1.0,
          ),
        ),
        fillColor: Colors.white,
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    ),
  );
}
