import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/data/repo/post_repository.dart';
import 'package:gbc/ui/posts/post.dart';
import 'package:gbc/ui/profile/saved/saved_posts_bloc.dart';

class SavedPostsScreen extends StatelessWidget {
  const SavedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavedPostsBloc(postRepository: postRepository)
        ..add(SavedPostsStarted()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Saved')),
        body: BlocBuilder<SavedPostsBloc, SavedPostsState>(
          builder: (context, state) {
            if (state is SavedPostsLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (state is SavedPostsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.exception.message),
                    ElevatedButton(
                      onPressed: () => context.read<SavedPostsBloc>().add(
                        SavedPostsStarted(),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final posts = (state as SavedPostsSuccess).posts;
            if (posts.isEmpty) {
              return const Center(child: Text("You haven't saved any posts yet."));
            }

            return ListView.builder(
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
