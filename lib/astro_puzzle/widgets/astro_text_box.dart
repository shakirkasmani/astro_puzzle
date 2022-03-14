import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slide_puzzle/astro_puzzle/bloc/text_box_bloc.dart';
import 'package:slide_puzzle/colors/colors.dart';
import 'package:slide_puzzle/astro_puzzle/widgets/animated_text.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/timer/timer.dart';
import 'package:slide_puzzle/typography/typography.dart';

class AstroTextBox extends StatelessWidget {
  AstroTextBox({Key? key}) : super(key: key);
  final ScrollController _controller = ScrollController();

  void _scrollDown() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    final secondsElapsed =
        context.select((TimerBloc bloc) => bloc.state.secondsElapsed);
    final bloc = context.watch<TextBoxBloc>();
    final list = bloc.state.textList;
    return BlocListener<TimerBloc, TimerState>(
      listener: (context, state) {
        if (secondsElapsed == 3) {
          bloc.add(const AddText('Dastronaut: Hi'));
          _scrollDown();
        }
        if (secondsElapsed == 6) {
          bloc.add(const AddText('Dastronaut: Good Luck!'));
          _scrollDown();
        }
      },
      child: ResponsiveLayoutBuilder(
        small: (_, child) => child!,
        medium: (_, child) => child!,
        large: (_, child) => child!,
        child: (currentSize) {
          final width = currentSize == ResponsiveLayoutSize.large
              ? 400.0
              : (currentSize == ResponsiveLayoutSize.medium ? 240.0 : 180.0);

          final _fontSize =
              currentSize == ResponsiveLayoutSize.small ? 16.0 : 20.0;

          final _border = currentSize == ResponsiveLayoutSize.small ? 5.0 : 7.0;

          return Container(
            width: width,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: _border, color: PuzzleColors.darkGray),
              color: PuzzleColors.black,
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              controller: _controller,
              itemBuilder: (context, index) {
                return AnimatedText(
                  text: list[index],
                  style: PuzzleTextStyle.body
                      .copyWith(fontSize: _fontSize, color: Colors.white),
                );
              },
              itemCount: list.length,
            ),
          );
        },
      ),
    );
  }
}
