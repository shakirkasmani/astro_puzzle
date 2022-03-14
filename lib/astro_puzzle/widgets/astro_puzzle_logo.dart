import 'package:flutter/material.dart';

class AstroPuzzleLogo extends StatelessWidget {
  const AstroPuzzleLogo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Image(
      image: AssetImage('assets/images/logo.png'),
      fit: BoxFit.contain,
    );
  }
}
