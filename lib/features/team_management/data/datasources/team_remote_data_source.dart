import '../models/team_model.dart';
import '../models/player_model.dart';

abstract class TeamRemoteDataSource {
  Future<TeamModel?> getMyTeam(String captainId);
  Future<void> createTeam(TeamModel team);
  Future<void> addPlayerToTeam(String teamId, PlayerModel player);
}
