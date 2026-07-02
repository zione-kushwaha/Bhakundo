import '../models/challenge_model.dart';

abstract class MatchmakingRemoteDataSource {
  Future<List<ChallengeModel>> getOpenChallenges();
  Future<void> hostChallenge(ChallengeModel challenge);
  Future<void> acceptChallenge(String challengeId, String opponentTeamId, String opponentTeamName);
}
