import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/colors/colors.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/puzzle/puzzle.dart';
import 'package:slide_puzzle/typography/typography.dart';

class AstroMoveCount extends StatelessWidget {
  const AstroMoveCount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moves = context.select((PuzzleBloc bloc) => bloc.state.numberOfMoves);

    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final currentTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.headline4
            : PuzzleTextStyle.headline3;

        final _padding = currentSize == ResponsiveLayoutSize.small ? 7.0 : 10.0;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(_padding),
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(width: 5.0, color: Colors.black),
                borderRadius: BorderRadius.circular(16),
              ),
              child: DefaultTextStyle(
                style: currentTextStyle.copyWith(
                  color: PuzzleColors.white,
                ),
                child: _TimeSections(value: moves),
              ),
            ),
            const Gap(4),
            Text(
              'MOVES',
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
}

class _TimeSections extends StatelessWidget {
  const _TimeSections({Key? key, required this.value}) : super(key: key);
  final num value;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: AnimatedFlipCounter(
        duration: const Duration(seconds: 1),
        value: value,
        wholeDigits: 3, // pass in a value like 2014
      ),
    );
  }
}
