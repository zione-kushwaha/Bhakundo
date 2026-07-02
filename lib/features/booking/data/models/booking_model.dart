import '../../domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.userId,
    required super.courtId,
    required super.courtName,
    required super.courtAddress,
    required super.bookingDate,
    required super.startTime,
    required super.endTime,
    required super.totalAmount,
    required super.status,
    required super.paymentRefId,
    required super.createdAt,
  });

  factory BookingModel.fromMap(String id, Map<String, dynamic> map) {
    return BookingModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      courtId: map['courtId'] as String? ?? '',
      courtName: map['courtName'] as String? ?? '',
      courtAddress: map['courtAddress'] as String? ?? '',
      bookingDate: map['bookingDate'] as String? ?? '',
      startTime: map['startTime'] as String? ?? '',
      endTime: map['endTime'] as String? ?? '',
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] as String? ?? 'Pending',
      paymentRefId: map['paymentRefId'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'courtId': courtId,
      'courtName': courtName,
      'courtAddress': courtAddress,
      'bookingDate': bookingDate,
      'startTime': startTime,
      'endTime': endTime,
      'totalAmount': totalAmount,
      'status': status,
      'paymentRefId': paymentRefId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BookingModel.fromEntity(Booking entity) {
    return BookingModel(
      id: entity.id,
      userId: entity.userId,
      courtId: entity.courtId,
      courtName: entity.courtName,
      courtAddress: entity.courtAddress,
      bookingDate: entity.bookingDate,
      startTime: entity.startTime,
      endTime: entity.endTime,
      totalAmount: entity.totalAmount,
      status: entity.status,
      paymentRefId: entity.paymentRefId,
      createdAt: entity.createdAt,
    );
  }
}
