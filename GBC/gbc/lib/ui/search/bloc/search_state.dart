part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

/// Nothing typed yet.
class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<PostEntity> results;
  const SearchSuccess(this.results);

  @override
  List<Object> get props => [results];
}

class SearchError extends SearchState {
  final AppException exception;
  const SearchError(this.exception);

  @override
  List<Object> get props => [exception];
}
