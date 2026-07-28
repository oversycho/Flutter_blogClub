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
    on<CommentListEvent>((event, emit) async {
      if (event is CommentListStarted) {
        emit(CommentListLoading());
        try {
          final comments = await repository.getComments(postId: postId);
          emit(CommentListSuccess(comments));
        } catch (e) {
          emit(CommentListError(AppException()));
        }
      }
    });
  }
}
