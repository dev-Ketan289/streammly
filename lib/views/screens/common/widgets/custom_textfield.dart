import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final bool enabled; // Add this parameter
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

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
    this.enabled = true, // Add this with default value
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.controller,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      readOnly: readOnly,
      enabled: enabled, // Add this line
      keyboardType: keyboardType,
      maxLength: maxLength,
      inputFormatters: inputFormatters, // Don't forget to add this line too
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon:
            prefixIcon != null
                ? Icon(
                  prefixIcon,
                  color:
                      enabled
                          ? Colors.grey
                          : Colors
                              .grey
                              .shade400, // Adjust icon color based on enabled state
                  size: 20,
                )
                : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: const Color(0xFF4A6CF7), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        disabledBorder: OutlineInputBorder(
          // Add disabled border style
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor:
            enabled
                ? Colors.grey.shade50
                : Colors
                    .grey
                    .shade100, // Different background for disabled state
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: TextStyle(
          color:
              enabled
                  ? Colors.grey
                  : Colors
                      .grey
                      .shade500, // Adjust label color based on enabled state
          fontSize: 12,
        ),
        hintStyle: TextStyle(
          color:
              enabled
                  ? Colors.grey
                  : Colors
                      .grey
                      .shade400, // Adjust hint color based on enabled state
          fontSize: 16,
        ),
        counterText: "",
      ),
      style: TextStyle(
        fontSize: 16,
        color:
            enabled
                ? Colors.black87
                : Colors
                    .grey
                    .shade600, // Adjust text color based on enabled state
      ),
    );
  }
}
