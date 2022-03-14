part of 'hint_bloc.dart';

class HintState extends Equatable {
  const HintState({this.showHint = false});
  final bool showHint;
  @override
  List<Object> get props => [showHint];
}
