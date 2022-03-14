part of 'astro_puzzle_bloc.dart';

abstract class AstroPuzzleEvent extends Equatable {
  const AstroPuzzleEvent();

  @override
  List<Object?> get props => [];
}

class AstroCountdownStarted extends AstroPuzzleEvent {
  const AstroCountdownStarted();
}

class AstroCountdownTicked extends AstroPuzzleEvent {
  const AstroCountdownTicked();
}

class AstroCountdownStopped extends AstroPuzzleEvent {
  const AstroCountdownStopped();
}

class AstroCountdownReset extends AstroPuzzleEvent {
  const AstroCountdownReset({this.secondsToBegin});

  /// The number of seconds to countdown from.
  /// Defaults to [AstroPuzzleBloc.secondsToBegin] if null.
  final int? secondsToBegin;

  @override
  List<Object?> get props => [secondsToBegin];
}
