import 'package:flutter/material.dart';
import 'package:slide_puzzle/astro_puzzle/astro.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/models/models.dart';
import 'package:slide_puzzle/puzzle/puzzle.dart';

/// {@template astro_puzzle_layout_delegate}
/// A delegate for computing the layout of the puzzle UI
/// that uses a [AstroTheme].
/// {@endtemplate}
class AstroPuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  /// {@macro astro_puzzle_layout_delegate}
  const AstroPuzzleLayoutDelegate();

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => Padding(
        padding: const EdgeInsets.only(left: 50, right: 32),
        child: child,
      ),
      child: (_) => AstroStartSection(
        state: state,
      ),
    );
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return AstroEndSection(state: state);
  }

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return Positioned.fill(
      child: ResponsiveLayoutBuilder(
        small: (_, child) => child!,
        medium: (_, child) => child!,
        large: (_, child) => child!,
        child: (currentSize) {
          Alignment _alignment = currentSize == ResponsiveLayoutSize.large
              ? const Alignment(1.1, 0)
              : (currentSize == ResponsiveLayoutSize.medium
                  ? const Alignment(1.2, -1)
                  : const Alignment(1.5, -0.92));

          AssetImage _asset;
          if (currentSize == ResponsiveLayoutSize.small) {
            _asset = const AssetImage('assets/images/spaceship_small.png');
          } else if (currentSize == ResponsiveLayoutSize.medium) {
            _asset = const AssetImage('assets/images/spaceship_medium.png');
          } else {
            _asset = const AssetImage('assets/images/spaceship_large.png');
          }

          return Stack(
            children: [
              ResponsiveLayoutBuilder(
                small: (_, child) => child!,
                medium: (_, child) => child!,
                large: (_, child) => child!,
                child: (currentSize) {
                  return Dashtronaut(
                    alignment: _alignment,
                    isSuccessScreen: false,
                  );
                },
              ),
              Positioned.fill(
                child: SizedBox.expand(
                  child: Image(
                    image: _asset,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget boardBuilder(int size, List<Widget> tiles) {
    return AstroBoardSection(tiles: tiles);
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => AstroPuzzleTile(
        tile: tile,
        tileFontSize: _TileFontSize.small,
        state: state,
      ),
      medium: (_, __) => AstroPuzzleTile(
        tile: tile,
        tileFontSize: _TileFontSize.medium,
        state: state,
      ),
      large: (_, __) => AstroPuzzleTile(
        tile: tile,
        tileFontSize: _TileFontSize.large,
        state: state,
      ),
    );
  }

  @override
  Widget whitespaceTileBuilder() {
    return const SizedBox();
  }

  @override
  List<Object?> get props => [];
}

abstract class _TileFontSize {
  static double small = 36;
  static double medium = 50;
  static double large = 54;
}
