part of 'all_posts_bloc.dart';

sealed class AllPostsState extends Equatable {
  const AllPostsState();

  @override
  List<Object> get props => [];
}

class AllPostsLoading extends AllPostsState {}

class AllPostsSuccess extends AllPostsState {
  final List<PostEntity> posts;
  const AllPostsSuccess(this.posts);

  @override
  List<Object> get props => [posts];
}

class AllPostsError extends AllPostsState {
  final AppException exception;
  const AllPostsError(this.exception);

  @override
  List<Object> get props => [exception];
}
