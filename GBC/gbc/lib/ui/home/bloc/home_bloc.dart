import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc/common/app_exception.dart';
import 'package:gbc/data/banner.dart';
import 'package:gbc/data/categories.dart';
import 'package:gbc/data/post.dart';
import 'package:gbc/data/repo/banner_repository.dart';
import 'package:gbc/data/repo/categoires_repository.dart';
import 'package:gbc/data/repo/post_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository bannerRepository;
  final IPostReposiotry postReposiotry;
  final ICategoriesRepository categoriesRepository;
  HomeBloc({
    required this.bannerRepository,
    required this.postReposiotry,
    required this.categoriesRepository,
  }) : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted || event is HomeRefresh) {
        try {
          emit(HomeLoading());
          final banners = await bannerRepository.getBanners();
          final posts = await postReposiotry.getPosts();
          final categories = await categoriesRepository.getCategories();

          emit(
            HomeSuccess(banners: banners, categories: categories, posts: posts),
          );
        } catch (e) {
          emit(
            HomeError(
              exception: e is AppException
                  ? e
                  : AppException(message: 'Erorr  Happend :('),
            ),
          );
        }
      }
    });
  }
}
