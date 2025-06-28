// CustomTextField widget
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final String? initialValue;
  final Function()? onTap;
  final bool obscureText;
  final IconData? prefixIcon;
  final String? hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool readOnly;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    this.labelText,
    this.initialValue,
    this.obscureText = false,
    this.prefixIcon,
    this.hintText,
    this.onChanged,
    this.validator,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey, size: 20) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFF4A6CF7), width: 2)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.red, width: 2)),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
      ),
      style: const TextStyle(fontSize: 16, color: Colors.black87),
    );
  }
}
