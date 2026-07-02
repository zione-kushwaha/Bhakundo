import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class GetUserBookingsUseCase {
  final BookingRepository _repository;

  GetUserBookingsUseCase(this._repository);

  Future<List<Booking>> execute(String userId) {
    return _repository.getUserBookings(userId);
  }
}
