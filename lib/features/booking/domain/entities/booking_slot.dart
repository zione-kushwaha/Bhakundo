import 'package:equatable/equatable.dart';

class BookingSlot extends Equatable {
  final String id;
  final String courtId;
  final String startTime; // e.g. "07:00 AM"
  final String endTime;   // e.g. "08:00 AM"
  final bool isAvailable;
  final double price;

  const BookingSlot({
    required this.id,
    required this.courtId,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    required this.price,
  });

  @override
  List<Object?> get props => [id, courtId, startTime, endTime, isAvailable, price];
}
