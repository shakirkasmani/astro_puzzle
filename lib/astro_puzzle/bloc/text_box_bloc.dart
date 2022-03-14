import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'text_box_event.dart';
part 'text_box_state.dart';

class TextBoxBloc extends Bloc<TextBoxEvent, TextBoxState> {
  TextBoxBloc() : super(const TextBoxState()) {
    on<AddText>(_onTextAdded);
    on<ClearScreen>(_onClearScreen);
  }
  void _onTextAdded(AddText event, Emitter<TextBoxState> emit) async {
    emit(state.copyWith(textList: [...state.textList, event.text]));
    await Future.delayed(const Duration(seconds: 5));
    final list = state.textList;
    final updatedList = list.isNotEmpty ? list.sublist(1) : list;
    emit(state.copyWith(textList: [...updatedList]));
  }

  void _onClearScreen(ClearScreen event, Emitter<TextBoxState> emit) {
    emit(state.copyWith(textList: []));
  }
}
