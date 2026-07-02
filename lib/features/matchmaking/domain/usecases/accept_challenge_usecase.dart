import '../repositories/matchmaking_repository.dart';

class AcceptChallengeUseCase {
  final MatchmakingRepository _repository;

  AcceptChallengeUseCase(this._repository);

  Future<void> execute(String challengeId, String opponentTeamId, String opponentTeamName) {
    return _repository.acceptChallenge(challengeId, opponentTeamId, opponentTeamName);
  }
}
