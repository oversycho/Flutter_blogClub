import 'package:dio/dio.dart';
import 'package:gbc/data/common/http_response_validator.dart';
import 'package:gbc/data/post.dart';

abstract class IPostDataSource {
  Future<List<PostEntity>> getPosts();
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
}
