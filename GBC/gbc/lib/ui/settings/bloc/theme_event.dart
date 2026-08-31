part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

/// Loads the persisted theme choice on app start.
class ThemeStarted extends ThemeEvent {}

class ThemeModeChanged extends ThemeEvent {
  final ThemeMode mode;
  const ThemeModeChanged(this.mode);

  @override
  List<Object> get props => [mode];
}
