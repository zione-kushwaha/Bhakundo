import 'package:flutter/material.dart';
import '../../domain/entities/futsal_court.dart';

class CourtCard extends StatelessWidget {
  final FutsalCourt court;
  final VoidCallback onTap;

  const CourtCard({
    super.key,
    required this.court,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Court Image with Rating
            Expanded(
              child: Stack(
                children: [
                  Image.network(
                    court.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: theme.scaffoldBackgroundColor,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: theme.primaryColor.withValues(alpha: 0.05),
                      child: Icon(Icons.image_not_supported_outlined, color: theme.primaryColor),
                    ),
                  ),
                  // Rating Badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            court.rating.toString(),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Pitch Type Badge
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        court.pitchType.toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Court Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    court.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          court.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Amenities
                      Row(
                        children: court.amenities.take(3).map((amenity) {
                          IconData icon = Icons.circle;
                          if (amenity.toLowerCase().contains('shower')) icon = Icons.shower_outlined;
                          if (amenity.toLowerCase().contains('locker')) icon = Icons.lock_outline;
                          if (amenity.toLowerCase().contains('parking')) icon = Icons.local_parking;
                          if (amenity.toLowerCase().contains('cafe')) icon = Icons.local_cafe_outlined;
                          if (amenity.toLowerCase().contains('wifi')) icon = Icons.wifi;

                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Tooltip(
                              message: amenity,
                              child: Icon(icon, size: 16, color: theme.primaryColor.withValues(alpha: 0.6)),
                            ),
                          );
                        }).toList(),
                      ),
                      // Price details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'NPR ${court.pricePerHour.toInt()}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'per hour',
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 9),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
