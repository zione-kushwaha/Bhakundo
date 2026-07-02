import '../entities/player.dart';
import '../repositories/team_repository.dart';

class AddPlayerToTeamUseCase {
  final TeamRepository _repository;

  AddPlayerToTeamUseCase(this._repository);

  Future<void> execute(String teamId, Player player) {
    return _repository.addPlayerToTeam(teamId, player);
  }
}
