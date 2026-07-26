class PostEntity {
  final String id;
  final String title;
  final String slug;
  final String excerpt;
  final String content;
  final String coverImageUrl;
  final String categoryName;
  final String authorUsername;
  final String authorAvatarUrl;

  PostEntity.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      title = json['title'] as String,
      slug = json['slug'] as String,
      excerpt = json['excerpt'] as String,
      content = json['content'] as String,
      coverImageUrl = json['cover_image_url'] as String,
      categoryName = json['category_name'] as String,
      authorUsername = json['author_username'] as String,
      authorAvatarUrl = json['author_avatar_url'] as String;
}
