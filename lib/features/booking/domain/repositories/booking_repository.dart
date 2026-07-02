import '../entities/futsal_court.dart';
import '../entities/booking_slot.dart';
import '../entities/booking.dart';

abstract class BookingRepository {
  Future<List<FutsalCourt>> getCourts();
  Future<List<BookingSlot>> getSlots(String courtId, String date);
  Future<void> createBooking(Booking booking);
  Future<bool> verifyBookingPayment(String bookingId, String refId);
  Future<List<Booking>> getUserBookings(String userId);
}
