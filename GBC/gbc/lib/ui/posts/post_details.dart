import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/data/auth_info.dart';
import 'package:gbc/data/post_detail.dart';
import 'package:gbc/data/repo/auth_repository.dart';
import 'package:gbc/data/repo/post_repository.dart';
import 'package:gbc/theme.dart';
import 'package:gbc/ui/auth/auth.dart';
import 'package:gbc/ui/posts/bloc/post_detail_bloc.dart';
import 'package:gbc/ui/posts/comment/comment_list.dart';
import 'package:gbc/ui/widgets/image.dart';

class PostDetailsScreen extends StatelessWidget {
  final String postSlug;

  const PostDetailsScreen({super.key, required this.postSlug});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostDetailBloc(postRepository)..add(PostDetailStarted(postSlug)),
      child: BlocBuilder<PostDetailBloc, PostDetailState>(
        builder: (context, state) {
          if (state is PostDetailLoading) {
            return const Scaffold(
              body: Center(child: CupertinoActivityIndicator()),
            );
          }
          if (state is PostDetailError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.exception.message),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PostDetailBloc>().add(
                          PostDetailStarted(postSlug),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final post = (state as PostDetailSuccess).post;

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: post.isLiked
                  ? Colors.redAccent
                  : const Color.fromARGB(255, 72, 72, 73),
              onPressed: () {
                final AuthInfo? authState =
                    AuthRepository.authChangeNotifier.value;
                final bool isAuthenticated =
                    authState != null && authState.accessToken.isNotEmpty;

                if (!isAuthenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: const Text('Log in to like posts'),
                      action: SnackBarAction(
                        label: 'Log in',
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (context) => const AuthScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                  return;
                }

                context.read<PostDetailBloc>().add(
                  PostDetailLikeButtonClicked(),
                );
              },
              child: Icon(
                post.isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                color: post.isLiked ? Colors.white : null,
              ),
            ),
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width * 0.8,
                  flexibleSpace: post.coverImageUrl != null
                      ? ImageLoadingService(
                          imageUrl: post.coverImageUrl!,
                          borderRadius: BorderRadius.circular(24),
                        )
                      : null,
                  foregroundColor: LightThemeColors.primaryTextColor,
                  backgroundColor: DarkThemeColors.backgroundColor,
                  actions: [
                    IconButton(
                      onPressed: () {
                        context.read<PostDetailBloc>().add(
                          PostDetailBookmarkButtonClicked(),
                        );
                      },
                      icon: Icon(
                        post.isBookmarked
                            ? CupertinoIcons.bookmark_fill
                            : CupertinoIcons.bookmark,
                      ),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (post.excerpt != null)
                              Text(
                                post.excerpt!,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            if (post.categoryName != null)
                              Text(
                                post.categoryName!,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                          decoration: BoxDecoration(
                            color: DarkThemeColors.surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 45,
                                        height: 45,
                                        child: post.authorAvatarUrl != null
                                            ? ImageLoadingService(
                                                imageUrl: post.authorAvatarUrl!,
                                                borderRadius:
                                                    BorderRadius.circular(45),
                                              )
                                            : const CircleAvatar(
                                                child: Icon(
                                                  CupertinoIcons.person,
                                                ),
                                              ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(post.authorUsername),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _StatColumn(
                                      icon: CupertinoIcons.eye,
                                      value: post.viewCount,
                                    ),
                                    const SizedBox(width: 12),
                                    _StatColumn(
                                      icon: CupertinoIcons.heart,
                                      value: post.likesCount,
                                    ),
                                    const SizedBox(width: 12),
                                    _StatColumn(
                                      icon: CupertinoIcons.bookmark,
                                      value: post.bookmarksCount,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: DarkThemeColors.surfaceColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
                          width: MediaQuery.of(context).size.width,
                          child: Text(post.content),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${post.commentsCount} Comments'),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Leave a comment'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                CommentList(postId: post.id),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final IconData icon;
  final int value;
  const _StatColumn({required this.icon, required this.value});

  String get _formatted {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(icon), Text(_formatted)],
    );
  }
}
