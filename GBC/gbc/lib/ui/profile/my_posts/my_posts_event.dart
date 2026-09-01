part of 'my_posts_bloc.dart';

sealed class MyPostsEvent extends Equatable {
  const MyPostsEvent();

  @override
  List<Object> get props => [];
}

class MyPostsStarted extends MyPostsEvent {}
