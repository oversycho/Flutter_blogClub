class CommentEntity {
  final String id;
  final String postId;
  final String authorId;
  final String content;
  final String createdAt;
  CommentEntity.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      postId = json['post_id'],
      authorId = json['author_id'],
      content = json['content'],
      createdAt = json['created_at'];
}
