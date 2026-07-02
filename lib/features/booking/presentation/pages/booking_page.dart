import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
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
    // Dispatch LoadCourts event when screen initializes
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
                    Icon(Icons.sports_soccer, size: 64, color: theme.colorScheme.secondary.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    Text('No courts available.', style: theme.textTheme.titleMedium),
                  ],
                ),
              );
            }
            return _buildCourtsGrid(courts, isTablet);
          } else if (state is BookingFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.read<BookingBloc>().add(LoadCourts()),
                      child: const Text('RETRY'),
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
      padding: const EdgeInsets.all(16),
      itemCount: courts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 2 : 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
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
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isTablet ? 2 : 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
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
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 140, height: 16, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(width: 200, height: 12, color: Colors.white),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: List.generate(
                              3,
                              (index) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(width: 16, height: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          Container(width: 60, height: 20, color: Colors.white),
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
