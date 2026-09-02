import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc/common/app_exception.dart';
import 'package:gbc/data/comment.dart';
import 'package:gbc/data/repo/comment_repository.dart';

part 'comment_list_event.dart';
part 'comment_list_state.dart';

class CommentListBloc extends Bloc<CommentListEvent, CommentListState> {
  final ICommentRepository repository;
  final String postId;
  CommentListBloc({required this.repository, required this.postId})
    : super(CommentListLoading()) {
    on<CommentListStarted>(_onStarted);
    on<CommentListSubmitted>(_onSubmitted);
  }

  Future<void> _onStarted(
    CommentListStarted event,
    Emitter<CommentListState> emit,
  ) async {
    emit(CommentListLoading());
    try {
      final comments = await repository.getComments(postId: postId);
      emit(CommentListSuccess(comments));
    } catch (e) {
      emit(
        CommentListError(
          e is AppException ? e : AppException(message: e.toString()),
        ),
      );
    }
  }

  Future<void> _onSubmitted(
    CommentListSubmitted event,
    Emitter<CommentListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CommentListSuccess) return;

    if (event.content.trim().isEmpty) {
      emit(currentState.copyWith(errorMessage: 'Comment cannot be empty'));
      return;
    }

    emit(currentState.copyWith(isSubmitting: true, errorMessage: null));
    try {
      final newComment = await repository.createComment(
        postId: postId,
        content: event.content.trim(),
      );
      emit(
        currentState.copyWith(
          comments: [...currentState.comments, newComment],
          isSubmitting: false,
        ),
      );
    } catch (e) {
      emit(
        currentState.copyWith(isSubmitting: false, errorMessage: e.toString()),
      );
    }
  }
}
