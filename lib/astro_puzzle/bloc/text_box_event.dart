part of 'text_box_bloc.dart';

abstract class TextBoxEvent extends Equatable {
  const TextBoxEvent();

  @override
  List<Object> get props => [];
}

class AddText extends TextBoxEvent {
  final String text;

  const AddText(this.text);
}

class ClearScreen extends TextBoxEvent {
  const ClearScreen();
}
