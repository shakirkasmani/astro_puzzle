import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  final String text;

  final List<TextSpan> _text;
  final List<TextSpan> _textTransparent;

  final Animation<double>? progress;

  final TextStyle style;

  final bool repeat;

  AnimatedText({
    Key? key,
    required this.text,
    required this.style,
    this.progress,
    this.repeat = false,
  })  : _text = _generateText(text, style, false).toList(growable: false),
        _textTransparent =
            _generateText(text, style, true).toList(growable: false),
        super(key: key);

  static Iterable<TextSpan> _generateText(
      String text, TextStyle style, bool transparent) sync* {
    const step = 3;
    var i = 0;
    for (; i < text.length - step; i += step) {
      yield TextSpan(
        text: text.substring(i, i + step),
        style: transparent ? style.apply(color: Colors.transparent) : null,
      );
    }
    yield TextSpan(
      text: text.substring(i),
      style: transparent ? style.apply(color: Colors.transparent) : null,
    );
  }

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with TickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration:
        Duration(milliseconds: widget.text.length * (widget.repeat ? 92 : 40)),
  );
  late final _animation = CurvedAnimation(
    curve: const Interval(0, 1),
    parent: _controller,
  );

  @override
  void initState() {
    super.initState();
    widget.repeat ? _controller.repeat() : _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Text.rich(
          TextSpan(
            children: [
              for (var i = 0; i < widget._text.length; i++)
                (i / widget._text.length < _animation.value)
                    ? widget._text[i]
                    : widget._textTransparent[i],
            ],
          ),
          // textAlign: widget.textAlign,
          style: widget.style,
        );
      },
    );
  }
}
