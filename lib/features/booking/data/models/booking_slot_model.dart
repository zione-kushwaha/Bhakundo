import '../../domain/entities/booking_slot.dart';

class BookingSlotModel extends BookingSlot {
  const BookingSlotModel({
    required super.id,
    required super.courtId,
    required super.startTime,
    required super.endTime,
    required super.isAvailable,
    required super.price,
  });

  factory BookingSlotModel.fromMap(String id, Map<String, dynamic> map) {
    return BookingSlotModel(
      id: id,
      courtId: map['courtId'] as String? ?? '',
      startTime: map['startTime'] as String? ?? '',
      endTime: map['endTime'] as String? ?? '',
      isAvailable: map['isAvailable'] as bool? ?? true,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courtId': courtId,
      'startTime': startTime,
      'endTime': endTime,
      'isAvailable': isAvailable,
      'price': price,
    };
  }
}
