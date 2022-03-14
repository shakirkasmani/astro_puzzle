import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AstroFlutterFlag extends StatefulWidget {
  const AstroFlutterFlag({Key? key}) : super(key: key);

  @override
  _AstroFlutterFlagState createState() => _AstroFlutterFlagState();
}

class _AstroFlutterFlagState extends State<AstroFlutterFlag> {
  // Controller for playback
  late RiveAnimationController _loopController;

  /// Tracks if the animation is playing by whether controller is running
  bool get isPlaying => _loopController.isActive;

  @override
  void initState() {
    super.initState();
    _loopController = SimpleAnimation('loop');
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'assets/animations/flag.riv',
      controllers: [
        _loopController,
      ],
    );
  }
}
