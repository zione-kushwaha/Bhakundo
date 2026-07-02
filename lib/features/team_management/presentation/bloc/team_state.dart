import 'package:equatable/equatable.dart';
import '../../domain/entities/team.dart';

abstract class TeamState extends Equatable {
  const TeamState();

  @override
  List<Object?> get props => [];
}

class TeamInitial extends TeamState {}

class TeamLoading extends TeamState {}

class TeamLoaded extends TeamState {
  final Team team;

  const TeamLoaded(this.team);

  @override
  List<Object?> get props => [team];
}

class NoTeamFound extends TeamState {}

class TeamFailure extends TeamState {
  final String message;

  const TeamFailure(this.message);

  @override
  List<Object?> get props => [message];
}
