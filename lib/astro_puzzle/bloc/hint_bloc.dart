import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'hint_event.dart';
part 'hint_state.dart';

class HintBloc extends Bloc<HintEvent, HintState> {
  HintBloc() : super(const HintState()) {
    on<HintToggleEvent>(_onHintToggle);
  }

  void _onHintToggle(HintToggleEvent event, Emitter<HintState> emit) {
    emit(HintState(showHint: !state.showHint));
  }
}
