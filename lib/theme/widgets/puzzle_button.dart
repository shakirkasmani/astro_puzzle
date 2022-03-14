import 'package:flutter/material.dart';
import 'package:slide_puzzle/colors/colors.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/theme/theme.dart';
import 'package:slide_puzzle/typography/typography.dart';

/// {@template puzzle_button}
/// Displays the puzzle action button.
/// {@endtemplate}
class PuzzleButton extends StatelessWidget {
  /// {@macro puzzle_button}
  const PuzzleButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  /// The background color of this button.
  /// Defaults to [PuzzleTheme.buttonColor].
  final Color? backgroundColor;

  /// The text color of this button.
  /// Defaults to [PuzzleColors.white].
  final Color? textColor;

  /// Called when this button is tapped.
  final VoidCallback? onPressed;

  /// The label of this button.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final buttonTextColor = textColor ?? PuzzleColors.white;
    final buttonBackgroundColor = backgroundColor ?? PuzzleColors.red;
    return ResponsiveLayoutBuilder(
        small: (_, child) => child!,
        medium: (_, child) => child!,
        large: (_, child) => child!,
        child: (currentSize) {
          return SizedBox(
            width: currentSize == ResponsiveLayoutSize.small ? 110 : 145,
            height: 44,
            child: AnimatedTextButton(
              duration: PuzzleThemeAnimationDuration.backgroundColorChange,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                textStyle: PuzzleTextStyle.headline5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ).copyWith(
                backgroundColor:
                    MaterialStateProperty.all(buttonBackgroundColor),
                foregroundColor: MaterialStateProperty.all(buttonTextColor),
              ),
              onPressed: onPressed,
              child: child,
            ),
          );
        });
  }
}
