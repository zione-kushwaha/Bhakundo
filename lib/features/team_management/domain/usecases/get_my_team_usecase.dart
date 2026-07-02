import '../entities/team.dart';
import '../repositories/team_repository.dart';

class GetMyTeamUseCase {
  final TeamRepository _repository;

  GetMyTeamUseCase(this._repository);

  Future<Team?> execute(String captainId) {
    return _repository.getMyTeam(captainId);
  }
}
