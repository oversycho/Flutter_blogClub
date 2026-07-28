import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/data/repo/comment_repository.dart';
import 'package:gbc/ui/home/home.dart';
import 'package:gbc/ui/posts/comment/bloc/comment_list_bloc.dart';
import 'package:gbc/ui/posts/comment/comment.dart';

class CommentList extends StatelessWidget {
  final String postId;

  const CommentList({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final CommentListBloc bloc = CommentListBloc(
          repository: commentRepository,
          postId: postId,
        );
        bloc.add(CommentListStarted());
        return bloc;
      },
      child: BlocBuilder<CommentListBloc, CommentListState>(
        // ignore: avoid_types_as_parameter_names
        builder: (context, State) {
          if (State is CommentListSuccess) {
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return commentItem(data: State.comments[index]);
              }, childCount: State.comments.length),
            );
          } else if (State is CommentListLoading) {
            return SliverToBoxAdapter(
              child: const Center(child: CupertinoActivityIndicator()),
            );
          } else if (State is CommentListError) {
            return SliverToBoxAdapter(
              child: appErorrWidget(
                exception: State.exception,
                onPressed: () {
                  BlocProvider.of<CommentListBloc>(
                    context,
                  ).add(CommentListStarted());
                },
              ),
            );
          } else {
            throw Exception('state is not supported');
          }
        },
      ),
    );
  }
}
