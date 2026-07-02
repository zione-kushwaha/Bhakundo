import '../../domain/entities/futsal_court.dart';
import '../../domain/entities/booking_slot.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;

  BookingRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<FutsalCourt>> getCourts() async {
    return await _remoteDataSource.getCourts();
  }

  @override
  Future<List<BookingSlot>> getSlots(String courtId, String date) async {
    return await _remoteDataSource.getSlots(courtId, date);
  }

  @override
  Future<void> createBooking(Booking booking) async {
    final model = BookingModel.fromEntity(booking);
    await _remoteDataSource.createBooking(model);
  }

  @override
  Future<bool> verifyBookingPayment(String bookingId, String refId) async {
    return await _remoteDataSource.verifyBookingPayment(bookingId, refId);
  }

  @override
  Future<List<Booking>> getUserBookings(String userId) async {
    return await _remoteDataSource.getUserBookings(userId);
  }
}
