import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/data/repo/post_repository.dart';
import 'package:gbc/ui/posts/post.dart';
import 'package:gbc/ui/search/bloc/search_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(postRepository: postRepository),
      child: Scaffold(
        appBar: AppBar(
          title: Builder(
            builder: (context) => TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search articles...',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                context.read<SearchBloc>().add(SearchQueryChanged(value));
              },
            ),
          ),
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchInitial) {
              return const Center(
                child: Text('Start typing to search articles.'),
              );
            }
            if (state is SearchLoading) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (state is SearchError) {
              return Center(child: Text(state.exception.message));
            }

            final results = (state as SearchSuccess).results;
            if (results.isEmpty) {
              return const Center(child: Text('No matching articles.'));
            }

            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) => Center(
                child: postItems(
                  posts: results[index],
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
