import 'package:flutter/material.dart';
import 'package:work_flow_manager/app_theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: Theme.of(context).textTheme.bodyMedium,
        minimumSize: const Size.fromHeight(40),
        shape: RoundedRectangleBorder(
          // Change your radius here
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: AppTheme.appColor,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
