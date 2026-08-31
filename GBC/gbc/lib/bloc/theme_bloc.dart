import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

const String _themeModeKey = 'theme_mode';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(ThemeMode.system)) {
    on<ThemeStarted>(_onStarted);
    on<ThemeModeChanged>(_onModeChanged);
  }

  Future<void> _onStarted(ThemeStarted event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString(_themeModeKey);
    switch (saved) {
      case 'light':
        emit(const ThemeState(ThemeMode.light));
        break;
      case 'dark':
        emit(const ThemeState(ThemeMode.dark));
        break;
      case 'system':
      default:
        emit(const ThemeState(ThemeMode.system));
    }
  }

  Future<void> _onModeChanged(
    ThemeModeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    emit(ThemeState(event.mode));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, event.mode.name);
  }
}
