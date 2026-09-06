import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc/common/app_exception.dart';
import 'package:gbc/data/post.dart';
import 'package:gbc/data/repo/post_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final IPostReposiotry postRepository;
  Timer? _debounce;

  SearchBloc({required this.postRepository}) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<_SearchDebounceFired>(_onDebounceFired);
  }

  void _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) {
    _debounce?.cancel();

    final trimmed = event.query.trim();
    if (trimmed.isEmpty) {
      emit(SearchInitial());
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      add(_SearchDebounceFired(trimmed));
    });
  }

  Future<void> _onDebounceFired(
    _SearchDebounceFired event,
    Emitter<SearchState> emit,
  ) async {
    try {
      emit(SearchLoading());
      final results = await postRepository.searchPosts(event.query);
      emit(SearchSuccess(results));
    } catch (e) {
      emit(
        SearchError(
          e is AppException ? e : AppException(message: e.toString()),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
