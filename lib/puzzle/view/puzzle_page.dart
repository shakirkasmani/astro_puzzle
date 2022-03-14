import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:slide_puzzle/astro_puzzle/astro.dart';
import 'package:slide_puzzle/audio_control/audio_control.dart';
import 'package:slide_puzzle/colors/colors.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/models/models.dart';
import 'package:slide_puzzle/puzzle/puzzle.dart';
import 'package:slide_puzzle/theme/theme.dart';
import 'package:slide_puzzle/timer/timer.dart';

/// {@template puzzle_page}
/// The root page of the puzzle UI.
///
/// Builds the puzzle based on the current [PuzzleTheme]
/// from [ThemeBloc].
/// {@endtemplate}
class PuzzlePage extends StatelessWidget {
  /// {@macro puzzle_page}
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AstroPuzzleBloc(
            secondsToBegin: 3,
            ticker: const Ticker(),
          ),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(
            initialThemes: [
              const AstroTheme(),
            ],
          ),
        ),
        BlocProvider(
          create: (_) => TimerBloc(
            ticker: const Ticker(),
          ),
        ),
        BlocProvider(
          create: (_) => AudioControlBloc(),
        ),
        BlocProvider(
          create: (_) => HintBloc(),
        ),
        BlocProvider(
          create: (_) => TextBoxBloc(),
        ),
      ],
      child: const PuzzleView(),
    );
  }
}

/// {@template puzzle_view}
/// Displays the content for the [PuzzlePage].
/// {@endtemplate}
class PuzzleView extends StatelessWidget {
  /// {@macro puzzle_view}
  const PuzzleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: PuzzleThemeAnimationDuration.backgroundColorChange,
        decoration: const BoxDecoration(color: PuzzleColors.backgroundDark),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TimerBloc(
                ticker: const Ticker(),
              ),
            ),
            BlocProvider(
              create: (context) => PuzzleBloc(3)
                ..add(
                  const PuzzleInitialized(
                    shufflePuzzle: false,
                  ),
                ),
            ),
          ],
          child: const AstroStartAnimation(),
        ),
      ),
    );
  }
}

class _Puzzle extends StatelessWidget {
  const _Puzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            const StarsBackground(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ResponsiveLayoutBuilder(
                small: (_, __) {
                  return Stack(
                    children: [
                      theme.layoutDelegate.backgroundBuilder(state),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            theme.layoutDelegate.startSectionBuilder(state),
                            const Center(child: PuzzleBoard()),
                            theme.layoutDelegate.endSectionBuilder(state),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                medium: (_, __) {
                  return Stack(
                    children: [
                      theme.layoutDelegate.backgroundBuilder(state),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            theme.layoutDelegate.startSectionBuilder(state),
                            const Center(child: PuzzleBoard()),
                            theme.layoutDelegate.endSectionBuilder(state),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                large: (_, __) {
                  return Stack(
                    children: [
                      theme.layoutDelegate.backgroundBuilder(state),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                              child: theme.layoutDelegate
                                  .startSectionBuilder(state)),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: constraints.maxHeight),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const PuzzleBoard(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const AstroProgressIndicator(
                                      isHorizontal: true,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        AstroTimer(),
                                        Gap(5),
                                        AstroMoveCount(),
                                      ],
                                    ),
                                    SizedBox(width: 250, child: AstroTextBox()),
                                    const Gap(20)
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child:
                                  theme.layoutDelegate.endSectionBuilder(state))
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

/// {@template puzzle_board}
/// Displays the board of the puzzle.
/// {@endtemplate}

class PuzzleBoard extends StatelessWidget {
  /// {@macro puzzle_board}
  const PuzzleBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final puzzle = context.select((PuzzleBloc bloc) => bloc.state.puzzle);

    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

    return PuzzleKeyboardHandler(
      child: BlocListener<PuzzleBloc, PuzzleState>(
        listener: (context, state) {
          if (theme.hasTimer && state.puzzleStatus == PuzzleStatus.complete) {
            context.read<TimerBloc>().add(const TimerStopped());
          }
        },
        child: theme.layoutDelegate.boardBuilder(
          size,
          puzzle.tiles
              .map(
                (tile) => _PuzzleTile(
                  key: Key('puzzle_tile_${tile.value.toString()}'),
                  tile: tile,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({
    Key? key,
    required this.tile,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return tile.isWhitespace
        ? theme.layoutDelegate.whitespaceTileBuilder()
        : theme.layoutDelegate.tileBuilder(tile, state);
  }
}

/// Rocket Thrust Animation
class AstroStartAnimation extends StatefulWidget {
  const AstroStartAnimation({Key? key}) : super(key: key);

  @override
  _AstroStartAnimationState createState() => _AstroStartAnimationState();
}

class _AstroStartAnimationState extends State<AstroStartAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 0.0092),
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> animate() async {
    _controller.repeat(reverse: true);
    await Future.delayed(const Duration(seconds: 3));
    _controller.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AstroPuzzleBloc, AstroPuzzleState>(
      listener: (context, state) {
        if (state.status == AstroPuzzleStatus.started) animate();
      },
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: PuzzleColors.skyGradient),
          ),
          SlideTransition(
            position: _offsetAnimation,
            child: const _Puzzle(),
          ),
        ],
      ),
    );
  }
}

/// The global key of [AudioControl].
///
/// Used to animate the transition of [AudioControl]
/// when changing a theme.
final audioControlKey = GlobalKey(debugLabel: 'audio_control');
