import '../entities/challenge.dart';
import '../repositories/matchmaking_repository.dart';

class GetOpenChallengesUseCase {
  final MatchmakingRepository _repository;

  GetOpenChallengesUseCase(this._repository);

  Future<List<Challenge>> execute() {
    return _repository.getOpenChallenges();
  }
}
