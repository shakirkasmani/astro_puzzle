import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:slide_puzzle/models/models.dart';

part 'astro_puzzle_event.dart';
part 'astro_puzzle_state.dart';

/// {@template astro_puzzle_bloc}
/// A bloc responsible for starting the Astro puzzle.
/// {@endtemplate}
class AstroPuzzleBloc extends Bloc<AstroPuzzleEvent, AstroPuzzleState> {
  /// {@macro astro_puzzle_bloc}
  AstroPuzzleBloc({
    required this.secondsToBegin,
    required Ticker ticker,
  })  : _ticker = ticker,
        super(AstroPuzzleState(secondsToBegin: secondsToBegin)) {
    on<AstroCountdownStarted>(_onCountdownStarted);
    on<AstroCountdownTicked>(_onCountdownTicked);
    on<AstroCountdownStopped>(_onCountdownStopped);
    on<AstroCountdownReset>(_onCountdownReset);
  }

  /// The number of seconds before the puzzle is started.
  final int secondsToBegin;

  final Ticker _ticker;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _startTicker() {
    _tickerSubscription?.cancel();
    _tickerSubscription =
        _ticker.tick().listen((_) => add(const AstroCountdownTicked()));
  }

  void _onCountdownStarted(
    AstroCountdownStarted event,
    Emitter<AstroPuzzleState> emit,
  ) {
    _startTicker();
    emit(
      state.copyWith(
        isCountdownRunning: true,
        secondsToBegin: secondsToBegin,
      ),
    );
  }

  void _onCountdownTicked(
    AstroCountdownTicked event,
    Emitter<AstroPuzzleState> emit,
  ) {
    if (state.secondsToBegin == 0) {
      _tickerSubscription?.pause();
      emit(state.copyWith(isCountdownRunning: false));
    } else {
      emit(state.copyWith(secondsToBegin: state.secondsToBegin - 1));
    }
  }

  void _onCountdownStopped(
    AstroCountdownStopped event,
    Emitter<AstroPuzzleState> emit,
  ) {
    _tickerSubscription?.pause();
    emit(
      state.copyWith(
        isCountdownRunning: false,
        secondsToBegin: secondsToBegin,
      ),
    );
  }

  void _onCountdownReset(
    AstroCountdownReset event,
    Emitter<AstroPuzzleState> emit,
  ) {
    _startTicker();
    emit(
      state.copyWith(
        isCountdownRunning: true,
        secondsToBegin: event.secondsToBegin ?? secondsToBegin,
      ),
    );
  }
}
