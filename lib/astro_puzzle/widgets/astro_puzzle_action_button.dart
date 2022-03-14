import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:slide_puzzle/astro_puzzle/bloc/bloc.dart';
import 'package:slide_puzzle/audio_control/audio_control.dart';
import 'package:slide_puzzle/colors/colors.dart';
import 'package:slide_puzzle/helpers/helpers.dart';
import 'package:slide_puzzle/puzzle/puzzle.dart';
import 'package:slide_puzzle/theme/theme.dart';
import 'package:slide_puzzle/timer/timer.dart';

/// {@template astro_puzzle_action_button}
/// Displays the action button to start or shuffle the puzzle
/// based on the current puzzle state.
/// {@endtemplate}
class AstroPuzzleActionButton extends StatefulWidget {
  /// {@macro astro_puzzle_action_button}
  const AstroPuzzleActionButton({Key? key, AudioPlayerFactory? audioPlayer})
      : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<AstroPuzzleActionButton> createState() =>
      _AstroPuzzleActionButtonState();
}

class _AstroPuzzleActionButtonState extends State<AstroPuzzleActionButton> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget._audioPlayerFactory()
      ..setAsset('assets/audio/click.mp3');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = context.select((AstroPuzzleBloc bloc) => bloc.state.status);
    final isLoading = status == AstroPuzzleStatus.loading;
    final isStarted = status == AstroPuzzleStatus.started;

    final text =
        isStarted ? 'Restart' : (isLoading ? 'Get Ready...' : 'Start Game');

    return AudioControlListener(
      audioPlayer: _audioPlayer,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Tooltip(
          key: ValueKey(status),
          message:
              isStarted ? 'Restarting the puzzle will reset your score' : '',
          verticalOffset: 40,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              // boxShadow: [
              //   BoxShadow(
              //     color: PuzzleColors.red.withOpacity(0.6),
              //     spreadRadius: 1,
              //     blurRadius: 16,
              //     offset: const Offset(-8, 0),
              //   ),
              //   BoxShadow(
              //     color: PuzzleColors.red.withOpacity(0.6),
              //     spreadRadius: 1,
              //     blurRadius: 16,
              //     offset: const Offset(8, 0),
              //   ),
              //   BoxShadow(
              //     color: PuzzleColors.red.withOpacity(0.2),
              //     spreadRadius: 16,
              //     blurRadius: 32,
              //     offset: const Offset(-8, 0),
              //   ),
              //   BoxShadow(
              //     color: PuzzleColors.red.withOpacity(0.2),
              //     spreadRadius: 16,
              //     blurRadius: 32,
              //     offset: const Offset(8, 0),
              //   ),
              // ],
            ),
            child: PuzzleButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final hasStarted = status == AstroPuzzleStatus.started;

                      // Reset the timer and the countdown.
                      context.read<TimerBloc>().add(const TimerReset());
                      context.read<TextBoxBloc>().add(const ClearScreen());
                      context.read<AstroPuzzleBloc>().add(
                            AstroCountdownReset(
                              secondsToBegin: hasStarted ? 5 : 3,
                            ),
                          );

                      // Initialize the puzzle board to show the initial puzzle
                      // (unshuffled) before the countdown completes.
                      if (hasStarted) {
                        context.read<PuzzleBloc>().add(
                              const PuzzleInitialized(shufflePuzzle: false),
                            );
                      }

                      unawaited(_audioPlayer.replay());
                    },
              textColor: isLoading ? PuzzleColors.white2 : Colors.white,
              child: Text(text),
            ),
          ),
        ),
      ),
    );
  }
}
