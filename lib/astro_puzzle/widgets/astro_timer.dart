import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:slide_puzzle/colors/colors.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/timer/timer.dart';
import 'package:slide_puzzle/typography/typography.dart';

// {@template Astro_timer}
/// Displays how time elapsed since starting the puzzle.
/// {@endtemplate}
class AstroTimer extends StatelessWidget {
  /// {@macro Astro_timer}
  const AstroTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final secondsElapsed =
        context.select((TimerBloc bloc) => bloc.state.secondsElapsed);

    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final currentTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.headline4
            : PuzzleTextStyle.headline3;

        final timeElapsed = Duration(seconds: secondsElapsed);

        final _padding = currentSize == ResponsiveLayoutSize.small ? 7.0 : 10.0;

        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(_padding),
              decoration: BoxDecoration(
                color: PuzzleColors.gray,
                border: Border.all(width: 5.0, color: PuzzleColors.black),
                borderRadius: BorderRadius.circular(16),
              ),
              child: DefaultTextStyle(
                style: currentTextStyle.copyWith(
                  color: PuzzleColors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TimeSections(value: _getHours(timeElapsed)),
                    const Gap(10),
                    _TimeSections(value: _getMinutes(timeElapsed)),
                    const Gap(10),
                    _TimeSections(value: _getSeconds(timeElapsed)),
                  ],
                ),
              ),
            ),
            const Gap(4),
            Text(
              'TIME',
              style: PuzzleTextStyle.label,
            ),
            const ResponsiveGap(
              large: 10,
            )
          ],
        );
      },
    );
  }

  int _getHours(Duration duration) {
    return duration.inHours;
  }

  int _getMinutes(Duration duration) {
    return duration.inMinutes.remainder(60);
  }

  int _getSeconds(Duration duration) {
    return duration.inSeconds.remainder(60);
  }
}

class _TimeSections extends StatelessWidget {
  const _TimeSections({Key? key, required this.value}) : super(key: key);
  final num value;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PuzzleColors.black,
      child: AnimatedFlipCounter(
        duration: const Duration(seconds: 1),
        value: value,
        wholeDigits: 2, // pass in a value like 2014
      ),
    );
  }
}
