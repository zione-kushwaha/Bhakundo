import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
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
        title: Text(
          'Add Player to Roster',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: _playerNameController,
              hintText: 'Player Name',
              prefixIcon: Icons.person_outline,
            ),
            SizedBox(height: 12.h),
            DropdownButtonFormField<String>(
              initialValue: _selectedRole,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              ),
              items: ['Forward', 'Midfielder', 'Defender', 'Goalkeeper'].map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role, style: TextStyle(fontSize: 13.sp)),
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
            SizedBox(height: 12.h),
            CustomTextField(
              controller: _playerGoalsController,
              keyboardType: TextInputType.number,
              hintText: 'Goals Scored',
              prefixIcon: Icons.sports_soccer,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'CANCEL',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
            onPressed: () {
              if (_playerNameController.text.trim().isEmpty) return;
              final goals = int.tryParse(_playerGoalsController.text.trim()) ?? 0;
              
              final randomId = DateTime.now().millisecondsSinceEpoch.toString();
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
            child: Text(
              'ADD PLAYER',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.white),
            ),
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
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TeamHeaderCard(team: team),
                  SizedBox(height: 16.h),

                  TeamStatsGrid(team: team),
                  SizedBox(height: 24.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TEAM ROSTER',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          fontSize: 14.sp,
                        ),
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.person_add, size: 16.r),
                        label: Text(
                          'ADD PLAYER',
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => _showAddPlayerDialog(team.id, theme),
                      )
                    ],
                  ),
                  SizedBox(height: 12.h),

                  PlayerRosterGrid(roster: team.roster, isTablet: isTablet),
                ],
              ),
            );
          } else if (state is TeamFailure) {
            return Center(
              child: Text(
                'Error loading team: ${state.message}',
                style: TextStyle(fontSize: 12.sp),
              ),
            );
          }
          return Center(
            child: Text(
              'No team loaded',
              style: TextStyle(fontSize: 12.sp),
            ),
          );
        },
      ),
    );
  }
}
