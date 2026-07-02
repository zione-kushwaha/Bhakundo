import 'package:equatable/equatable.dart';
import '../../domain/entities/team.dart';
import '../../domain/entities/player.dart';

abstract class TeamEvent extends Equatable {
  const TeamEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyTeam extends TeamEvent {
  final String captainId;

  const LoadMyTeam(this.captainId);

  @override
  List<Object?> get props => [captainId];
}

class CreateNewTeam extends TeamEvent {
  final Team team;

  const CreateNewTeam(this.team);

  @override
  List<Object?> get props => [team];
}

class AddPlayer extends TeamEvent {
  final String teamId;
  final Player player;

  const AddPlayer({required this.teamId, required this.player});

  @override
  List<Object?> get props => [teamId, player];
}
