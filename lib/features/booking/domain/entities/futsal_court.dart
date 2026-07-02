import 'package:equatable/equatable.dart';

class FutsalCourt extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String address;
  final double pricePerHour;
  final double rating;
  final String pitchType;
  final List<String> amenities;

  const FutsalCourt({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.pricePerHour,
    required this.rating,
    required this.pitchType,
    required this.amenities,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        address,
        pricePerHour,
        rating,
        pitchType,
        amenities,
      ];
}
