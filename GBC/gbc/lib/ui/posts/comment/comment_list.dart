import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbc/ui/home/home.dart';
import 'package:gbc/ui/posts/comment/bloc/comment_list_bloc.dart';
import 'package:gbc/ui/posts/comment/comment.dart';

/// Renders the comment list as a sliver. Expects a CommentListBloc to
/// already be provided higher up in the tree (see post_details.dart),
/// so it can be shared with the comment composer sitting alongside it.
class CommentList extends StatelessWidget {
  const CommentList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentListBloc, CommentListState>(
      builder: (context, state) {
        if (state is CommentListSuccess) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => commentItem(data: state.comments[index]),
              childCount: state.comments.length,
            ),
          );
        } else if (state is CommentListLoading) {
          return const SliverToBoxAdapter(
            child: Center(child: CupertinoActivityIndicator()),
          );
        } else if (state is CommentListError) {
          return SliverToBoxAdapter(
            child: appErorrWidget(
              exception: state.exception,
              onPressed: () {
                context.read<CommentListBloc>().add(CommentListStarted());
              },
            ),
          );
        } else {
          throw Exception('state is not supported');
        }
      },
    );
  }
}
