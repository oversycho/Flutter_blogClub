class PostDetailEntity {
  final String id;
  final String title;
  final String slug;
  final String? excerpt;
  final String content;
  final String? coverImageUrl;
  final String status;
  final int viewCount;

  final String authorUsername;
  final String? authorAvatarUrl;

  final String? categoryName;

  final int likesCount;
  final int commentsCount;
  final int bookmarksCount;

  final bool isLiked;
  final bool isBookmarked;

  PostDetailEntity({
    required this.id,
    required this.title,
    required this.slug,
    this.excerpt,
    required this.content,
    this.coverImageUrl,
    required this.status,
    required this.viewCount,
    required this.authorUsername,
    this.authorAvatarUrl,
    this.categoryName,
    required this.likesCount,
    required this.commentsCount,
    required this.bookmarksCount,
    required this.isLiked,
    required this.isBookmarked,
  });

  factory PostDetailEntity.fromJson(Map<String, dynamic> json) {
    return PostDetailEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      excerpt: json['excerpt'] as String?,
      content: json['content'] as String,
      coverImageUrl: json['cover_image_url'] as String?,
      status: json['status'] as String,
      viewCount: json['view_count'] as int,
      authorUsername: json['author_username'] as String,
      authorAvatarUrl: json['author_avatar_url'] as String?,
      categoryName: json['category_name'] as String?,
      // PostgREST can return bigint counts as int or string depending on
      // query shape — parse defensively to handle either.
      likesCount: int.parse(json['likes_count'].toString()),
      commentsCount: int.parse(json['comments_count'].toString()),
      bookmarksCount: int.parse(json['bookmarks_count'].toString()),
      isLiked: json['is_liked'] as bool,
      isBookmarked: json['is_bookmarked'] as bool,
    );
  }

  /// For optimistic UI updates right after a like/bookmark tap,
  /// without waiting on a full refetch.
  PostDetailEntity copyWith({
    int? likesCount,
    int? bookmarksCount,
    bool? isLiked,
    bool? isBookmarked,
  }) {
    return PostDetailEntity(
      id: id,
      title: title,
      slug: slug,
      excerpt: excerpt,
      content: content,
      coverImageUrl: coverImageUrl,
      status: status,
      viewCount: viewCount,
      authorUsername: authorUsername,
      authorAvatarUrl: authorAvatarUrl,
      categoryName: categoryName,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount,
      bookmarksCount: bookmarksCount ?? this.bookmarksCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
