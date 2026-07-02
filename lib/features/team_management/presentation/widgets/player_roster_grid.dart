import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_avatar.dart';
import '../../domain/entities/player.dart';

class PlayerRosterGrid extends StatelessWidget {
  final List<Player> roster;
  final bool isTablet;

  const PlayerRosterGrid({
    super.key,
    required this.roster,
    required this.isTablet,
  });

  Widget _buildPlayerStatMini(String title, String value, ThemeData theme) {
    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(fontSize: 7.sp),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: roster.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final player = roster[index];
        return Card(
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Custom Avatar from Core
                CustomAvatar(
                  radius: 28.r,
                  imageUrl: player.avatarUrl,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                ),
                SizedBox(height: 8.h),
                Text(
                  player.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    player.role.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontSize: 8.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                const Divider(),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPlayerStatMini('MATCHES', player.matchesPlayed.toString(), theme),
                    _buildPlayerStatMini('GOALS', player.goals.toString(), theme),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
