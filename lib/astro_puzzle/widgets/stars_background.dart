import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sa3_liquid/sa3_liquid.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:slide_puzzle/colors/colors.dart';
import 'package:supercharged/supercharged.dart';
import 'package:slide_puzzle/astro_puzzle/astro.dart';

class StarsBackground extends StatelessWidget {
  const StarsBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = _createTween();
    final status = context.select((AstroPuzzleBloc bloc) => bloc.state.status);
    return LayoutBuilder(
      builder: (context, constraints) {
        return LoopAnimation<TimelineValue<_P>>(
          tween: tween,
          duration: tween.duration,
          builder: (context, child, value) {
            return Stack(
              children: [
                Positioned.fill(
                  // child: SkyBackground(),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                      minWidth: constraints.maxWidth,
                    ),
                    decoration: const BoxDecoration(
                      gradient: PuzzleColors.skyGradient,
                    ),
                  ),
                ),

                const Positioned.fill(child: StaticStars()),
                // const Positioned.fill(child: Flashes()),
                if (status == AstroPuzzleStatus.started)
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter:
                            ParticlesPainter(value: value.get(_P.particles)),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

enum _P { particles }
const musicUnitMS = 6165;

TimelineTween<_P> _createTween() {
  final tween = TimelineTween<_P>();

  tween
      .addScene(
        begin: 0.seconds,
        end: (1 * musicUnitMS).round().milliseconds,
      )
      .animate(_P.particles, tween: 0.0.tweenTo(3));

  return tween;
}

class ParticlesPainter extends CustomPainter {
  ParticlesPainter({required this.value});

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(1);

    200.times(() {
      final start = random.nextDouble();
      final p = (start + value) % 1.0;

      final target = random.nextBool()
          ? Offset(
              random.nextDouble(),
              random.nextBool() ? -0.0 : 1.0,
            )
          : Offset(
              random.nextBool() ? -0.0 : 1.0,
              random.nextDouble(),
            );

      final position = Offset(
        ((1 - p) * 0.5 + p * target.dx) * size.width,
        ((1 - p) * 0.5 + p * target.dy) * size.height,
      );

      final paint = Paint()..color = Colors.white.withOpacity(0.3 + 0.4 * p);

      if (p > 0.1) {
        canvas.drawCircle(position, size.width * 0.002 * p, paint);
      }
    });
  }

  @override
  bool shouldRepaint(covariant ParticlesPainter oldDelegate) {
    return value != oldDelegate.value;
  }
}

class SkyBackground extends StatelessWidget {
  const SkyBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          tileMode: TileMode.mirror,
          begin: Alignment(-0.4, -1.0),
          end: Alignment(0.3, 1.0),
          colors: [
            Color(0xff20317d),
            Color(0xff1a2452),
          ],
          stops: [
            0,
            1,
          ],
        ),
        backgroundBlendMode: BlendMode.srcOver,
      ),
      child: PlasmaRenderer(
        color: const Color(0x18c537cf),
        blur: 0.34,
        size: 0.88,
        speed: 0,
        offset: 3.8,
        variation2: 0.43,
        child: PlasmaRenderer(
          color: const Color(0x06bababa),
          blur: 0.4,
          speed: 0,
          offset: 3.84,
          rotation: 1.31,
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                radius: 0.95,
                colors: [
                  Color(0x00000000),
                  Color(0x41000000),
                ],
                stops: [
                  0,
                  1,
                ],
              ),
              backgroundBlendMode: BlendMode.srcOver,
            ),
          ),
        ),
      ),
    );
  }
}

class StaticStars extends StatelessWidget {
  const StaticStars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final n = min(1000,
            (constraints.maxWidth * constraints.maxHeight / 2000).round());

        return RepaintBoundary(
          child: CustomPaint(
            painter: _StaticStarsPainter(n: n),
          ),
        );
      },
    );
  }
}

class _StaticStarsPainter extends CustomPainter {
  _StaticStarsPainter({required this.n});

  final int n;

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(1);
    n.times(() {
      final position = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      final radius = 2 * random.nextDouble();
      final paint = Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1)
        ..color = colors.pickOne(random).withOpacity(0.7 * random.nextDouble());
      canvas.drawCircle(position, radius, paint);
    });
  }

  @override
  bool shouldRepaint(covariant _StaticStarsPainter oldDelegate) {
    return oldDelegate.n != n;
  }
}

var colors = [
  '#DAB6BA'.toColor(),
  '#FFDFFF'.toColor(),
  '#878DEB'.toColor(),
];
