import 'package:flutter/material.dart';

TextField forTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    cursorColor: Colors.black12,
    style: TextStyle(color: Colors.black87),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black26,
      ),
      hintText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.red.shade50.withOpacity(0.7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

TextField forReadTextField(String text, IconData icon, bool isPasswordType, String username) {
  return TextField(
    readOnly: true,
    obscureText: isPasswordType,
    cursorColor: Colors.black12,
    style: TextStyle(color: Colors.black87),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black26,
      ),
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.red.shade50.withOpacity(0.7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    controller: TextEditingController(text: username),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}
