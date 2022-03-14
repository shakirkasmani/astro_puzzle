import 'package:flutter/material.dart';
import 'package:slide_puzzle/astro_puzzle/layout/astro_puzzle_layout_delegate.dart';
import 'package:slide_puzzle/astro_puzzle/themes/astro_base_theme.dart';
import 'package:slide_puzzle/colors/colors.dart';
import 'package:slide_puzzle/layout/layout.dart';

class AstroTheme extends AstroBaseTheme {
  const AstroTheme() : super();
  @override
  String get name => 'Astro';

  @override
  bool get hasTimer => true;

  @override
  PuzzleLayoutDelegate get layoutDelegate => const AstroPuzzleLayoutDelegate();

  @override
  Gradient get skyColor => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [PuzzleColors.backgroundDark, PuzzleColors.backgroundLight],
      );

  @override
  List<Object?> get props => [
        name,
        hasTimer,
        layoutDelegate,
        skyColor,
      ];
}
