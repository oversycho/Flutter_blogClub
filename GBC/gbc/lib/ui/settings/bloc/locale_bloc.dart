import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_event.dart';
part 'locale_state.dart';

const String _localeKey = 'locale_code';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(const LocaleState(Locale('en'))) {
    on<LocaleStarted>(_onStarted);
    on<LocaleChanged>(_onChanged);
  }

  Future<void> _onStarted(
    LocaleStarted event,
    Emitter<LocaleState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString(_localeKey);
    if (saved == 'fa') {
      emit(const LocaleState(Locale('fa')));
    } else {
      emit(const LocaleState(Locale('en')));
    }
  }

  Future<void> _onChanged(
    LocaleChanged event,
    Emitter<LocaleState> emit,
  ) async {
    emit(LocaleState(event.locale));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, event.locale.languageCode);
  }
}
