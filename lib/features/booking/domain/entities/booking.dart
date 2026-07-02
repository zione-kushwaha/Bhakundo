import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final String id;
  final String userId;
  final String courtId;
  final String courtName;
  final String courtAddress;
  final String bookingDate; // e.g. "2026-07-03"
  final String startTime;
  final String endTime;
  final double totalAmount;
  final String status; // "Pending", "Confirmed", "Cancelled"
  final String paymentRefId;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.courtId,
    required this.courtName,
    required this.courtAddress,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.totalAmount,
    required this.status,
    required this.paymentRefId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        courtId,
        courtName,
        courtAddress,
        bookingDate,
        startTime,
        endTime,
        totalAmount,
        status,
        paymentRefId,
        createdAt,
      ];
}
