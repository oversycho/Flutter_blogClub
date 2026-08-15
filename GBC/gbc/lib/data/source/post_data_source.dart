import 'package:dio/dio.dart';
import 'package:gbc/common/auth_header.dart';
import 'package:gbc/data/common/http_response_validator.dart';
import 'package:gbc/data/post.dart';
import 'package:gbc/data/post_detail.dart';

abstract class IPostDataSource {
  Future<List<PostEntity>> getPosts();
  Future<PostDetailEntity> getPostDetail(String slug);
  Future<bool> toggleLike(String postId);
  Future<bool> toggleBookmark(String postId);
  Future<void> incrementView(String postId);
}

class PostRemoteDataSource
    with HttpResponseValidator
    implements IPostDataSource {
  final Dio httpClient;

  PostRemoteDataSource(this.httpClient);

  @override
  Future<List<PostEntity>> getPosts() async {
    final response = await httpClient.get('posts_feed');
    validateResponse(response);
    final posts = <PostEntity>[];
    (response.data as List).forEach((element) {
      posts.add(PostEntity.fromJson(element));
    });
    return posts;
  }

  @override
  Future<PostDetailEntity> getPostDetail(String slug) async {
    // Auth is attached (not required, but if present it makes is_liked /
    // is_bookmarked accurate for the logged-in user instead of always false).
    final response = await httpClient.post(
      'rpc/get_post_detail',
      data: {"post_slug": slug},
      options: await authHeader(),
    );
    validateResponse(response);
    final rows = response.data as List;
    if (rows.isEmpty) {
      throw Exception('Post not found');
    }
    return PostDetailEntity.fromJson(rows.first as Map<String, dynamic>);
  }

  @override
  Future<bool> toggleLike(String postId) async {
    final response = await httpClient.post(
      'rpc/toggle_like',
      data: {"target_post_id": postId},
      options: await authHeader(),
    );
    validateResponse(response);
    return response.data as bool;
  }

  @override
  Future<bool> toggleBookmark(String postId) async {
    final response = await httpClient.post(
      'rpc/toggle_bookmark',
      data: {"target_post_id": postId},
      options: await authHeader(),
    );
    validateResponse(response);
    return response.data as bool;
  }

  @override
  Future<void> incrementView(String postId) async {
    final response = await httpClient.post(
      'rpc/increment_post_view',
      data: {"target_post_id": postId},
      options: await authHeader(),
    );
    validateResponse(response);
  }
}
