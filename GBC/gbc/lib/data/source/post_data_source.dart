import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:gbc/common/auth_header.dart';
import 'package:gbc/common/http_client.dart';
import 'package:gbc/common/jwt_helper.dart';
import 'package:gbc/data/common/http_response_validator.dart';
import 'package:gbc/data/post.dart';
import 'package:gbc/data/post_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IPostDataSource {
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
  Future<List<PostEntity>> searchPosts(String query) async {
    final response = await httpClient.post(
      'rpc/search_posts',
      data: {'query': query},
    );
    validateResponse(response);
    return (response.data as List)
        .map((e) => PostEntity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<PostEntity>> getMyPosts() async {
    final userId = await _currentUserId();
    final response = await httpClient.get(
      'posts_feed',
      queryParameters: {
        'author_id': 'eq.$userId',
        'status': 'eq.published',
        'order': 'created_at.desc',
      },
      options: await authHeader(),
    );
    validateResponse(response);
    return (response.data as List)
        .map((e) => PostEntity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<PostEntity>> getMyBookmarkedPosts() async {
    // Step 1: which posts did I bookmark, newest first.
    final bookmarksResponse = await httpClient.get(
      'bookmarks',
      queryParameters: {'select': 'post_id', 'order': 'created_at.desc'},
      options: await authHeader(),
    );
    validateResponse(bookmarksResponse);
    final bookmarkRows = bookmarksResponse.data as List;
    if (bookmarkRows.isEmpty) return [];

    final postIds = bookmarkRows
        .map((row) => row['post_id'] as String)
        .toList();

    // Step 2: fetch those posts from the feed view.
    final postsResponse = await httpClient.get(
      'posts_feed',
      queryParameters: {'id': 'in.(${postIds.join(',')})'},
      options: await authHeader(),
    );
    validateResponse(postsResponse);
    final postsById = {
      for (final row in postsResponse.data as List)
        row['id'] as String: PostEntity.fromJson(row as Map<String, dynamic>),
    };

    // Re-order to match bookmark recency — 'in.(...)' doesn't preserve order.
    return postIds
        .where((id) => postsById.containsKey(id))
        .map((id) => postsById[id]!)
        .toList();
  }

  Future<String> _currentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Not authenticated');
    }
    final String? userId = userIdFromAccessToken(accessToken);
    if (userId == null) {
      throw Exception('Could not determine current user');
    }
    return userId;
  }

  @override
  Future<PostDetailEntity> getPostDetail(String slug) async {
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

  @override
  Future<PostEntity> createPost({
    required String title,
    String? excerpt,
    required String content,
    String? coverImageUrl,
    String? categoryId,
  }) async {
    final auth = await authHeader();
    final createResponse = await httpClient.post(
      'posts',
      data: {
        "title": title,
        if (excerpt != null && excerpt.isNotEmpty) "excerpt": excerpt,
        "content": content,
        if (coverImageUrl != null && coverImageUrl.isNotEmpty)
          "cover_image_url": coverImageUrl,
        if (categoryId != null && categoryId.isNotEmpty)
          "category_id": categoryId,
        "status": "published",
      },
      options: Options(
        headers: {...auth.headers ?? {}, 'Prefer': 'return=representation'},
      ),
    );
    validateResponse(createResponse);

    final createdRows = createResponse.data as List;
    final String newSlug = createdRows.first['slug'] as String;

    final feedResponse = await httpClient.get(
      'posts_feed',
      queryParameters: {'slug': 'eq.$newSlug'},
    );
    validateResponse(feedResponse);
    final feedRows = feedResponse.data as List;
    return PostEntity.fromJson(feedRows.first as Map<String, dynamic>);
  }

  @override
  Future<String> uploadCoverImage({
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('You must be logged in to upload an image.');
    }

    final String? userId = userIdFromAccessToken(accessToken);
    if (userId == null) {
      throw Exception('Could not determine user for upload path.');
    }

    // Storage RLS requires the first path segment to equal auth.uid().
    final String fileName =
        '${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
    final String path = '$userId/$fileName';

    final response = await storageClient.post(
      'object/post-covers/$path',
      data: bytes,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': _mimeTypeFor(fileExtension),
        },
      ),
    );
    validateResponse(response);

    return '$supabasePublicStorageUrl/post-covers/$path';
  }

  String _mimeTypeFor(String extension) {
    switch (extension.toLowerCase()) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      case 'jpg':
      case 'jpeg':
      default:
        return 'image/jpeg';
    }
  }
}
