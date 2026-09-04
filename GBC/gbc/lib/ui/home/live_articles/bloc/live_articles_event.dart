part of 'live_articles_bloc.dart';

sealed class LiveArticlesEvent extends Equatable {
  const LiveArticlesEvent();

  @override
  List<Object> get props => [];
}

class LiveArticlesStarted extends LiveArticlesEvent {}
