part of 'my_posts_bloc.dart';

sealed class MyPostsState extends Equatable {
  const MyPostsState();

  @override
  List<Object> get props => [];
}

class MyPostsLoading extends MyPostsState {}

class MyPostsSuccess extends MyPostsState {
  final List<PostEntity> posts;
  const MyPostsSuccess(this.posts);

  @override
  List<Object> get props => [posts];
}

class MyPostsError extends MyPostsState {
  final AppException exception;
  const MyPostsError(this.exception);

  @override
  List<Object> get props => [exception];
}
