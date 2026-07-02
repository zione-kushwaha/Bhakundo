import '../repositories/booking_repository.dart';

class VerifyBookingPaymentUseCase {
  final BookingRepository _repository;

  VerifyBookingPaymentUseCase(this._repository);

  Future<bool> execute(String bookingId, String refId) {
    return _repository.verifyBookingPayment(bookingId, refId);
  }
}
