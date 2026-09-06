import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc/common/app_exception.dart';
import 'package:gbc/data/post.dart';
import 'package:gbc/data/repo/post_repository.dart';

part 'all_posts_event.dart';
part 'all_posts_state.dart';

class AllPostsBloc extends Bloc<AllPostsEvent, AllPostsState> {
  final IPostReposiotry postRepository;

  AllPostsBloc({required this.postRepository}) : super(AllPostsLoading()) {
    on<AllPostsStarted>(_onStarted);
  }

  Future<void> _onStarted(
    AllPostsStarted event,
    Emitter<AllPostsState> emit,
  ) async {
    try {
      emit(AllPostsLoading());
      final posts = await postRepository.getPosts();
      emit(AllPostsSuccess(posts));
    } catch (e) {
      emit(
        AllPostsError(
          e is AppException ? e : AppException(message: e.toString()),
        ),
      );
    }
  }
}
