import '../entities/challenge.dart';
import '../repositories/matchmaking_repository.dart';

class HostChallengeUseCase {
  final MatchmakingRepository _repository;

  HostChallengeUseCase(this._repository);

  Future<void> execute(Challenge challenge) {
    return _repository.hostChallenge(challenge);
  }
}
