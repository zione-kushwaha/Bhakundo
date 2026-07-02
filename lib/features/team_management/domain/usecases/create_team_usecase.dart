import '../entities/team.dart';
import '../repositories/team_repository.dart';

class CreateTeamUseCase {
  final TeamRepository _repository;

  CreateTeamUseCase(this._repository);

  Future<void> execute(Team team) {
    return _repository.createTeam(team);
  }
}
