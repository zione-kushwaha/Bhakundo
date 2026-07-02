import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/team_bloc.dart';
import '../bloc/team_event.dart';
import '../bloc/team_state.dart';
import '../../domain/entities/player.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/team_header_card.dart';
import '../widgets/team_stats_grid.dart';
import '../widgets/player_roster_grid.dart';

class TeamManagementPage extends StatefulWidget {
  const TeamManagementPage({super.key});

  @override
  State<TeamManagementPage> createState() => _TeamManagementPageState();
}

class _TeamManagementPageState extends State<TeamManagementPage> {
  final _playerNameController = TextEditingController();
  final _playerGoalsController = TextEditingController();
  String _selectedRole = 'Forward';

  @override
  void initState() {
    super.initState();
    _loadTeam();
  }

  void _loadTeam() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<TeamBloc>().add(LoadMyTeam(authState.user.uid));
    }
  }

  @override
  void dispose() {
    _playerNameController.dispose();
    _playerGoalsController.dispose();
    super.dispose();
  }

  void _showAddPlayerDialog(String teamId, ThemeData theme) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Player to Roster'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _playerNameController,
              decoration: const InputDecoration(
                hintText: 'Player Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
              items: ['Forward', 'Midfielder', 'Defender', 'Goalkeeper'].map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedRole = val;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _playerGoalsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Goals Scored',
                prefixIcon: Icon(Icons.sports_soccer),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_playerNameController.text.trim().isEmpty) return;
              final goals = int.tryParse(_playerGoalsController.text.trim()) ?? 0;
              
              final randomId = DateTime.now().millisecondsSinceEpoch.toString();
              // Unsplash user dummy photo index based on timestamp
              final avatarIndex = (DateTime.now().second % 4) + 1;
              final avatar = 'https://images.unsplash.com/photo-${1500000000000 + avatarIndex * 100000}?q=80&w=100';

              final newPlayer = Player(
                id: 'p-$randomId',
                name: _playerNameController.text.trim(),
                role: _selectedRole,
                avatarUrl: avatar,
                matchesPlayed: goals > 0 ? goals + 2 : 1,
                goals: goals,
              );

              context.read<TeamBloc>().add(AddPlayer(teamId: teamId, player: newPlayer));
              
              _playerNameController.clear();
              _playerGoalsController.clear();
              Navigator.of(dialogContext).pop();
            },
            child: const Text('ADD PLAYER'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TEAM MANAGEMENT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTeam,
          )
        ],
      ),
      body: BlocBuilder<TeamBloc, TeamState>(
        builder: (context, state) {
          if (state is TeamLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TeamLoaded) {
            final team = state.team;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Team Header Card
                  TeamHeaderCard(team: team),
                  const SizedBox(height: 16),

                  // Stats Dashboard Grid
                  TeamStatsGrid(team: team),
                  const SizedBox(height: 24),

                  // Roster Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TEAM ROSTER',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.person_add, size: 16),
                        label: const Text('ADD PLAYER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        onPressed: () => _showAddPlayerDialog(team.id, theme),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Roster Grid
                  PlayerRosterGrid(roster: team.roster, isTablet: isTablet),
                ],
              ),
            );
          } else if (state is TeamFailure) {
            return Center(
              child: Text('Error loading team: ${state.message}'),
            );
          }
          return const Center(child: Text('No team loaded'));
        },
      ),
    );
  }
}
