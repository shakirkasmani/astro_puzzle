import 'package:flutter/material.dart';
import 'package:slide_puzzle/astro_puzzle/astro.dart';
import 'package:slide_puzzle/layout/layout.dart';

class AstroBoardSection extends StatelessWidget {
  const AstroBoardSection({Key? key, required this.tiles}) : super(key: key);

  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 6,
          medium: 15,
          large: 40,
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => const AstroProgressIndicator(isHorizontal: true),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => const SizedBox(),
        ),
        const ResponsiveGap(
          small: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ResponsiveLayoutBuilder(
              small: (_, __) => const SizedBox(),
              medium: (_, __) => const RotatedBox(
                quarterTurns: 3,
                child: AstroProgressIndicator(isHorizontal: false),
              ),
              large: (_, __) => const SizedBox(),
            ),
            AstroPuzzleBoard(tiles: tiles),
            ResponsiveLayoutBuilder(
              small: (_, __) => const SizedBox(),
              medium: (_, __) => const SizedBox(width: 75),
              large: (_, __) => const SizedBox(),
            ),
          ],
        ),
      ],
    );
  }
}
