import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc/common/app_exception.dart';
import 'package:gbc/data/post_detail.dart';
import 'package:gbc/data/repo/post_repository.dart';

part 'post_detail_event.dart';
part 'post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final IPostReposiotry postRepository;

  PostDetailBloc(this.postRepository) : super(PostDetailLoading()) {
    on<PostDetailStarted>(_onStarted);
    on<PostDetailLikeButtonClicked>(_onLikeClicked);
    on<PostDetailBookmarkButtonClicked>(_onBookmarkClicked);
  }

  Future<void> _onStarted(
    PostDetailStarted event,
    Emitter<PostDetailState> emit,
  ) async {
    try {
      emit(PostDetailLoading());
      final post = await postRepository.getPostDetail(event.slug);
      emit(PostDetailSuccess(post));

      // Fire-and-forget — a failed view-count bump shouldn't disrupt
      // the reading experience, and we don't wait on it before showing
      // the post.
      postRepository.incrementView(post.id);
    } catch (e) {
      emit(
        PostDetailError(
          e is AppException ? e : AppException(message: e.toString()),
        ),
      );
    }
  }

  Future<void> _onLikeClicked(
    PostDetailLikeButtonClicked event,
    Emitter<PostDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PostDetailSuccess) return;

    final post = currentState.post;
    // Optimistic update — flip the heart immediately, don't wait on the network.
    final optimisticPost = post.copyWith(
      isLiked: !post.isLiked,
      likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
    );
    emit(PostDetailSuccess(optimisticPost));

    try {
      final bool actuallyLiked = await postRepository.toggleLike(post.id);
      // Reconcile with the server's answer in case of a race
      // (e.g. double-tap, or state changed elsewhere).
      if (actuallyLiked != optimisticPost.isLiked) {
        emit(
          PostDetailSuccess(
            optimisticPost.copyWith(
              isLiked: actuallyLiked,
              likesCount: actuallyLiked
                  ? optimisticPost.likesCount + 1
                  : optimisticPost.likesCount - 1,
            ),
          ),
        );
      }
    } catch (_) {
      // Revert on failure (e.g. not authenticated, network error).
      emit(PostDetailSuccess(post));
    }
  }

  Future<void> _onBookmarkClicked(
    PostDetailBookmarkButtonClicked event,
    Emitter<PostDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PostDetailSuccess) return;

    final post = currentState.post;
    final optimisticPost = post.copyWith(
      isBookmarked: !post.isBookmarked,
      bookmarksCount: post.isBookmarked
          ? post.bookmarksCount - 1
          : post.bookmarksCount + 1,
    );
    emit(PostDetailSuccess(optimisticPost));

    try {
      final bool actuallyBookmarked = await postRepository.toggleBookmark(
        post.id,
      );
      if (actuallyBookmarked != optimisticPost.isBookmarked) {
        emit(
          PostDetailSuccess(
            optimisticPost.copyWith(
              isBookmarked: actuallyBookmarked,
              bookmarksCount: actuallyBookmarked
                  ? optimisticPost.bookmarksCount + 1
                  : optimisticPost.bookmarksCount - 1,
            ),
          ),
        );
      }
    } catch (_) {
      emit(PostDetailSuccess(post));
    }
  }
}
