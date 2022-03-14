import 'package:flutter/material.dart';
import 'package:slide_puzzle/astro_puzzle/astro.dart';
import 'package:slide_puzzle/audio_control/audio_control.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/puzzle/bloc/puzzle_bloc.dart';

class AstroEndSection extends StatelessWidget {
  const AstroEndSection({Key? key, required this.state}) : super(key: key);
  final PuzzleState state;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResponsiveLayoutBuilder(
          small: (_, __) => const EndSection(),
          medium: (_, __) => const EndSection(),
          large: (_, __) => const AstroRadarCountdown(),
        ),
        const ResponsiveGap(
          small: 15,
          medium: 20,
          large: 20,
        ),
      ],
    );
  }
}

class EndSection extends StatelessWidget {
  const EndSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          const ResponsiveGap(
            small: 40,
            medium: 72,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              AstroPuzzleActionButton(),
              AstroTimer(),
              AudioControl(),
              AstroHintToggle(),
            ],
          ),
          const ResponsiveGap(
            small: 10,
            medium: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AstroTextBox(),
              const AstroMoveCount(),
              const AstroRadarCountdown(),
            ],
          ),
        ],
      ),
    );
  }
}
