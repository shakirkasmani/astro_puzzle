part of 'hint_bloc.dart';

abstract class HintEvent extends Equatable {
  const HintEvent();

  @override
  List<Object> get props => [];
}

class HintToggleEvent extends HintEvent {
  const HintToggleEvent();
}
