import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_team_usecase.dart';
import '../../domain/usecases/create_team_usecase.dart';
import '../../domain/usecases/add_player_to_team_usecase.dart';
import 'team_event.dart';
import 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final GetMyTeamUseCase _getMyTeamUseCase;
  final CreateTeamUseCase _createTeamUseCase;
  final AddPlayerToTeamUseCase _addPlayerToTeamUseCase;

  TeamBloc(
    this._getMyTeamUseCase,
    this._createTeamUseCase,
    this._addPlayerToTeamUseCase,
  ) : super(TeamInitial()) {
    on<LoadMyTeam>(_onLoadMyTeam);
    on<CreateNewTeam>(_onCreateNewTeam);
    on<AddPlayer>(_onAddPlayer);
  }

  Future<void> _onLoadMyTeam(
    LoadMyTeam event,
    Emitter<TeamState> emit,
  ) async {
    emit(TeamLoading());
    try {
      final team = await _getMyTeamUseCase.execute(event.captainId);
      if (team != null) {
        emit(TeamLoaded(team));
      } else {
        emit(NoTeamFound());
      }
    } catch (e) {
      emit(TeamFailure('Failed to load team: ${e.toString()}'));
    }
  }

  Future<void> _onCreateNewTeam(
    CreateNewTeam event,
    Emitter<TeamState> emit,
  ) async {
    emit(TeamLoading());
    try {
      await _createTeamUseCase.execute(event.team);
      emit(TeamLoaded(event.team));
    } catch (e) {
      emit(TeamFailure('Failed to create team: ${e.toString()}'));
    }
  }

  Future<void> _onAddPlayer(
    AddPlayer event,
    Emitter<TeamState> emit,
  ) async {
    final currentState = state;
    if (currentState is TeamLoaded) {
      emit(TeamLoading());
      try {
        await _addPlayerToTeamUseCase.execute(event.teamId, event.player);
        // Reload team to get the updated roster from database
        final team = await _getMyTeamUseCase.execute(currentState.team.captainId);
        if (team != null) {
          emit(TeamLoaded(team));
        } else {
          emit(NoTeamFound());
        }
      } catch (e) {
        emit(TeamFailure('Failed to add player: ${e.toString()}'));
      }
    }
  }
}
