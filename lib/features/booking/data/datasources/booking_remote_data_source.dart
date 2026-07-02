import '../models/futsal_court_model.dart';
import '../models/booking_slot_model.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<List<FutsalCourtModel>> getCourts();
  Future<List<BookingSlotModel>> getSlots(String courtId, String date);
  Future<void> createBooking(BookingModel booking);
  Future<bool> verifyBookingPayment(String bookingId, String refId);
  Future<List<BookingModel>> getUserBookings(String userId);
}
