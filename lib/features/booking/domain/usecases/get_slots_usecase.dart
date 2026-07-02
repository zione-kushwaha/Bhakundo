import '../entities/booking_slot.dart';
import '../repositories/booking_repository.dart';

class GetSlotsUseCase {
  final BookingRepository _repository;

  GetSlotsUseCase(this._repository);

  Future<List<BookingSlot>> execute(String courtId, String date) {
    return _repository.getSlots(courtId, date);
  }
}
