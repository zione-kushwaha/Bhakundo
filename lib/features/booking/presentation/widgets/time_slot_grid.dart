import 'package:flutter/material.dart';
import '../../domain/entities/booking_slot.dart';

class TimeSlotGrid extends StatelessWidget {
  final List<BookingSlot> slots;
  final BookingSlot? selectedSlot;
  final ValueChanged<BookingSlot> onSlotSelected;

  const TimeSlotGrid({
    super.key,
    required this.slots,
    required this.selectedSlot,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: slots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isSelected = selectedSlot?.id == slot.id;
        final isAvailable = slot.isAvailable;

        Color tileColor;
        Color borderCol;
        Color textCol;

        if (isSelected) {
          tileColor = theme.primaryColor;
          borderCol = theme.primaryColor;
          textCol = Colors.white;
        } else if (!isAvailable) {
          tileColor = Colors.grey.withValues(alpha: 0.1);
          borderCol = Colors.grey.withValues(alpha: 0.2);
          textCol = Colors.grey.withValues(alpha: 0.6);
        } else {
          tileColor = theme.primaryColor.withValues(alpha: 0.03);
          borderCol = theme.primaryColor.withValues(alpha: 0.1);
          textCol = theme.primaryColor;
        }

        return InkWell(
          onTap: isAvailable ? () => onSlotSelected(slot) : null,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderCol),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  slot.startTime,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textCol,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isAvailable ? 'NPR ${slot.price.toInt()}' : 'BOOKED',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontSize: 8,
                    color: isSelected ? Colors.white70 : (isAvailable ? theme.colorScheme.secondary : Colors.grey),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
