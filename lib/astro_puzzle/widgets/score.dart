import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:slide_puzzle/astro_puzzle/astro.dart';
import 'package:slide_puzzle/colors/colors.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/theme/theme.dart';
import 'package:slide_puzzle/typography/typography.dart';

/// {@template dashatar_score}
/// Displays the score of the solved Dashatar puzzle.
/// {@endtemplate}
class AstroScore extends StatelessWidget {
  /// {@macro dashatar_score}
  const AstroScore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final height = currentSize == ResponsiveLayoutSize.large
            ? 500.0
            : (currentSize == ResponsiveLayoutSize.medium ? 425.0 : 350.0);

        final textStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.headline5
            : PuzzleTextStyle.headline4;

        final imageOffset = currentSize == ResponsiveLayoutSize.large
            ? -92.0
            : (currentSize == ResponsiveLayoutSize.medium ? -140.0 : -21.0);
        final flagSize =
            currentSize == ResponsiveLayoutSize.large ? 250.0 : 150.0;

        return ClipRRect(
          key: const Key('dashatar_score'),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            height: height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF272048),
                  Color(0xFF322958),
                ],
              ),
            ),
            child: Stack(
              children: [
                const Align(
                    alignment: Alignment(0, -0.7),
                    child: SizedBox(
                      width: double.infinity,
                      child: Moonshot(),
                    )),
                Positioned(
                  bottom: imageOffset,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/moon_surface.png',
                    width: double.infinity,
                  ),
                ),
                const Dashtronaut(
                  alignment: Alignment(-0.92, 0.5),
                  isSuccessScreen: true,
                ),
                Align(
                  alignment: const Alignment(0.92, 0.5),
                  child: SizedBox.square(
                    dimension: flagSize,
                    child: const AstroFlutterFlag(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ResponsiveGap(
                        small: 24,
                      ),
                      Row(
                        children: [
                          const Expanded(
                            flex: 5,
                            child: AstroPuzzleLogo(),
                          ),
                          const Gap(10),
                          Expanded(
                            flex: 10,
                            child: Column(
                              children: [
                                AnimatedText(
                                  text: 'Mission Accomplished',
                                  style: textStyle.copyWith(
                                    color: PuzzleColors.white,
                                  ),
                                  repeat: true,
                                ),
                                const ResponsiveGap(
                                  small: 8,
                                  medium: 16,
                                  large: 16,
                                ),
                                AnimatedDefaultTextStyle(
                                  key: const Key('dashatar_score_well_done'),
                                  style: textStyle.copyWith(
                                    color: PuzzleColors.white,
                                  ),
                                  duration:
                                      PuzzleThemeAnimationDuration.textStyle,
                                  child: const Text(
                                      'Well Done, Congrats! \n You just had a'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const ResponsiveGap(
                        small: 24,
                        medium: 32,
                        large: 32,
                      ),
                      const Spacer(),
                      AnimatedDefaultTextStyle(
                        key: const Key('dashatar_score_score'),
                        style: PuzzleTextStyle.headline5.copyWith(
                          color: PuzzleColors.black,
                        ),
                        duration: PuzzleThemeAnimationDuration.textStyle,
                        child: const Text('Score'),
                      ),
                      const ResponsiveGap(
                        small: 8,
                        medium: 9,
                        large: 9,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          AstroTimer(),
                          Gap(10),
                          AstroMoveCount(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
