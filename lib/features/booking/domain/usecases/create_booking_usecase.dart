import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class CreateBookingUseCase {
  final BookingRepository _repository;

  CreateBookingUseCase(this._repository);

  Future<void> execute(Booking booking) {
    return _repository.createBooking(booking);
  }
}
