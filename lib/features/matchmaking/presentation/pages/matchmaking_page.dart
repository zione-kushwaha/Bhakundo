import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/matchmaking_bloc.dart';
import '../bloc/matchmaking_event.dart';
import '../bloc/matchmaking_state.dart';
import '../../domain/entities/challenge.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/challenge_card.dart';
import '../widgets/host_challenge_sheet.dart';
import '../../../../core/widgets/custom_snackbar.dart';

class MatchmakingPage extends StatefulWidget {
  const MatchmakingPage({super.key});

  @override
  State<MatchmakingPage> createState() => _MatchmakingPageState();
}

class _MatchmakingPageState extends State<MatchmakingPage> {
  @override
  void initState() {
    super.initState();
    context.read<MatchmakingBloc>().add(LoadOpenChallenges());
  }

  void _showHostChallengeDialog(ThemeData theme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (bottomSheetContext) {
        return HostChallengeSheet(
          onSubmit: (teamName, venue, date, time) {
            final authState = context.read<AuthBloc>().state;
            String captain = 'Captain';
            if (authState is Authenticated) {
              captain = authState.user.displayName;
            }

            final newChallenge = Challenge(
              id: 'CH-${DateTime.now().millisecondsSinceEpoch}',
              hostTeamId: 'team-${DateTime.now().millisecondsSinceEpoch}',
              hostTeamName: teamName,
              hostCaptainName: captain,
              venueName: venue,
              matchDate: DateFormat('yyyy-MM-dd').format(date),
              matchTime: time,
              status: 'Waiting',
              opponentTeamId: '',
              opponentTeamName: '',
              createdAt: DateTime.now(),
            );

            context.read<MatchmakingBloc>().add(HostNewChallenge(newChallenge));
            Navigator.of(bottomSheetContext).pop();
            CustomSnackbar.show(context, 'Challenge posted to pool!', isSuccess: true);
          },
        );
      },
    );
  }

  void _showAcceptDialog(Challenge challenge, ThemeData theme) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Accept ${challenge.hostTeamName}\'s Challenge',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter your team name to confirm the match booking split:',
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              controller: controller,
              hintText: 'Opponent Team Name',
              prefixIcon: Icons.shield_outlined,
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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
            ),
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              context.read<MatchmakingBloc>().add(
                    AcceptMatchChallenge(
                      challengeId: challenge.id,
                      opponentTeamId: 'opp-team-${DateTime.now().millisecondsSinceEpoch}',
                      opponentTeamName: controller.text.trim(),
                    ),
                  );
              Navigator.of(dialogContext).pop();
              CustomSnackbar.show(context, 'Match accepted and locked!', isSuccess: true);
            },
            child: Text(
              'CONFIRM MATCH',
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
        title: const Text('MATCHMAKING POOL'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<MatchmakingBloc>().add(LoadOpenChallenges()),
          )
        ],
      ),
      body: BlocBuilder<MatchmakingBloc, MatchmakingState>(
        builder: (context, state) {
          if (state is MatchmakingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MatchmakingLoaded) {
            final challenges = state.challenges;
            if (challenges.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, size: 64.r, color: AppColors.primary.withValues(alpha: 0.5)),
                    SizedBox(height: 16.h),
                    Text(
                      'Waiting Pool is empty.',
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 14.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Host a challenge to invite local teams!',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 11.sp),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Quick info bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  color: AppColors.primary.withValues(alpha: 0.05),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 16.r, color: AppColors.primary),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Waiting pool shows teams looking for opponents. You can accept a challenge to organize a match instantly.',
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 10.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildChallengesList(challenges, isTablet, theme),
                ),
              ],
            );
          } else if (state is MatchmakingFailure) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: TextStyle(fontSize: 12.sp),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => _showHostChallengeDialog(theme),
        icon: Icon(Icons.add, size: 20.r),
        label: Text(
          'HOST CHALLENGE',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
        ),
      ),
    );
  }

  Widget _buildChallengesList(List<Challenge> challenges, bool isTablet, ThemeData theme) {
    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return ChallengeCard(
          challenge: challenge,
          onAccept: () => _showAcceptDialog(challenge, theme),
        );
      },
    );
  }
}
