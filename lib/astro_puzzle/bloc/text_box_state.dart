part of 'text_box_bloc.dart';

class TextBoxState extends Equatable {
  const TextBoxState({this.textList = const <String>[]});

  final List<String> textList;

  TextBoxState copyWith({List<String>? textList}) {
    return TextBoxState(textList: textList ?? this.textList);
  }

  @override
  List<Object> get props => [textList];
}
