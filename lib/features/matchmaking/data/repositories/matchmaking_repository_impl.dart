import '../../domain/entities/challenge.dart';
import '../../domain/repositories/matchmaking_repository.dart';
import '../datasources/matchmaking_remote_data_source.dart';
import '../models/challenge_model.dart';

class MatchmakingRepositoryImpl implements MatchmakingRepository {
  final MatchmakingRemoteDataSource _remoteDataSource;

  MatchmakingRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Challenge>> getOpenChallenges() async {
    return await _remoteDataSource.getOpenChallenges();
  }

  @override
  Future<void> hostChallenge(Challenge challenge) async {
    final model = ChallengeModel.fromEntity(challenge);
    await _remoteDataSource.hostChallenge(model);
  }

  @override
  Future<void> acceptChallenge(
    String challengeId,
    String opponentTeamId,
    String opponentTeamName,
  ) async {
    await _remoteDataSource.acceptChallenge(challengeId, opponentTeamId, opponentTeamName);
  }
}
