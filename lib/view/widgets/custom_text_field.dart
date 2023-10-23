import 'package:flutter/material.dart';
import 'package:work_flow_manager/app_theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.enabled = true,
  });

  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Icon? prefixIcon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        enabled: enabled,
        prefixIcon: prefixIcon,
        labelText: labelText,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: AppTheme.nearlyDarkBlue),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: AppTheme.nearlyDarkBlue),
        ),
      ),
    );
  }
}
