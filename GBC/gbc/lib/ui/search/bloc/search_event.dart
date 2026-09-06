part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

/// Fired on every keystroke — the bloc itself decides when to actually
/// search (see the debounce in search_bloc.dart), so the UI doesn't need
/// to know or care about timing.
class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

/// Internal — dispatched by the bloc's own debounce timer, not by the UI.
class _SearchDebounceFired extends SearchEvent {
  final String query;
  const _SearchDebounceFired(this.query);

  @override
  List<Object> get props => [query];
}
