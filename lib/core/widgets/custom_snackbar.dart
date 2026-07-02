import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

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
      backgroundColor = AppColors.error;
      icon = Icons.error_outline_rounded;
    } else if (isSuccess) {
      backgroundColor = AppColors.success;
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
            Icon(icon, color: Colors.white, size: 20.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        margin: EdgeInsets.all(16.r),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
