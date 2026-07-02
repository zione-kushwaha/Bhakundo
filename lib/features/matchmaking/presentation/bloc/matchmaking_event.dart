import 'package:equatable/equatable.dart';
import '../../domain/entities/challenge.dart';

abstract class MatchmakingEvent extends Equatable {
  const MatchmakingEvent();

  @override
  List<Object?> get props => [];
}

class LoadOpenChallenges extends MatchmakingEvent {}

class HostNewChallenge extends MatchmakingEvent {
  final Challenge challenge;

  const HostNewChallenge(this.challenge);

  @override
  List<Object?> get props => [challenge];
}

class AcceptMatchChallenge extends MatchmakingEvent {
  final String challengeId;
  final String opponentTeamId;
  final String opponentTeamName;

  const AcceptMatchChallenge({
    required this.challengeId,
    required this.opponentTeamId,
    required this.opponentTeamName,
  });

  @override
  List<Object?> get props => [challengeId, opponentTeamId, opponentTeamName];
}
