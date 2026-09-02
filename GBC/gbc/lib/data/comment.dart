class CommentEntity {
  final String id;
  final String postId;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final String? authorUsername;
  final String? authorAvatarUrl;

  CommentEntity.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      postId = json['post_id'] as String,
      authorId = json['author_id'] as String,
      content = json['content'] as String,
      createdAt = DateTime.parse(json['created_at'] as String),
      authorUsername =
          (json['profiles'] as Map<String, dynamic>?)?['username'] as String?,
      authorAvatarUrl =
          (json['profiles'] as Map<String, dynamic>?)?['avatar_url']
              as String?;
}
