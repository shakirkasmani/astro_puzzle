import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/astro_puzzle/bloc/bloc.dart';
import 'package:slide_puzzle/audio_control/widget/widget.dart';
import 'package:slide_puzzle/colors/colors.dart';
import 'package:slide_puzzle/helpers/helpers.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/models/models.dart';
import 'package:slide_puzzle/puzzle/puzzle.dart';
import 'package:slide_puzzle/theme/theme.dart';
import 'package:slide_puzzle/typography/typography.dart';

abstract class _TileSize {
  static double small = 100;
  static double medium = 135;
  static double large = 150;
}

/// {@template astro_puzzle_tile}
/// Displays the puzzle tile associated with [tile]
/// based on the puzzle [state].
/// {@endtemplate}
class AstroPuzzleTile extends StatefulWidget {
  /// {@macro astro_puzzle_tile}
  const AstroPuzzleTile({
    Key? key,
    required this.tile,
    required this.tileFontSize,
    required this.state,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  final double tileFontSize;

  /// The state of the puzzle.
  final PuzzleState state;

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<AstroPuzzleTile> createState() => AstroPuzzleTileState();
}

/// The state of [AstroPuzzleTile].

class AstroPuzzleTileState extends State<AstroPuzzleTile>
    with SingleTickerProviderStateMixin {
  AudioPlayer? _audioPlayer;
  late final Timer _timer;

  /// The controller that drives [_scale] animation.
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: PuzzleThemeAnimationDuration.puzzleTileScale,
    );

    _scale = Tween<double>(begin: 1, end: 0.94).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );

    // Delay the initialization of the audio player for performance reasons,
    // to avoid dropping frames when the theme is changed.
    _timer = Timer(const Duration(seconds: 1), () {
      _audioPlayer = widget._audioPlayerFactory()
        ..setAsset('assets/audio/slide.mp3');
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.state.puzzle.getDimension();
    final showHint = context.select((HintBloc bloc) => bloc.state.showHint);

    final state = context.select((AstroPuzzleBloc bloc) => bloc.state);
    final hasStarted = state.status == AstroPuzzleStatus.started;
    final puzzleIncomplete =
        context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus) ==
            PuzzleStatus.incomplete;

    final movementDuration = state.status == AstroPuzzleStatus.loading
        ? const Duration(milliseconds: 800)
        : const Duration(milliseconds: 370);

    final canPress = hasStarted && puzzleIncomplete;
    return AudioControlListener(
      audioPlayer: _audioPlayer,
      child: AnimatedAlign(
        alignment: FractionalOffset(
          (widget.tile.currentPosition.x - 1) / (size - 1),
          (widget.tile.currentPosition.y - 1) / (size - 1),
        ),
        duration: movementDuration,
        curve: Curves.easeInOut,
        child: ResponsiveLayoutBuilder(
          small: (_, child) => SizedBox.square(
            key: Key('astro_puzzle_tile_small_${widget.tile.value}'),
            dimension: _TileSize.small,
            child: child,
          ),
          medium: (_, child) => SizedBox.square(
            key: Key('astro_puzzle_tile_medium_${widget.tile.value}'),
            dimension: _TileSize.medium,
            child: child,
          ),
          large: (_, child) => SizedBox.square(
            key: Key('astro_puzzle_tile_large_${widget.tile.value}'),
            dimension: _TileSize.large,
            child: child,
          ),
          child: (_) => MouseRegion(
            onEnter: (_) {
              if (canPress) {
                _controller.forward();
              }
            },
            onExit: (_) {
              if (canPress) {
                _controller.reverse();
              }
            },
            child: ScaleTransition(
              key: Key('astro_puzzle_tile_scale_${widget.tile.value}'),
              scale: _scale,
              child: Stack(
                children: [
                  SizedBox.square(
                    dimension: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                          color: PuzzleColors.backgroundDark.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  SizedBox.square(
                    dimension: double.infinity,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: canPress
                          ? () {
                              context
                                  .read<PuzzleBloc>()
                                  .add(TileTapped(widget.tile));
                              unawaited(_audioPlayer?.replay());
                            }
                          : null,
                      icon: Image.asset(
                        'assets/images/${widget.tile.value.toString()}.png',
                        semanticLabel:
                            'Value: ${widget.tile.value.toString()}, position: ${widget.tile.currentPosition.x.toString()}, ${widget.tile.currentPosition.y.toString()}',
                      ),
                    ),
                  ),
                  if (showHint)
                    Align(
                      child: IgnorePointer(
                        child: Text(
                          widget.tile.value.toString(),
                          style: PuzzleTextStyle.headline2.copyWith(
                              fontSize: 40,
                              color: PuzzleColors.white.withOpacity(0.5)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
