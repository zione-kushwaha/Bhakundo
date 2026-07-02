import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../../domain/entities/futsal_court.dart';
import '../widgets/court_card.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(LoadCourts());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BOOK A FUTSAL'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<BookingBloc>().add(LoadCourts()),
          )
        ],
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return _buildShimmerLoading(isTablet);
          } else if (state is CourtsLoaded) {
            final courts = state.courts;
            if (courts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sports_soccer, size: 64.r, color: AppColors.secondary.withValues(alpha: 0.5)),
                    SizedBox(height: 16.h),
                    Text('No courts available.', style: theme.textTheme.titleMedium),
                  ],
                ),
              );
            }
            return _buildCourtsGrid(courts, isTablet);
          } else if (state is BookingFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48.r, color: AppColors.error),
                    SizedBox(height: 16.h),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(fontSize: 13.sp),
                    ),
                    SizedBox(height: 24.h),
                    CustomButton(
                      width: 120.w,
                      text: 'RETRY',
                      onPressed: () => context.read<BookingBloc>().add(LoadCourts()),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCourtsGrid(List<FutsalCourt> courts, bool isTablet) {
    return GridView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: courts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 2 : 1,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: isTablet ? 1.4 : 1.15,
      ),
      itemBuilder: (context, index) {
        final court = courts[index];
        return CourtCard(
          court: court,
          onTap: () => context.push('/court-detail/${court.id}'),
        );
      },
    );
  }

  Widget _buildShimmerLoading(bool isTablet) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withValues(alpha: 0.15),
      highlightColor: Colors.grey.withValues(alpha: 0.05),
      child: GridView.builder(
        padding: EdgeInsets.all(16.r),
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isTablet ? 2 : 1,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: isTablet ? 1.4 : 1.15,
        ),
        itemBuilder: (context, index) {
          return Card(
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: Container(color: Colors.white)),
                Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 140.w, height: 16.h, color: Colors.white),
                      SizedBox(height: 8.h),
                      Container(width: 200.w, height: 12.h, color: Colors.white),
                      SizedBox(height: 12.h),
                      const Divider(),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: List.generate(
                              3,
                              (index) => Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: Container(width: 16.w, height: 16.h, color: Colors.white),
                              ),
                            ),
                          ),
                          Container(width: 60.w, height: 20.h, color: Colors.white),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
