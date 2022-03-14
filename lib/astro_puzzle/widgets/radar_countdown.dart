import 'dart:async';
import 'dart:math' as math;

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import 'package:slide_puzzle/astro_puzzle/bloc/bloc.dart';
import 'package:slide_puzzle/audio_control/audio_control.dart';
import 'package:slide_puzzle/colors/colors.dart';
import 'package:slide_puzzle/helpers/helpers.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/puzzle/puzzle.dart';
import 'package:slide_puzzle/timer/timer.dart';
import 'package:slide_puzzle/typography/typography.dart';

/// {@template astro_radar_countdown}
/// Displays available friends & other players online &
/// Displays the countdown before the puzzle is started.
/// {@endtemplate}
class AstroRadarCountdown extends StatefulWidget {
  /// {@macro astro_radar_countdown}
  const AstroRadarCountdown({
    Key? key,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<AstroRadarCountdown> createState() => _AstroRadarCountdownState();
}

class _AstroRadarCountdownState extends State<AstroRadarCountdown> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget._audioPlayerFactory()
      ..setAsset('assets/audio/countdown.mp3');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AudioControlListener(
      audioPlayer: _audioPlayer,
      child: BlocListener<AstroPuzzleBloc, AstroPuzzleState>(
        listener: (context, state) {
          if (!state.isCountdownRunning) {
            return;
          }

          // Play the shuffle sound when the countdown from 3 to 1 begins.
          if (state.secondsToBegin == 3) {
            unawaited(_audioPlayer.replay());
          }

          // Start the puzzle timer when the countdown finishes.
          if (state.status == AstroPuzzleStatus.started) {
            context.read<TimerBloc>().add(const TimerStarted());
          }

          // Shuffle the puzzle on every countdown tick.
          if (state.secondsToBegin >= 1 && state.secondsToBegin <= 3) {
            context.read<PuzzleBloc>().add(const PuzzleReset());
          }
        },
        child: ResponsiveLayoutBuilder(
            small: (_, child) => child!,
            medium: (_, child) => child!,
            large: (_, child) => child!,
            child: (currentSize) {
              return SizedBox.square(
                dimension:
                    currentSize == ResponsiveLayoutSize.large ? 172 : 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Radar(currentSize: currentSize),
                    BlocBuilder<AstroPuzzleBloc, AstroPuzzleState>(
                      builder: (context, state) {
                        if (!state.isCountdownRunning ||
                            state.secondsToBegin > 3) {
                          return const SizedBox();
                        }
                        if (state.secondsToBegin > 0) {
                          return AstroCountdownSecondsToBegin(
                            key: ValueKey(state.secondsToBegin),
                            secondsToBegin: state.secondsToBegin,
                          );
                        } else {
                          return const DashatarCountdownGo();
                        }
                      },
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

/// {@template astro_countdown_seconds_to_begin}
/// Display how many seconds are left to begin the puzzle.
/// {@endtemplate}

class AstroCountdownSecondsToBegin extends StatefulWidget {
  /// {@macro astro_countdown_seconds_to_begin}
  const AstroCountdownSecondsToBegin({
    Key? key,
    required this.secondsToBegin,
  }) : super(key: key);

  /// The number of seconds before the puzzle is started.
  final int secondsToBegin;

  @override
  State<AstroCountdownSecondsToBegin> createState() =>
      _AstroCountdownSecondsToBeginState();
}

class _AstroCountdownSecondsToBeginState
    extends State<AstroCountdownSecondsToBegin>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> inOpacity;
  late Animation<double> inScale;
  late Animation<double> outOpacity;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    inOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.58, curve: Curves.decelerate),
      ),
    );

    inScale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.58, curve: Curves.decelerate),
      ),
    );

    outOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.81, 1, curve: Curves.easeIn),
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
        small: (_, child) => child!,
        medium: (_, child) => child!,
        large: (_, child) => child!,
        child: (currentSize) {
          return FadeTransition(
            opacity: outOpacity,
            child: FadeTransition(
              opacity: inOpacity,
              child: ScaleTransition(
                scale: inScale,
                child: Text(
                  widget.secondsToBegin.toString(),
                  style: PuzzleTextStyle.countdownTime.copyWith(
                    fontSize:
                        currentSize == ResponsiveLayoutSize.large ? 140 : 72,
                    color: PuzzleColors.white,
                  ),
                ),
              ),
            ),
          );
        });
  }
}

/// {@template astro_countdown_go}
/// Displays a "Go!" text when the countdown reaches 0 seconds.
/// {@endtemplate}

class DashatarCountdownGo extends StatefulWidget {
  /// {@macro astro_countdown_go}
  const DashatarCountdownGo({Key? key}) : super(key: key);

  @override
  State<DashatarCountdownGo> createState() => _DashatarCountdownGoState();
}

class _DashatarCountdownGoState extends State<DashatarCountdownGo>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> inOpacity;
  late Animation<double> inScale;
  late Animation<double> outScale;
  late Animation<double> outOpacity;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    inOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.37, curve: Curves.decelerate),
      ),
    );

    inScale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.37, curve: Curves.decelerate),
      ),
    );

    outOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.63, 1, curve: Curves.easeIn),
      ),
    );

    outScale = Tween<double>(begin: 1, end: 1.5).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.63, 1, curve: Curves.easeIn),
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
        small: (_, child) => child!,
        medium: (_, child) => child!,
        large: (_, child) => child!,
        child: (currentSize) {
          return FadeTransition(
            opacity: outOpacity,
            child: FadeTransition(
              opacity: inOpacity,
              child: ScaleTransition(
                scale: outScale,
                child: ScaleTransition(
                  scale: inScale,
                  child: Text(
                    'GO!',
                    style: PuzzleTextStyle.countdownTime.copyWith(
                      fontSize:
                          currentSize == ResponsiveLayoutSize.large ? 72 : 40,
                      color: PuzzleColors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class RadarAnimationBuilder extends StatefulWidget {
  const RadarAnimationBuilder({Key? key}) : super(key: key);

  @override
  State<RadarAnimationBuilder> createState() => _RadarAnimationBuilderState();
}

class _RadarAnimationBuilderState extends State<RadarAnimationBuilder>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        width: 200.0,
        height: 200.0,
        color: PuzzleColors.greenDark,
        child: const Center(
          child: Text('Whee!'),
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return Transform.rotate(
          angle: _controller.value * 2.0 * math.pi,
          child: child,
        );
      },
    );
  }
}

class Radar extends StatefulWidget {
  const Radar({Key? key, required this.currentSize}) : super(key: key);
  final ResponsiveLayoutSize currentSize;
  @override
  State<Radar> createState() => _RadarState();
}

class _RadarState extends State<Radar> with TickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )
    ..addListener(() => setState(() {}))
    ..repeat();
  late final Animation<double> _animation =
      Tween<double>(begin: 0, end: 2 * math.pi).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCirc));

  // TODO replace with online avalable friends or players or both.
  final _players = <PlayerIndicatorData>[];
  generatePlayerPostions() {
    _players.clear();
    for (int i = 0; i < 5; i++) {
      _players.add(PlayerIndicatorData());
    }
  }

  @override
  void initState() {
    super.initState();
    generatePlayerPostions();
  }

  @override
  Widget build(BuildContext context) {
    final _padding = widget.currentSize == ResponsiveLayoutSize.large
        ? 8.0
        : (widget.currentSize == ResponsiveLayoutSize.medium ? 6.0 : 4.0);
    return Center(
      child: Container(
        padding: EdgeInsets.all(_padding),
        decoration: const BoxDecoration(
            color: PuzzleColors.darkGray, shape: BoxShape.circle),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.expand(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _RadarPainter(
                      animation: _animation.value,
                      currentSize: widget.currentSize),
                ),
              ),
            ),
            for (final player in _players)
              Positioned.fill(
                  child: PlayerIndicator(alignment: player.alignment)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({required this.animation, required this.currentSize});
  final double animation;
  final ResponsiveLayoutSize currentSize;
  @override
  void paint(Canvas canvas, Size size) {
    double _strokeWidth;
    if (currentSize == ResponsiveLayoutSize.large) {
      _strokeWidth = 5.0;
    } else {
      _strokeWidth = 3.0;
    }

    Paint paintFill = Paint()
      ..color = PuzzleColors.greenDark
      ..style = PaintingStyle.fill;

    Path pathFill = Path();
    pathFill.addOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
    );
    pathFill.close();
    canvas.drawPath(pathFill, paintFill);

    ///SweepGradient filled circle
    Paint gradientPaint = Paint()
      ..shader = SweepGradient(
        colors: const [Colors.transparent, PuzzleColors.greenLight],
        startAngle: animation,
        endAngle: animation + (2 * math.pi),
        transform: const GradientRotation(3 * math.pi / 2),
        stops: const [0.0, 1],
        tileMode: TileMode.repeated,
      ).createShader(
        Rect.fromCircle(
            center: Offset(size.shortestSide / 2, size.shortestSide / 2),
            radius: size.shortestSide / 2),
      )
      ..style = PaintingStyle.fill;

    Path gradientPath = Path();
    gradientPath.addOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
    );
    gradientPath.close();
    canvas.drawPath(gradientPath, gradientPaint);

    Paint paintStroke = Paint()
      ..color = PuzzleColors.greenLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    Path pathStroke = Path();

    ///Circles with strokes
    pathStroke.addOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
    );
    pathStroke.addOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * (3 / 4),
        height: size.height * (3 / 4),
      ),
    );
    pathStroke.addOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width / 2,
        height: size.height / 2,
      ),
    );

    /// Drawing Verticle & Horizontal Lines
    pathStroke.moveTo(size.width / 2, 0);
    pathStroke.lineTo(size.width / 2, size.height);

    pathStroke.moveTo(0, size.height / 2);
    pathStroke.lineTo(size.width, size.height / 2);

    pathStroke.close();
    canvas.drawPath(pathStroke, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PlayerIndicator extends StatelessWidget {
  const PlayerIndicator({Key? key, required this.alignment}) : super(key: key);
  final Alignment alignment;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: AvatarGlow(
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
                color: PuzzleColors.amber, shape: BoxShape.circle),
          ),
          endRadius: 30),
    );
  }
}

class PlayerIndicatorData {
  static final _rng = math.Random();

  final double size;
  final Alignment alignment;

  PlayerIndicatorData()
      : size = _rng.nextDouble() * 40 + 10,
        alignment = Alignment(
          _rng.nextDouble() * 2 - 1,
          _rng.nextDouble() * 2 - 1,
        );
}
