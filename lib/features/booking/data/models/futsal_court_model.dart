import '../../domain/entities/futsal_court.dart';

class FutsalCourtModel extends FutsalCourt {
  const FutsalCourtModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.address,
    required super.pricePerHour,
    required super.rating,
    required super.pitchType,
    required super.amenities,
  });

  factory FutsalCourtModel.fromMap(String id, Map<String, dynamic> map) {
    return FutsalCourtModel(
      id: id,
      name: map['name'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      address: map['address'] as String? ?? '',
      pricePerHour: (map['pricePerHour'] as num?)?.toDouble() ?? 0.0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      pitchType: map['pitchType'] as String? ?? '',
      amenities: List<String>.from(map['amenities'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'address': address,
      'pricePerHour': pricePerHour,
      'rating': rating,
      'pitchType': pitchType,
      'amenities': amenities,
    };
  }
}
