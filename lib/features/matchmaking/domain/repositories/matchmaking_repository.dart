import '../entities/challenge.dart';

abstract class MatchmakingRepository {
  Future<List<Challenge>> getOpenChallenges();
  Future<void> hostChallenge(Challenge challenge);
  Future<void> acceptChallenge(String challengeId, String opponentTeamId, String opponentTeamName);
}
