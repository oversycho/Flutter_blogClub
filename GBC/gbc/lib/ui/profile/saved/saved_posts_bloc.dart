import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc/common/app_exception.dart';
import 'package:gbc/data/post.dart';
import 'package:gbc/data/repo/post_repository.dart';

part 'saved_posts_event.dart';
part 'saved_posts_state.dart';

class SavedPostsBloc extends Bloc<SavedPostsEvent, SavedPostsState> {
  final IPostReposiotry postRepository;

  SavedPostsBloc({required this.postRepository})
    : super(SavedPostsLoading()) {
    on<SavedPostsStarted>(_onStarted);
  }

  Future<void> _onStarted(
    SavedPostsStarted event,
    Emitter<SavedPostsState> emit,
  ) async {
    try {
      emit(SavedPostsLoading());
      final posts = await postRepository.getMyBookmarkedPosts();
      emit(SavedPostsSuccess(posts));
    } catch (e) {
      emit(
        SavedPostsError(
          e is AppException ? e : AppException(message: e.toString()),
        ),
      );
    }
  }
}
