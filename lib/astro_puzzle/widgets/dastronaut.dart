import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/timer/timer.dart';

class Dashtronaut extends StatefulWidget {
  const Dashtronaut({
    Key? key,
    required this.alignment,
    required this.isSuccessScreen,
  }) : super(key: key);

  final Alignment alignment;
  final bool isSuccessScreen;

  @override
  State<Dashtronaut> createState() => _DashtronautState();
}

class _DashtronautState extends State<Dashtronaut>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late RiveAnimationController _loopController;
  late RiveAnimationController _hi;

  bool get isPlaying => _loopController.isActive;

  @override
  void initState() {
    super.initState();
    _loopController = SimpleAnimation('loop');
    _hi = SimpleAnimation('hi');
  }

  @override
  Widget build(BuildContext context) {
    final secondsElapsed =
        context.select((TimerBloc bloc) => bloc.state.secondsElapsed);
    if (secondsElapsed < 3) {
      _controller.animateTo(0);
    }
    if (secondsElapsed == 3) {
      _controller.forward();
    }
    if (secondsElapsed == 10) {
      _controller.reverse();
    }

    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (currentSize) {
        double _dimensions;
        if (currentSize == ResponsiveLayoutSize.large) {
          _dimensions = widget.isSuccessScreen ? 250 : 400;
        } else if (currentSize == ResponsiveLayoutSize.medium) {
          _dimensions = widget.isSuccessScreen ? 200 : 300;
        } else {
          _dimensions = widget.isSuccessScreen ? 150 : 200;
        }

        return AlignTransition(
          alignment: Tween<AlignmentGeometry>(
            begin: widget.isSuccessScreen
                ? widget.alignment
                : const Alignment(3, 0),
            end: widget.alignment,
          ).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Curves.linearToEaseOut,
            ),
          ),
          child: SizedBox.square(
            dimension: _dimensions,
            child: RiveAnimation.asset(
              'assets/animations/dashtronaut.riv',
              controllers: [if (!widget.isSuccessScreen) _loopController, _hi],
            ),
          ),
        );
      },
    );
  }
}
