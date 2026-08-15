import 'package:gbc/common/http_client.dart';
import 'package:gbc/data/post.dart';
import 'package:gbc/data/post_detail.dart';
import 'package:gbc/data/source/post_data_source.dart';

final postRepository = PostRepository(PostRemoteDataSource(restClient));

abstract class IPostReposiotry {
  Future<List<PostEntity>> getPosts();
  Future<PostDetailEntity> getPostDetail(String slug);
  Future<bool> toggleLike(String postId);
  Future<bool> toggleBookmark(String postId);
  Future<void> incrementView(String postId);
}

class PostRepository implements IPostReposiotry {
  final IPostDataSource dataSource;

  PostRepository(this.dataSource);
  @override
  Future<List<PostEntity>> getPosts() {
    return dataSource.getPosts();
  }

  @override
  Future<PostDetailEntity> getPostDetail(String slug) {
    return dataSource.getPostDetail(slug);
  }

  @override
  Future<bool> toggleLike(String postId) {
    return dataSource.toggleLike(postId);
  }

  @override
  Future<bool> toggleBookmark(String postId) {
    return dataSource.toggleBookmark(postId);
  }

  @override
  Future<void> incrementView(String postId) {
    // Fire-and-forget from the caller's perspective — a failed view-count
    // bump shouldn't ever block or error out the reading experience.
    return dataSource.incrementView(postId).catchError((_) {});
  }
}
