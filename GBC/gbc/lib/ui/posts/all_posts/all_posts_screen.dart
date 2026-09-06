import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/data/post.dart';
import 'package:gbc/data/repo/post_repository.dart';
import 'package:gbc/ui/posts/all_posts/bloc/all_posts_bloc.dart';
import 'package:gbc/ui/posts/post.dart';
import 'package:gbc/ui/posts/post_details.dart';
import 'package:gbc/ui/widgets/image.dart';

enum _ViewMode { grid, list }

class AllPostsScreen extends StatefulWidget {
  const AllPostsScreen({super.key});

  @override
  State<AllPostsScreen> createState() => _AllPostsScreenState();
}

class _AllPostsScreenState extends State<AllPostsScreen> {
  _ViewMode _viewMode = _ViewMode.grid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AllPostsBloc(postRepository: postRepository)..add(AllPostsStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Articles'),
          actions: [
            IconButton(
              tooltip: _viewMode == _ViewMode.grid
                  ? 'Switch to list view'
                  : 'Switch to grid view',
              icon: Icon(
                _viewMode == _ViewMode.grid
                    ? CupertinoIcons.list_bullet
                    : CupertinoIcons.square_grid_2x2,
              ),
              onPressed: () {
                setState(() {
                  _viewMode = _viewMode == _ViewMode.grid
                      ? _ViewMode.list
                      : _ViewMode.grid;
                });
              },
            ),
          ],
        ),
        body: BlocBuilder<AllPostsBloc, AllPostsState>(
          builder: (context, state) {
            if (state is AllPostsLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (state is AllPostsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.exception.message),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<AllPostsBloc>().add(AllPostsStarted()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final posts = (state as AllPostsSuccess).posts;
            if (posts.isEmpty) {
              return const Center(child: Text('No articles yet.'));
            }

            return _viewMode == _ViewMode.grid
                ? _ArticleGrid(posts: posts)
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) => Center(
                      child: postItems(
                        posts: posts[index],
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class _ArticleGrid extends StatelessWidget {
  final List<PostEntity> posts;
  const _ArticleGrid({required this.posts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) => _ArticleGridTile(post: posts[index]),
    );
  }
}

class _ArticleGridTile extends StatelessWidget {
  final PostEntity post;
  const _ArticleGridTile({required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => PostDetailsScreen(postSlug: post.slug),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: post.coverImageUrl != null
                  ? ImageLoadingService(
                      imageUrl: post.coverImageUrl!,
                      borderRadius: BorderRadius.circular(16),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        child: const Icon(CupertinoIcons.photo, size: 32),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            post.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
