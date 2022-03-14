// ignore_for_file: public_member_api_docs

part of 'astro_puzzle_bloc.dart';

/// The status of [AstroPuzzleState].
enum AstroPuzzleStatus {
  /// The puzzle is not started yet.
  notStarted,

  /// The puzzle is loading.
  loading,

  /// The puzzle is started.
  started
}

class AstroPuzzleState extends Equatable {
  const AstroPuzzleState({
    required this.secondsToBegin,
    this.isCountdownRunning = false,
  });

  /// Whether the countdown of this puzzle is currently running.
  final bool isCountdownRunning;

  /// The number of seconds before the puzzle is started.
  final int secondsToBegin;

  /// The status of the current puzzle.
  AstroPuzzleStatus get status => isCountdownRunning && secondsToBegin > 0
      ? AstroPuzzleStatus.loading
      : (secondsToBegin == 0
          ? AstroPuzzleStatus.started
          : AstroPuzzleStatus.notStarted);

  @override
  List<Object> get props => [isCountdownRunning, secondsToBegin];

  AstroPuzzleState copyWith({
    bool? isCountdownRunning,
    int? secondsToBegin,
  }) {
    return AstroPuzzleState(
      isCountdownRunning: isCountdownRunning ?? this.isCountdownRunning,
      secondsToBegin: secondsToBegin ?? this.secondsToBegin,
    );
  }
}
