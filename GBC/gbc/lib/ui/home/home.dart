import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/data/post.dart';
import 'package:gbc/data/repo/banner_repository.dart';
import 'package:gbc/ui/home/bloc/home_bloc.dart';

import 'package:gbc/data/repo/categoires_repository.dart';
import 'package:gbc/data/repo/post_repository.dart';
import 'package:gbc/ui/widgets/image.dart';
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
                        );
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                );
              } else if (state is HomeLoading) {
                return Center(child: CupertinoActivityIndicator());
              } else if (state is HomeError) {
                return Column(
                  children: [
                    Text(state.exception.message),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                      },
                      child: Text('Re Try :>'),
                    ),
                  ],
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

class _HorizontalPostList extends StatelessWidget {
  final GestureTapCallback onTap;
  final List<PostEntity> post;

  const _HorizontalPostList({
    super.key,

    required this.onTap,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 550,

      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: post.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final posts = post[index];
          return SizedBox(
            width: 320,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 320,
                    height: 320,
                    child: ImageLoadingService(
                      imageUrl: posts.coverImageUrl,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Text(
                      posts.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Text(
                      posts.authorUsername,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
