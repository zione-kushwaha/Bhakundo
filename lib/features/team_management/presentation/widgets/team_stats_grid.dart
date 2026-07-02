import 'package:flutter/material.dart';
import '../../domain/entities/team.dart';

class TeamStatsGrid extends StatelessWidget {
  final Team team;

  const TeamStatsGrid({
    super.key,
    required this.team,
  });

  Widget _buildStatItem(String title, String val, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            val,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final winRate = team.matchesPlayed > 0 ? (team.wins / team.matchesPlayed * 100).toInt() : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Win rate linear indicator
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('WIN RATE', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text('$winRate%', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.secondary)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: team.matchesPlayed > 0 ? team.wins / team.matchesPlayed : 0.0,
                    minHeight: 8,
                    backgroundColor: theme.brightness == Brightness.light ? Colors.grey.shade200 : Colors.grey.shade800,
                    valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.secondary),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Stats grid
        Row(
          children: [
            Expanded(child: _buildStatItem('PLAYED', team.matchesPlayed.toString(), Colors.blueGrey, theme)),
            const SizedBox(width: 8),
            Expanded(child: _buildStatItem('WINS', team.wins.toString(), Colors.green, theme)),
            const SizedBox(width: 8),
            Expanded(child: _buildStatItem('LOSSES', team.losses.toString(), Colors.red, theme)),
            const SizedBox(width: 8),
            Expanded(child: _buildStatItem('DRAWS', team.draws.toString(), Colors.orange, theme)),
          ],
        ),
      ],
    );
  }
}
