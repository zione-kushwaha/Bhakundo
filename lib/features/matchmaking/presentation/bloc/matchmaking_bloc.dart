import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_open_challenges_usecase.dart';
import '../../domain/usecases/host_challenge_usecase.dart';
import '../../domain/usecases/accept_challenge_usecase.dart';
import 'matchmaking_event.dart';
import 'matchmaking_state.dart';

class MatchmakingBloc extends Bloc<MatchmakingEvent, MatchmakingState> {
  final GetOpenChallengesUseCase _getOpenChallengesUseCase;
  final HostChallengeUseCase _hostChallengeUseCase;
  final AcceptChallengeUseCase _acceptChallengeUseCase;

  MatchmakingBloc(
    this._getOpenChallengesUseCase,
    this._hostChallengeUseCase,
    this._acceptChallengeUseCase,
  ) : super(MatchmakingInitial()) {
    on<LoadOpenChallenges>(_onLoadOpenChallenges);
    on<HostNewChallenge>(_onHostNewChallenge);
    on<AcceptMatchChallenge>(_onAcceptMatchChallenge);
  }

  Future<void> _onLoadOpenChallenges(
    LoadOpenChallenges event,
    Emitter<MatchmakingState> emit,
  ) async {
    emit(MatchmakingLoading());
    try {
      final challenges = await _getOpenChallengesUseCase.execute();
      emit(MatchmakingLoaded(challenges));
    } catch (e) {
      emit(MatchmakingFailure('Failed to load challenges: ${e.toString()}'));
    }
  }

  Future<void> _onHostNewChallenge(
    HostNewChallenge event,
    Emitter<MatchmakingState> emit,
  ) async {
    emit(MatchmakingLoading());
    try {
      await _hostChallengeUseCase.execute(event.challenge);
      emit(MatchmakingHostingSuccess());
      // Refresh list
      final challenges = await _getOpenChallengesUseCase.execute();
      emit(MatchmakingLoaded(challenges));
    } catch (e) {
      emit(MatchmakingFailure('Failed to host challenge: ${e.toString()}'));
    }
  }

  Future<void> _onAcceptMatchChallenge(
    AcceptMatchChallenge event,
    Emitter<MatchmakingState> emit,
  ) async {
    emit(MatchmakingLoading());
    try {
      await _acceptChallengeUseCase.execute(
        event.challengeId,
        event.opponentTeamId,
        event.opponentTeamName,
      );
      emit(MatchmakingAcceptingSuccess());
      // Refresh list
      final challenges = await _getOpenChallengesUseCase.execute();
      emit(MatchmakingLoaded(challenges));
    } catch (e) {
      emit(MatchmakingFailure('Failed to accept match: ${e.toString()}'));
    }
  }
}
