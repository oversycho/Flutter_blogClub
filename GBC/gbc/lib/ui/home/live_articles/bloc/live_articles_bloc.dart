import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc/common/app_exception.dart';
import 'package:gbc/data/live_article.dart';
import 'package:gbc/data/repo/live_article_repository.dart';

part 'live_articles_event.dart';
part 'live_articles_state.dart';

class LiveArticlesBloc extends Bloc<LiveArticlesEvent, LiveArticlesState> {
  final ILiveArticleRepository repository;

  LiveArticlesBloc({required this.repository})
    : super(LiveArticlesLoading()) {
    on<LiveArticlesStarted>(_onStarted);
  }

  Future<void> _onStarted(
    LiveArticlesStarted event,
    Emitter<LiveArticlesState> emit,
  ) async {
    try {
      emit(LiveArticlesLoading());
      final articles = await repository.getGameNews();
      emit(LiveArticlesSuccess(articles));
    } catch (e) {
      emit(
        LiveArticlesError(
          e is AppException ? e : AppException(message: e.toString()),
        ),
      );
    }
  }
}
