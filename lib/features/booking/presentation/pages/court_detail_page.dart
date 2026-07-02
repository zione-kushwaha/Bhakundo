import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
    // Build next 7 days for the picker
    for (int i = 0; i < 7; i++) {
      _dates.add(DateTime.now().add(Duration(days: i)));
    }
    // Load slots for the initial date
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
    final isTablet = size.width > 600;

    // Retrieve court entity from state or mock fallback
    final FutsalCourt court;
    
    // Find court inside cached list in Bloc
    final blocState = context.read<BookingBloc>().state;
    if (blocState is CourtsLoaded) {
      court = blocState.courts.firstWhere(
        (c) => c.id == widget.courtId,
        orElse: () => _getFallbackCourt(),
      );
    } else {
      court = _getFallbackCourt();
    }

    return Scaffold(
      body: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingCheckoutInProgress) {
            _showLoadingDialog();
          } else {
            // Dismiss loading dialog if open
            if (Navigator.of(context).canPop() && state is! BookingCheckoutInProgress) {
              // Ensure we pop the loading dialog safely
            }
            
            if (state is BookingSuccess) {
              Navigator.of(context).pop(); // dismiss loader
              _showSuccessDialog(state.bookingId);
            } else if (state is BookingFailure) {
              Navigator.of(context).pop(); // dismiss loader
              CustomSnackbar.show(context, state.message, isError: true);
            }
          }
        },
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Beautiful Collapsible Header
                  SliverAppBar(
                    expandedHeight: size.height * 0.25,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        court.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(color: theme.primaryColor),
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.black45,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),

                  // Court info & selector body
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.all(16.0),
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
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    court.pitchType,
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      color: theme.colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(court.address, style: theme.textTheme.bodyMedium),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),

                            // Date Selection Heading
                            Text(
                              'SELECT DATE',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildDateList(theme),

                            const SizedBox(height: 24),
                            
                            // Time Slot Selection Heading
                            Text(
                              'AVAILABLE SLOTS',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Slot Grid View inside List
                            BlocBuilder<BookingBloc, BookingState>(
                              builder: (context, state) {
                                if (state is BookingLoading) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(32.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (state is SlotsLoaded) {
                                  final slots = state.slots;
                                  final selected = state.selectedSlot;
                                  return _buildTimeSlotsGrid(slots, selected, isTablet, theme);
                                } else if (state is BookingFailure) {
                                  return Center(child: Text('Failed to load slots: ${state.message}'));
                                }
                                return const Center(child: Text('Select a date to view slots'));
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            
            // Bottom Checkout panel
            _buildCheckoutPanel(court, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDateList(ThemeData theme) {
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

  Widget _buildTimeSlotsGrid(
    List<BookingSlot> slots,
    BookingSlot? selectedSlot,
    bool isTablet,
    ThemeData theme,
  ) {
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
        padding: const EdgeInsets.all(16),
        color: theme.cardColor,
        child: SafeArea(
          child: Text(
            'Select a time slot to proceed',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
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
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 2),
                Text(
                  '${DateFormat('d MMM').format(_selectedDate)} | ${selectedSlot.startTime}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'NPR ${selectedSlot.price.toInt()}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
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
              child: const Text(
                'BOOK WITH eSEWA',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
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

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 24),
              Expanded(
                child: Text('Contacting eSewa Secure Sandbox...'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Booking Confirmed'),
          ],
        ),
        content: Text(
          'Your court has been reserved successfully!\n\nBooking ID: $bookingId\n\nVerify with your ticket on the ground.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss Dialog
              context.go('/booking'); // Go back to listings
            },
            child: const Text('GREAT'),
          ),
        ],
      ),
    );
  }
}
