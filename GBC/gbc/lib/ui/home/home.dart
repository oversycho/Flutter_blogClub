import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/common/app_exception.dart';
import 'package:gbc/data/categories.dart';
import 'package:gbc/data/post.dart';
import 'package:gbc/data/repo/banner_repository.dart';
import 'package:gbc/ui/categories/category.dart';
import 'package:gbc/ui/home/bloc/home_bloc.dart';

import 'package:gbc/data/repo/categoires_repository.dart';
import 'package:gbc/data/repo/post_repository.dart';
import 'package:gbc/ui/home/footer.dart';
import 'package:gbc/ui/posts/post.dart';

import 'package:gbc/ui/widgets/slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBloc(
          bannerRepository: bannerRepository,
          postReposiotry: postRepository,
          categoriesRepository: categoriesRepository,
        );
        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeSuccess) {
                return ListView.builder(
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Container(
                          height: 56,
                          alignment: Alignment.center,
                          child: Image.asset('assets/img/GBC_logo.png'),
                        );
                      case 2:
                        return BannerSlider(banners: state.banners);
                      case 3:
                        return _HorizontalPostList(
                          onTap: () {},
                          post: state.posts,
                          title: 'Latest Feeds',
                        );
                      case 4:
                        return _HorizontalCategoryList(
                          categories: state.categories,
                          title: 'Categories',
                          onTap: () {},
                        );
                      case 5:
                        return SizedBox(height: 100);

                      case 6:
                        return FooterHome();
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                );
              } else if (state is HomeLoading) {
                return Center(child: CupertinoActivityIndicator());
              } else if (state is HomeError) {
                return appErorrWidget(
                  exception: state.exception,
                  onPressed: () {
                    BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                  },
                );
              } else {
                throw Exception('state is un supported');
              }
            },
          ),
        ),
      ),
    );
  }
}

class appErorrWidget extends StatelessWidget {
  final AppException exception;
  final GestureTapCallback onPressed;
  const appErorrWidget({
    super.key,
    required this.exception,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(exception.message),
        ElevatedButton(onPressed: onPressed, child: Text('Re Try :>')),
      ],
    );
  }
}

class _HorizontalCategoryList extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final List<CategoriesEntity> categories;
  const _HorizontalCategoryList({
    required this.title,
    required this.onTap,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              TextButton(onPressed: onTap, child: Text('See  All !')),
            ],
          ),
        ),

        SizedBox(
          height: 90,

          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final category = categories[index];
              return categoryItem(
                categoriess: category,
                borderRadius: BorderRadius.circular(12),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HorizontalPostList extends StatelessWidget {
  final GestureTapCallback onTap;
  final List<PostEntity> post;
  final String title;

  const _HorizontalPostList({
    required this.onTap,
    required this.post,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              TextButton(onPressed: onTap, child: Text('See All !')),
            ],
          ),
        ),
        SizedBox(
          height: 420,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: post.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final posts = post[index];
              return postItems(
                posts: posts,
                borderRadius: BorderRadius.circular(24),
              );
            },
          ),
        ),
      ],
    );
  }
}
