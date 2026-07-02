import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class HostChallengeSheet extends StatefulWidget {
  final void Function(String teamName, String venue, DateTime date, String time) onSubmit;

  const HostChallengeSheet({
    super.key,
    required this.onSubmit,
  });

  @override
  State<HostChallengeSheet> createState() => _HostChallengeSheetState();
}

class _HostChallengeSheetState extends State<HostChallengeSheet> {
  final _teamNameController = TextEditingController();
  final _venueController = TextEditingController();
  final _timeController = TextEditingController();
  DateTime _matchDate = DateTime.now();

  @override
  void dispose() {
    _teamNameController.dispose();
    _venueController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
        top: 24.h,
        left: 24.w,
        right: 24.w,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'HOST OPEN CHALLENGE',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Post a match slot to invite opponents',
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
          ),
          SizedBox(height: 24.h),
          
          // Form Fields using Core CustomTextField
          CustomTextField(
            controller: _teamNameController,
            hintText: 'Your Team Name',
            prefixIcon: Icons.shield_outlined,
          ),
          SizedBox(height: 16.h),
          
          CustomTextField(
            controller: _venueController,
            hintText: 'Futsal Venue (e.g. Camp Nou)',
            prefixIcon: Icons.location_on_outlined,
          ),
          SizedBox(height: 16.h),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _matchDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (picked != null) {
                      setState(() {
                        _matchDate = picked;
                      });
                    }
                  },
                  icon: Icon(Icons.calendar_today, size: 16.r),
                  label: Text(
                    DateFormat('d MMM yyyy').format(_matchDate),
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomTextField(
                  controller: _timeController,
                  hintText: 'Time (e.g. 7-8 PM)',
                  prefixIcon: Icons.access_time_outlined,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          CustomButton(
            text: 'POST TO WAITING POOL',
            onPressed: () {
              if (_teamNameController.text.trim().isEmpty ||
                  _venueController.text.trim().isEmpty ||
                  _timeController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              widget.onSubmit(
                _teamNameController.text.trim(),
                _venueController.text.trim(),
                _matchDate,
                _timeController.text.trim(),
              );
            },
          ),
        ],
      ),
    );
  }
}
