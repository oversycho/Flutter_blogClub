import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/data/repo/post_repository.dart';
import 'package:gbc/ui/posts/post.dart';
import 'package:gbc/ui/profile/my_posts/my_posts_bloc.dart';

class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MyPostsBloc(postRepository: postRepository)..add(MyPostsStarted()),
      child: Scaffold(
        appBar: AppBar(title: const Text('My Posts')),
        body: BlocBuilder<MyPostsBloc, MyPostsState>(
          builder: (context, state) {
            if (state is MyPostsLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (state is MyPostsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.exception.message),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<MyPostsBloc>().add(MyPostsStarted()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final posts = (state as MyPostsSuccess).posts;
            if (posts.isEmpty) {
              return const Center(
                child: Text("You haven't published any posts yet."),
              );
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
