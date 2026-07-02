import 'package:flutter/material.dart';
import '../../domain/entities/team.dart';

class TeamHeaderCard extends StatelessWidget {
  final Team team;

  const TeamHeaderCard({
    super.key,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.05),
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=150',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.name.toUpperCase(),
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Captain: ${team.captainName}',
                    style: theme.textTheme.bodyMedium,
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
