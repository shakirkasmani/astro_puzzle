import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slide_puzzle/audio_control/audio_control.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/theme/theme.dart';

/// {@template audio_control}
/// Displays and allows to update the current audio status of the puzzle.
/// {@endtemplate}
class AudioControl extends StatelessWidget {
  /// {@macro audio_control}
  const AudioControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioMuted =
        context.select((AudioControlBloc bloc) => bloc.state.muted);
    final audioAsset = audioMuted
        ? 'assets/images/sound_off.png'
        : 'assets/images/sound_on.png';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.read<AudioControlBloc>().add(AudioToggled()),
        child: AnimatedSwitcher(
          duration: PuzzleThemeAnimationDuration.backgroundColorChange,
          child: ResponsiveLayoutBuilder(
            key: Key(audioAsset),
            small: (_, __) => Image.asset(
              audioAsset,
              key: const Key('audio_control_small'),
              width: 50,
              height: 50,
            ),
            medium: (_, __) => Image.asset(
              audioAsset,
              key: const Key('audio_control_medium'),
              width: 80,
              height: 80,
            ),
            large: (_, __) => Image.asset(
              audioAsset,
              key: const Key('audio_control_large'),
              width: 80,
              height: 80,
            ),
          ),
        ),
      ),
    );
  }
}
