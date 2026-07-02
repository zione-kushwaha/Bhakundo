import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class CustomAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final Color? backgroundColor;

  const CustomAvatar({
    super.key,
    required this.imageUrl,
    required this.radius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarRadius = radius.r;

    return CircleAvatar(
      radius: avatarRadius,
      backgroundColor: backgroundColor ?? theme.primaryColor.withValues(alpha: 0.1),
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (exception, stackTrace) => Container(
        color: AppColors.backgroundDark,
        child: Icon(Icons.person, color: Colors.white54, size: avatarRadius),
      ),
    );
  }
}
