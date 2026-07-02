import '../../domain/entities/team.dart';
import '../../domain/entities/player.dart';
import '../../domain/repositories/team_repository.dart';
import '../datasources/team_remote_data_source.dart';
import '../models/team_model.dart';
import '../models/player_model.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamRemoteDataSource _remoteDataSource;

  TeamRepositoryImpl(this._remoteDataSource);

  @override
  Future<Team?> getMyTeam(String captainId) async {
    return await _remoteDataSource.getMyTeam(captainId);
  }

  @override
  Future<void> createTeam(Team team) async {
    final model = TeamModel.fromEntity(team);
    await _remoteDataSource.createTeam(model);
  }

  @override
  Future<void> addPlayerToTeam(String teamId, Player player) async {
    final playerModel = PlayerModel.fromEntity(player);
    await _remoteDataSource.addPlayerToTeam(teamId, playerModel);
  }
}
