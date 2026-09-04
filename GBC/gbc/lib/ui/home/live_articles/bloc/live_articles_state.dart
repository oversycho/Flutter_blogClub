part of 'live_articles_bloc.dart';

sealed class LiveArticlesState extends Equatable {
  const LiveArticlesState();

  @override
  List<Object> get props => [];
}

class LiveArticlesLoading extends LiveArticlesState {}

class LiveArticlesSuccess extends LiveArticlesState {
  final List<LiveArticleEntity> articles;
  const LiveArticlesSuccess(this.articles);

  @override
  List<Object> get props => [articles];
}

class LiveArticlesError extends LiveArticlesState {
  final AppException exception;
  const LiveArticlesError(this.exception);

  @override
  List<Object> get props => [exception];
}
