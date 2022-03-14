import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/astro_puzzle/bloc/hint_bloc.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/theme/theme.dart';

class AstroHintToggle extends StatelessWidget {
  const AstroHintToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final showHint = context.select((HintBloc bloc) => bloc.state.showHint);
    final hintAsset =
        showHint ? 'assets/images/hint_on.png' : 'assets/images/hint_off.png';
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.read<HintBloc>().add(const HintToggleEvent()),
        child: AnimatedSwitcher(
          duration: PuzzleThemeAnimationDuration.backgroundColorChange,
          child: ResponsiveLayoutBuilder(
            key: Key(hintAsset),
            small: (_, __) => Image.asset(
              hintAsset,
              key: const Key('audio_control_small'),
              width: 50,
              height: 50,
            ),
            medium: (_, __) => Image.asset(
              hintAsset,
              key: const Key('audio_control_medium'),
              width: 80,
              height: 80,
            ),
            large: (_, __) => Image.asset(
              hintAsset,
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
