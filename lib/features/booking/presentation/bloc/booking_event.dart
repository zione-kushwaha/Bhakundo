import 'package:equatable/equatable.dart';
import '../../domain/entities/booking_slot.dart';
import '../../domain/entities/futsal_court.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class LoadCourts extends BookingEvent {}

class LoadSlots extends BookingEvent {
  final String courtId;
  final String date;

  const LoadSlots({required this.courtId, required this.date});

  @override
  List<Object?> get props => [courtId, date];
}

class SelectSlot extends BookingEvent {
  final BookingSlot slot;

  const SelectSlot(this.slot);

  @override
  List<Object?> get props => [slot];
}

class CheckoutBooking extends BookingEvent {
  final FutsalCourt court;
  final String date;
  final String userId;

  const CheckoutBooking({
    required this.court,
    required this.date,
    required this.userId,
  });

  @override
  List<Object?> get props => [court, date, userId];
}

class VerifyPayment extends BookingEvent {
  final String bookingId;
  final String refId;

  const VerifyPayment({required this.bookingId, required this.refId});

  @override
  List<Object?> get props => [bookingId, refId];
}
