import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc/common/app_exception.dart';
import 'package:gbc/data/post.dart';
import 'package:gbc/data/repo/post_repository.dart';

part 'my_posts_event.dart';
part 'my_posts_state.dart';

class MyPostsBloc extends Bloc<MyPostsEvent, MyPostsState> {
  final IPostReposiotry postRepository;

  MyPostsBloc({required this.postRepository}) : super(MyPostsLoading()) {
    on<MyPostsStarted>(_onStarted);
  }

  Future<void> _onStarted(
    MyPostsStarted event,
    Emitter<MyPostsState> emit,
  ) async {
    try {
      emit(MyPostsLoading());
      final posts = await postRepository.getMyPosts();
      emit(MyPostsSuccess(posts));
    } catch (e) {
      emit(
        MyPostsError(
          e is AppException ? e : AppException(message: e.toString()),
        ),
      );
    }
  }
}
