import '../entities/team.dart';
import '../entities/player.dart';

abstract class TeamRepository {
  Future<Team?> getMyTeam(String captainId);
  Future<void> createTeam(Team team);
  Future<void> addPlayerToTeam(String teamId, Player player);
}
