import 'package:flutter/material.dart';
import 'package:slide_puzzle/theme/themes/themes.dart';
import 'package:slide_puzzle/layout/puzzle_layout_delegate.dart';
import 'package:slide_puzzle/astro_puzzle/astro.dart';

abstract class AstroBaseTheme extends PuzzleTheme {
  const AstroBaseTheme() : super();
  @override
  String get name => 'Astro';

  @override
  bool get hasTimer => true;

  @override
  PuzzleLayoutDelegate get layoutDelegate => const AstroPuzzleLayoutDelegate();

  Gradient get skyColor;

  @override
  List<Object?> get props => [
        name,
        hasTimer,
        layoutDelegate,
        skyColor,
      ];
}
