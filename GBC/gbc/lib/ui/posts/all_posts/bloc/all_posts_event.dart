part of 'all_posts_bloc.dart';

sealed class AllPostsEvent extends Equatable {
  const AllPostsEvent();

  @override
  List<Object> get props => [];
}

class AllPostsStarted extends AllPostsEvent {}
