import 'package:flutter/material.dart';
import '../../domain/entities/player.dart';

class PlayerRosterGrid extends StatelessWidget {
  final List<Player> roster;
  final bool isTablet;

  const PlayerRosterGrid({
    super.key,
    required this.roster,
    required this.isTablet,
  });

  Widget _buildPlayerStatMini(String title, String value, ThemeData theme) {
    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(fontSize: 7),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: roster.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final player = roster[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(player.avatarUrl),
                  backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                ),
                const SizedBox(height: 8),
                Text(
                  player.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    player.role.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontSize: 8,
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPlayerStatMini('MATCHES', player.matchesPlayed.toString(), theme),
                    _buildPlayerStatMini('GOALS', player.goals.toString(), theme),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
