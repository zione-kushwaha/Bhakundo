import 'package:equatable/equatable.dart';
import '../../domain/entities/challenge.dart';

abstract class MatchmakingState extends Equatable {
  const MatchmakingState();

  @override
  List<Object?> get props => [];
}

class MatchmakingInitial extends MatchmakingState {}

class MatchmakingLoading extends MatchmakingState {}

class MatchmakingLoaded extends MatchmakingState {
  final List<Challenge> challenges;

  const MatchmakingLoaded(this.challenges);

  @override
  List<Object?> get props => [challenges];
}

class MatchmakingHostingSuccess extends MatchmakingState {}

class MatchmakingAcceptingSuccess extends MatchmakingState {}

class MatchmakingFailure extends MatchmakingState {
  final String message;

  const MatchmakingFailure(this.message);

  @override
  List<Object?> get props => [message];
}
