import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc/data/categories.dart';
import 'package:gbc/data/post.dart';
import 'package:gbc/data/repo/categoires_repository.dart';
import 'package:gbc/data/repo/post_repository.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final IPostReposiotry postRepository;
  final ICategoriesRepository categoriesRepository;

  CreatePostBloc({
    required this.postRepository,
    required this.categoriesRepository,
  }) : super(CreatePostLoading()) {
    on<CreatePostStarted>(_onStarted);
    on<CreatePostSubmitted>(_onSubmitted);
  }

  Future<void> _onStarted(
    CreatePostStarted event,
    Emitter<CreatePostState> emit,
  ) async {
    try {
      emit(CreatePostLoading());
      final categories = await categoriesRepository.getCategories();
      emit(CreatePostReady(categories: categories));
    } catch (e) {
      // Categories failing to load shouldn't block writing entirely —
      // show the form with an empty category list rather than a dead end.
      emit(
        CreatePostReady(
          categories: const [],
          errorMessage: 'Could not load categories: $e',
        ),
      );
    }
  }

  Future<void> _onSubmitted(
    CreatePostSubmitted event,
    Emitter<CreatePostState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CreatePostReady) return;

    if (event.title.trim().isEmpty || event.content.trim().isEmpty) {
      emit(
        currentState.copyWith(
          errorMessage: 'Title and content are required',
        ),
      );
      return;
    }

    emit(currentState.copyWith(isSubmitting: true, errorMessage: null));
    try {
      String? coverImageUrl;
      if (event.coverImageBytes != null &&
          event.coverImageExtension != null) {
        coverImageUrl = await postRepository.uploadCoverImage(
          bytes: event.coverImageBytes!,
          fileExtension: event.coverImageExtension!,
        );
      }

      final post = await postRepository.createPost(
        title: event.title,
        excerpt: event.excerpt,
        content: event.content,
        coverImageUrl: coverImageUrl,
        categoryId: event.categoryId,
      );
      emit(CreatePostSuccess(post));
    } catch (e) {
      emit(
        currentState.copyWith(isSubmitting: false, errorMessage: e.toString()),
      );
    }
  }
}
