part of 'saved_posts_bloc.dart';

sealed class SavedPostsState extends Equatable {
  const SavedPostsState();

  @override
  List<Object> get props => [];
}

class SavedPostsLoading extends SavedPostsState {}

class SavedPostsSuccess extends SavedPostsState {
  final List<PostEntity> posts;
  const SavedPostsSuccess(this.posts);

  @override
  List<Object> get props => [posts];
}

class SavedPostsError extends SavedPostsState {
  final AppException exception;
  const SavedPostsError(this.exception);

  @override
  List<Object> get props => [exception];
}
