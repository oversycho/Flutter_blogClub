import 'package:dio/dio.dart';
import 'package:gbc/common/auth_header.dart';
import 'package:gbc/data/comment.dart';
import 'package:gbc/data/common/http_response_validator.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getComments({required String postId});
  Future<CommentEntity> createComment({
    required String postId,
    required String content,
  });
}

class CommentRemoteDataSource
    with HttpResponseValidator
    implements ICommentDataSource {
  final Dio httpClient;

  CommentRemoteDataSource(this.httpClient);

  @override
  Future<List<CommentEntity>> getComments({required String postId}) async {
    final response = await httpClient.get(
      'comments',
      queryParameters: {
        'post_id': 'eq.$postId',
        // Embeds the comment author's username/avatar via the
        // author_id -> profiles foreign key — no separate query needed.
        'select': '*,profiles(username,avatar_url)',
        'order': 'created_at.asc',
      },
    );
    validateResponse(response);
    final List<CommentEntity> comments = [];
    (response.data as List).forEach((element) {
      comments.add(CommentEntity.fromJson(element));
    });
    return comments;
  }

  @override
  Future<CommentEntity> createComment({
    required String postId,
    required String content,
  }) async {
    final auth = await authHeader();
    final response = await httpClient.post(
      'comments',
      data: {'post_id': postId, 'content': content},
      options: Options(
        headers: {...auth.headers ?? {}, 'Prefer': 'return=representation'},
      ),
    );
    validateResponse(response);

    // The insert response doesn't include the author embed — re-fetch that
    // one row with the same embed getComments uses, so the new comment
    // shows the author's name/avatar immediately instead of blank.
    final createdId = (response.data as List).first['id'] as String;
    final fetchResponse = await httpClient.get(
      'comments',
      queryParameters: {
        'id': 'eq.$createdId',
        'select': '*,profiles(username,avatar_url)',
      },
    );
    validateResponse(fetchResponse);
    return CommentEntity.fromJson(
      (fetchResponse.data as List).first as Map<String, dynamic>,
    );
  }
}
