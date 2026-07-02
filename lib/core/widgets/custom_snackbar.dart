import 'package:flutter/material.dart';

class CustomSnackbar {
  CustomSnackbar._();

  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
    bool isSuccess = false,
  }) {
    final theme = Theme.of(context);
    
    Color backgroundColor;
    IconData icon;
    
    if (isError) {
      backgroundColor = const Color(0xFFDC2626);
      icon = Icons.error_outline_rounded;
    } else if (isSuccess) {
      backgroundColor = const Color(0xFF16A34A);
      icon = Icons.check_circle_outline_rounded;
    } else {
      backgroundColor = theme.primaryColor;
      icon = Icons.info_outline_rounded;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
