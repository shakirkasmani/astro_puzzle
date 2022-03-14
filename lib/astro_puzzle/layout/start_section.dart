import 'package:flutter/material.dart';
import 'package:slide_puzzle/astro_puzzle/widgets/astro_puzzle_action_button.dart';
import 'package:slide_puzzle/astro_puzzle/widgets/astro_puzzle_logo.dart';
import 'package:slide_puzzle/astro_puzzle/widgets/astro_hint_toggle.dart';
import 'package:slide_puzzle/audio_control/audio_control.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/puzzle/puzzle.dart';

/// {@template astro_start_section}
/// Displays the start section of the puzzle based on [state].
/// {@endtemplate}
class AstroStartSection extends StatelessWidget {
  /// {@macro Astro_start_section}
  const AstroStartSection({
    Key? key,
    required this.state,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        return Column(
          crossAxisAlignment: currentSize == ResponsiveLayoutSize.large
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            const ResponsiveGap(
              small: 10,
              medium: 12,
            ),
            SizedBox.square(
              dimension: currentSize == ResponsiveLayoutSize.large ? 250 : 150,
              child: const AstroPuzzleLogo(),
            ),
            const ResponsiveGap(
              // small: 12,
              large: 150,
            ),
            ResponsiveLayoutBuilder(
              small: (_, __) => const SizedBox(),
              medium: (_, __) => const SizedBox(),
              large: (_, __) => Column(
                children: [
                  const Center(child: AstroPuzzleActionButton()),
                  const ResponsiveGap(
                    large: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      AudioControl(),
                      AstroHintToggle(),
                    ],
                  ),
                  const ResponsiveGap(
                    large: 32,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
