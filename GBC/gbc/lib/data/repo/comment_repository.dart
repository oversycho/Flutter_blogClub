import 'package:gbc/common/http_client.dart';
import 'package:gbc/data/comment.dart';
import 'package:gbc/data/source/comment_data_source.dart';

final commentRepository = CommentRepository(
  CommentRemoteDataSource(restClient),
);

abstract class ICommentRepository {
  Future<List<CommentEntity>> getComments({required String postId});
  Future<CommentEntity> createComment({
    required String postId,
    required String content,
  });
}

class CommentRepository implements ICommentRepository {
  final ICommentDataSource dataSource;

  CommentRepository(this.dataSource);

  @override
  Future<List<CommentEntity>> getComments({required String postId}) {
    return dataSource.getComments(postId: postId);
  }

  @override
  Future<CommentEntity> createComment({
    required String postId,
    required String content,
  }) {
    return dataSource.createComment(postId: postId, content: content);
  }
}
