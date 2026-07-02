import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../../domain/entities/futsal_court.dart';
import '../../domain/entities/booking_slot.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/date_selector_list.dart';
import '../widgets/time_slot_grid.dart';
import '../../../../core/widgets/custom_snackbar.dart';

class CourtDetailPage extends StatefulWidget {
  final String courtId;

  const CourtDetailPage({super.key, required this.courtId});

  @override
  State<CourtDetailPage> createState() => _CourtDetailPageState();
}

class _CourtDetailPageState extends State<CourtDetailPage> {
  late DateTime _selectedDate;
  final List<DateTime> _dates = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    for (int i = 0; i < 7; i++) {
      _dates.add(DateTime.now().add(Duration(days: i)));
    }
    _loadSlots();
  }

  void _loadSlots() {
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    context.read<BookingBloc>().add(LoadSlots(courtId: widget.courtId, date: dateStr));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final FutsalCourt court;
    final blocState = context.read<BookingBloc>().state;
    if (blocState is CourtsLoaded) {
      court = blocState.courts.firstWhere(
        (c) => c.id == widget.courtId,
        orElse: () => _getFallbackCourt(),
      );
    } else {
      court = _getFallbackCourt();
    }

    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        final isLoading = state is BookingCheckoutInProgress;

        return Scaffold(
          body: BlocListener<BookingBloc, BookingState>(
            listener: (context, state) {
              if (state is BookingSuccess) {
                _showSuccessDialog(state.bookingId);
              } else if (state is BookingFailure) {
                CustomSnackbar.show(context, state.message, isError: true);
              }
            },
            child: LoadingOverlay(
              isLoading: isLoading,
              message: 'Contacting eSewa Secure Sandbox...',
              child: Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          expandedHeight: size.height * 0.25,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Image.network(
                              court.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(color: AppColors.primary),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.black45,
                            radius: 20.r,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white, size: 20.r),
                              onPressed: () => context.pop(),
                            ),
                          ),
                        ),

                        SliverList(
                          delegate: SliverChildListDelegate([
                            Padding(
                              padding: EdgeInsets.all(16.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          court.name,
                                          style: theme.textTheme.displaySmall?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20.sp,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                        child: Text(
                                          court.pitchType,
                                          style: theme.textTheme.labelMedium?.copyWith(
                                            color: AppColors.secondary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 16.r, color: Colors.grey),
                                      SizedBox(width: 4.w),
                                      Text(
                                        court.address,
                                        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  const Divider(),
                                  SizedBox(height: 16.h),

                                  Text(
                                    'SELECT DATE',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  _buildDateList(),

                                  SizedBox(height: 24.h),
                                  
                                  Text(
                                    'AVAILABLE SLOTS',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),

                                  BlocBuilder<BookingBloc, BookingState>(
                                    builder: (context, state) {
                                      if (state is BookingLoading) {
                                        return Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(32.r),
                                            child: const CircularProgressIndicator(),
                                          ),
                                        );
                                      } else if (state is SlotsLoaded) {
                                        final slots = state.slots;
                                        final selected = state.selectedSlot;
                                        return _buildTimeSlotsGrid(slots, selected);
                                      } else if (state is BookingFailure) {
                                        return Center(
                                          child: Text(
                                            'Failed to load slots: ${state.message}',
                                            style: TextStyle(fontSize: 12.sp),
                                          ),
                                        );
                                      }
                                      return Center(
                                        child: Text(
                                          'Select a date to view slots',
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  _buildCheckoutPanel(court, theme),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateList() {
    return DateSelectorList(
      dates: _dates,
      selectedDate: _selectedDate,
      onDateSelected: (date) {
        setState(() {
          _selectedDate = date;
        });
        _loadSlots();
      },
    );
  }

  Widget _buildTimeSlotsGrid(List<BookingSlot> slots, BookingSlot? selectedSlot) {
    return TimeSlotGrid(
      slots: slots,
      selectedSlot: selectedSlot,
      onSlotSelected: (slot) {
        context.read<BookingBloc>().add(SelectSlot(slot));
      },
    );
  }

  Widget _buildCheckoutPanel(FutsalCourt court, ThemeData theme) {
    final blocState = context.watch<BookingBloc>().state;
    BookingSlot? selectedSlot;
    if (blocState is SlotsLoaded) {
      selectedSlot = blocState.selectedSlot;
    }

    if (selectedSlot == null) {
      return Container(
        padding: EdgeInsets.all(16.r),
        color: theme.cardColor,
        child: SafeArea(
          child: Text(
            'Select a time slot to proceed',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              fontSize: 12.sp,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, -5.h),
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Slot',
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10.sp),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${DateFormat('d MMM').format(_selectedDate)} | ${selectedSlot.startTime}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'NPR ${selectedSlot.price.toInt()}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            CustomButton(
              width: 160.w,
              text: 'BOOK WITH eSEWA',
              onPressed: () {
                final authState = context.read<AuthBloc>().state;
                String userId = 'guest-user';
                if (authState is Authenticated) {
                  userId = authState.user.uid;
                }
                
                context.read<BookingBloc>().add(
                  CheckoutBooking(
                    court: court,
                    date: DateFormat('yyyy-MM-dd').format(_selectedDate),
                    userId: userId,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  FutsalCourt _getFallbackCourt() {
    return FutsalCourt(
      id: widget.courtId,
      name: 'Bhakundo Premium Court',
      imageUrl: 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=600',
      address: 'Kathmandu, Nepal',
      pricePerHour: 1500.0,
      rating: 4.8,
      pitchType: '5-a-side Turf',
      amenities: const ['Shower', 'Parking', 'Cafeteria'],
    );
  }

  void _showSuccessDialog(String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success),
            SizedBox(width: 8.w),
            Text(
              'Booking Confirmed',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Your court has been reserved successfully!\n\nBooking ID: $bookingId\n\nVerify with your ticket on the ground.',
          style: TextStyle(fontSize: 13.sp),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/booking');
            },
            child: Text(
              'GREAT',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
