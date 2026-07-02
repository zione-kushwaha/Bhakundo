import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/team.dart';

class TeamStatsGrid extends StatelessWidget {
  final Team team;

  const TeamStatsGrid({
    super.key,
    required this.team,
  });

  Widget _buildStatItem(String title, String val, Color color, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 9.sp,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            val,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final winRate = team.matchesPlayed > 0 ? (team.wins / team.matchesPlayed * 100).toInt() : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Win rate linear indicator
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'WIN RATE',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp,
                      ),
                    ),
                    Text(
                      '$winRate%',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: team.matchesPlayed > 0 ? team.wins / team.matchesPlayed : 0.0,
                    minHeight: 8.h,
                    backgroundColor: theme.brightness == Brightness.light ? Colors.grey.shade200 : Colors.grey.shade800,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        // Stats grid
        Row(
          children: [
            Expanded(child: _buildStatItem('PLAYED', team.matchesPlayed.toString(), Colors.blueGrey, theme)),
            SizedBox(width: 8.w),
            Expanded(child: _buildStatItem('WINS', team.wins.toString(), AppColors.success, theme)),
            SizedBox(width: 8.w),
            Expanded(child: _buildStatItem('LOSSES', team.losses.toString(), AppColors.error, theme)),
            SizedBox(width: 8.w),
            Expanded(child: _buildStatItem('DRAWS', team.draws.toString(), AppColors.warning, theme)),
          ],
        ),
      ],
    );
  }
}
