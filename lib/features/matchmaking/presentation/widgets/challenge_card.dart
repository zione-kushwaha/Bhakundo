import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/challenge.dart';

class ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback? onAccept;

  const ChallengeCard({
    super.key,
    required this.challenge,
    this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMatched = challenge.status == 'Matched';

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Match Header with Team Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.shield, color: Colors.blueGrey, size: 24.r),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge.hostTeamName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          'Captain: ${challenge.hostCaptainName}',
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isMatched
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    isMatched ? 'MATCHED' : 'WAITING',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontSize: 9.sp,
                      color: isMatched ? AppColors.success : AppColors.secondary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            const Divider(),
            SizedBox(height: 16.h),

            // Match details
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.location_on, size: 16.r, color: AppColors.primary),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          challenge.venueName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.access_time, size: 16.r, color: AppColors.primary),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          '${DateFormat('d MMM').format(DateTime.parse(challenge.matchDate))} | ${challenge.matchTime}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Match status vs Opponent Card or accept Button
            if (isMatched)
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, color: AppColors.success, size: 18.r),
                    SizedBox(width: 8.w),
                    Text(
                      'Matched against: ',
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
                    ),
                    Text(
                      challenge.opponentTeamName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              )
            else
              CustomButton(
                text: 'ACCEPT CHALLENGE',
                onPressed: onAccept,
              ),
          ],
        ),
      ),
    );
  }
}
