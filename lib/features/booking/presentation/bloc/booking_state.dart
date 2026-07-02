import 'package:equatable/equatable.dart';
import '../../domain/entities/futsal_court.dart';
import '../../domain/entities/booking_slot.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class CourtsLoaded extends BookingState {
  final List<FutsalCourt> courts;

  const CourtsLoaded(this.courts);

  @override
  List<Object?> get props => [courts];
}

class SlotsLoaded extends BookingState {
  final List<BookingSlot> slots;
  final BookingSlot? selectedSlot;

  const SlotsLoaded({required this.slots, this.selectedSlot});

  @override
  List<Object?> get props => [slots, selectedSlot];
}

class BookingCheckoutInProgress extends BookingState {}

class BookingSuccess extends BookingState {
  final String bookingId;

  const BookingSuccess(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

class BookingFailure extends BookingState {
  final String message;

  const BookingFailure(this.message);

  @override
  List<Object?> get props => [message];
}
