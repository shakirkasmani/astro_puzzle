import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Moonshot extends StatefulWidget {
  const Moonshot({Key? key}) : super(key: key);

  @override
  _MoonshotState createState() => _MoonshotState();
}

class _MoonshotState extends State<Moonshot> {
  late RiveAnimationController _loopController;

  bool get isPlaying => _loopController.isActive;

  @override
  void initState() {
    super.initState();
    _loopController = SimpleAnimation('star constellation');
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'assets/animations/moonshot.riv',
      controllers: [
        _loopController,
      ],
    );
  }
}
