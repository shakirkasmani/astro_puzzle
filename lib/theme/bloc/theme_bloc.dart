// ignore_for_file: public_member_api_docs

import 'package:slide_puzzle/astro_puzzle/astro.dart';
import 'package:slide_puzzle/theme/theme.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({required List<PuzzleTheme> initialThemes})
      : super(ThemeState(themes: initialThemes)) {
    on<ThemeChanged>(_onThemeChanged);
    on<ThemeUpdated>(_onThemeUpdated);
  }

  void _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) {
    emit(state.copyWith(theme: state.themes[event.themeIndex]));
  }

  void _onThemeUpdated(ThemeUpdated event, Emitter<ThemeState> emit) {
    final themeIndex =
        state.themes.indexWhere((theme) => theme.name == event.theme.name);

    if (themeIndex != -1) {
      final newThemes = [...state.themes];
      newThemes[themeIndex] = event.theme;
      emit(
        state.copyWith(
          themes: newThemes,
          theme: event.theme,
        ),
      );
    }
  }
}
