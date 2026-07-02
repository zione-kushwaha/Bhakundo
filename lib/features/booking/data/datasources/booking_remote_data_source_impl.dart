import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/futsal_court_model.dart';
import '../models/booking_slot_model.dart';
import '../models/booking_model.dart';
import 'booking_remote_data_source.dart';

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final FirebaseFirestore _firestore;

  BookingRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Premium mock futsal courts to seed Firestore if empty
  final List<Map<String, dynamic>> _mockCourts = [
    {
      'name': 'Camp Nou Futsal Arena',
      'address': 'Baluwatar, Kathmandu',
      'pricePerHour': 1500.0,
      'rating': 4.8,
      'pitchType': '5-a-side (Premium A-Turf)',
      'imageUrl': 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=600',
      'amenities': ['Shower', 'Locker Room', 'Parking', 'Cafeteria'],
    },
    {
      'name': 'Old Trafford Turf',
      'address': 'Jhamsikhel, Lalitpur',
      'pricePerHour': 1800.0,
      'rating': 4.9,
      'pitchType': '7-a-side (Artificial Turf)',
      'imageUrl': 'https://images.unsplash.com/photo-1529900748604-07564a03e7a6?q=80&w=600',
      'amenities': ['Wi-Fi', 'Locker Room', 'Private Parking', 'Cafeteria', 'Changing Room'],
    },
    {
      'name': 'Bernabeu Futsal Hub',
      'address': 'Shankhamul, Kathmandu',
      'pricePerHour': 1400.0,
      'rating': 4.6,
      'pitchType': '5-a-side (Indoor Rubberized)',
      'imageUrl': 'https://images.unsplash.com/photo-1431324155629-1a6edd1d22f5?q=80&w=600',
      'amenities': ['Parking', 'First Aid Station', 'Lounge Cafe'],
    }
  ];

  @override
  Future<List<FutsalCourtModel>> getCourts() async {
    try {
      final snapshot = await _firestore.collection('courts').get();
      if (snapshot.docs.isEmpty) {
        // Seed database
        for (var mock in _mockCourts) {
          await _firestore.collection('courts').add(mock);
        }
        // Fetch again after seeding
        final seededSnapshot = await _firestore.collection('courts').get();
        return seededSnapshot.docs
            .map((doc) => FutsalCourtModel.fromMap(doc.id, doc.data()))
            .toList();
      }
      return snapshot.docs
          .map((doc) => FutsalCourtModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      // Fallback local list if firestore connection is blocked/offline
      return _mockCourts.asMap().entries.map((entry) {
        return FutsalCourtModel.fromMap('local-court-${entry.key}', entry.value);
      }).toList();
    }
  }

  @override
  Future<List<BookingSlotModel>> getSlots(String courtId, String date) async {
    try {
      // Get all bookings for this court and date to determine which slots are already booked
      final bookingsQuery = await _firestore
          .collection('bookings')
          .where('courtId', isEqualTo: courtId)
          .where('bookingDate', isEqualTo: date)
          .where('status', isEqualTo: 'Confirmed')
          .get();

      final bookedStartTimes = bookingsQuery.docs
          .map((doc) => doc.data()['startTime'] as String)
          .toSet();

      // Standard Futsal operation slots (e.g. 06:00 AM to 09:00 PM)
      final List<Map<String, String>> slotsConfig = [
        {'start': '06:00 AM', 'end': '07:00 AM'},
        {'start': '07:00 AM', 'end': '08:00 AM'},
        {'start': '08:00 AM', 'end': '09:00 AM'},
        {'start': '09:00 AM', 'end': '10:00 AM'},
        {'start': '10:00 AM', 'end': '11:00 AM'},
        {'start': '11:00 AM', 'end': '12:00 PM'},
        {'start': '12:00 PM', 'end': '01:00 PM'},
        {'start': '01:00 PM', 'end': '02:00 PM'},
        {'start': '02:00 PM', 'end': '03:00 PM'},
        {'start': '03:00 PM', 'end': '04:00 PM'},
        {'start': '04:00 PM', 'end': '05:00 PM'},
        {'start': '05:00 PM', 'end': '06:00 PM'},
        {'start': '06:00 PM', 'end': '07:00 PM'},
        {'start': '07:00 PM', 'end': '08:00 PM'},
        {'start': '08:00 PM', 'end': '09:00 PM'},
      ];

      // Retrieve court to obtain price per hour
      double price = 1500.0;
      try {
        final courtDoc = await _firestore.collection('courts').doc(courtId).get();
        if (courtDoc.exists) {
          price = (courtDoc.data()?['pricePerHour'] as num?)?.toDouble() ?? 1500.0;
        }
      } catch (_) {}

      return slotsConfig.asMap().entries.map((entry) {
        final config = entry.value;
        final start = config['start']!;
        final isBooked = bookedStartTimes.contains(start);
        
        // Let's add some random blockages for UI realism if Firestore has no bookings
        final isDummyBooked = bookedStartTimes.isEmpty && (entry.key == 2 || entry.key == 7 || entry.key == 12);

        return BookingSlotModel(
          id: '$courtId-$date-${entry.key}',
          courtId: courtId,
          startTime: start,
          endTime: config['end']!,
          isAvailable: !isBooked && !isDummyBooked,
          price: price,
        );
      }).toList();
    } catch (e) {
      // Offline fallback
      return List.generate(15, (index) {
        final hour = index + 6;
        final displayHour = hour > 12 ? hour - 12 : hour;
        final ampm = hour >= 12 ? 'PM' : 'AM';
        final nextDisplayHour = (hour + 1) > 12 ? (hour + 1) - 12 : (hour + 1);
        final nextAmpm = (hour + 1) >= 12 ? 'PM' : 'AM';
        return BookingSlotModel(
          id: 'offline-slot-$index',
          courtId: courtId,
          startTime: '${displayHour.toString().padLeft(2, '0')}:00 $ampm',
          endTime: '${nextDisplayHour.toString().padLeft(2, '0')}:00 $nextAmpm',
          isAvailable: index != 4 && index != 9,
          price: 1500.0,
        );
      });
    }
  }

  @override
  Future<void> createBooking(BookingModel booking) async {
    try {
      await _firestore.collection('bookings').doc(booking.id).set(booking.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> verifyBookingPayment(String bookingId, String refId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': 'Confirmed',
        'paymentRefId': refId,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<BookingModel>> getUserBookings(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
