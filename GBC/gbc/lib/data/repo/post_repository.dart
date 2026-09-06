import 'package:flutter/foundation.dart';
import 'package:gbc/common/http_client.dart';
import 'package:gbc/data/post.dart';
import 'package:gbc/data/post_detail.dart';
import 'package:gbc/data/source/post_data_source.dart';

final postRepository = PostRepository(PostRemoteDataSource(restClient));

abstract class IPostReposiotry {
  Future<List<PostEntity>> getPosts();
  Future<List<PostEntity>> searchPosts(String query);
  Future<List<PostEntity>> getMyPosts();
  Future<List<PostEntity>> getMyBookmarkedPosts();
  Future<PostDetailEntity> getPostDetail(String slug);
  Future<bool> toggleLike(String postId);
  Future<bool> toggleBookmark(String postId);
  Future<void> incrementView(String postId);
  Future<PostEntity> createPost({
    required String title,
    String? excerpt,
    required String content,
    String? coverImageUrl,
    String? categoryId,
  });
  Future<String> uploadCoverImage({
    required Uint8List bytes,
    required String fileExtension,
  });
}

class PostRepository implements IPostReposiotry {
  final IPostDataSource dataSource;

  /// Fires whenever a post is successfully created, carrying the new post.
  /// Other blocs (e.g. HomeBloc) listen to this to know when to refresh,
  /// without any direct coupling to the create-post screen/bloc.
  static final ValueNotifier<PostEntity?> postCreatedNotifier = ValueNotifier(
    null,
  );

  PostRepository(this.dataSource);

  @override
  Future<List<PostEntity>> getPosts() {
    return dataSource.getPosts();
  }

  @override
  Future<List<PostEntity>> searchPosts(String query) {
    return dataSource.searchPosts(query);
  }

  @override
  Future<List<PostEntity>> getMyPosts() {
    return dataSource.getMyPosts();
  }

  @override
  Future<List<PostEntity>> getMyBookmarkedPosts() {
    return dataSource.getMyBookmarkedPosts();
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
    return dataSource.incrementView(postId).catchError((_) {});
  }

  @override
  Future<PostEntity> createPost({
    required String title,
    String? excerpt,
    required String content,
    String? coverImageUrl,
    String? categoryId,
  }) async {
    final post = await dataSource.createPost(
      title: title,
      excerpt: excerpt,
      content: content,
      coverImageUrl: coverImageUrl,
      categoryId: categoryId,
    );
    postCreatedNotifier.value = post;
    return post;
  }

  @override
  Future<String> uploadCoverImage({
    required Uint8List bytes,
    required String fileExtension,
  }) {
    return dataSource.uploadCoverImage(
      bytes: bytes,
      fileExtension: fileExtension,
    );
  }
}
