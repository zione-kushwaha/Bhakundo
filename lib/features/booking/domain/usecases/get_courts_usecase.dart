import '../entities/futsal_court.dart';
import '../repositories/booking_repository.dart';

class GetCourtsUseCase {
  final BookingRepository _repository;

  GetCourtsUseCase(this._repository);

  Future<List<FutsalCourt>> execute() {
    return _repository.getCourts();
  }
}
