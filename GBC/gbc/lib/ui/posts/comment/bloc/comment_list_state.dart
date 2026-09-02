part of 'comment_list_bloc.dart';

sealed class CommentListState extends Equatable {
  const CommentListState();

  @override
  List<Object?> get props => [];
}

class CommentListLoading extends CommentListState {}

class CommentListSuccess extends CommentListState {
  final List<CommentEntity> comments;
  final bool isSubmitting;
  final String? errorMessage;

  const CommentListSuccess(
    this.comments, {
    this.isSubmitting = false,
    this.errorMessage,
  });

  CommentListSuccess copyWith({
    List<CommentEntity>? comments,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return CommentListSuccess(
      comments ?? this.comments,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [comments, isSubmitting, errorMessage];
}

class CommentListError extends CommentListState {
  final AppException exception;

  const CommentListError(this.exception);
  @override
  List<Object?> get props => [exception];
}
