part of 'post_detail_bloc.dart';

sealed class PostDetailState extends Equatable {
  const PostDetailState();

  @override
  List<Object> get props => [];
}

class PostDetailLoading extends PostDetailState {}

class PostDetailSuccess extends PostDetailState {
  final PostDetailEntity post;
  const PostDetailSuccess(this.post);

  @override
  List<Object> get props => [post];
}

class PostDetailError extends PostDetailState {
  final AppException exception;
  const PostDetailError(this.exception);

  @override
  List<Object> get props => [exception];
}
