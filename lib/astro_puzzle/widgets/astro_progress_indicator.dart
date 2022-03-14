import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/astro_puzzle/astro.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/puzzle/puzzle.dart';

// ignore: public_member_api_docs
class AstroProgressIndicator extends StatefulWidget {
  // ignore: public_member_api_docs
  const AstroProgressIndicator({
    Key? key,
    required this.isHorizontal,
  }) : super(key: key);
  final bool isHorizontal;

  @override
  State<AstroProgressIndicator> createState() => _AstroProgressIndicatorState();
}

class _AstroProgressIndicatorState extends State<AstroProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    final status = context.select((AstroPuzzleBloc bloc) => bloc.state.status);
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    final percent =
        state.numberOfCorrectTiles / state.puzzle.tiles.length * 100;

    const distance = 300.0;

    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        final size = currentSize == ResponsiveLayoutSize.small ? 60.0 : 75.0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: distance + size,
              height: size,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RotatedBox(
                        quarterTurns: widget.isHorizontal ? 0 : 1,
                        child: SizedBox.square(
                          dimension: size,
                          child: const Image(
                            image: AssetImage('assets/images/3.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RotatedBox(
                        quarterTurns: widget.isHorizontal ? 0 : 1,
                        child: SizedBox.square(
                          dimension: size,
                          child: const Image(
                            image: AssetImage('assets/images/moon.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      left: status == AstroPuzzleStatus.started
                          ? (percent * distance / 100)
                          : 0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: SizedBox.square(
                        dimension: size,
                        child: const Image(
                          image: AssetImage('assets/images/rocket.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
