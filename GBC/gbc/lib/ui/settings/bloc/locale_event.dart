part of 'locale_bloc.dart';

sealed class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object> get props => [];
}

/// Loads the persisted language choice on app start.
class LocaleStarted extends LocaleEvent {}

class LocaleChanged extends LocaleEvent {
  final Locale locale;
  const LocaleChanged(this.locale);

  @override
  List<Object> get props => [locale];
}
