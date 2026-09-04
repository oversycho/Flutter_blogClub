class LiveArticleEntity {
  final String title;
  final String? description;
  final String url;
  final String? imageUrl;
  final String sourceName;
  final DateTime publishedAt;

  LiveArticleEntity({
    required this.title,
    this.description,
    required this.url,
    this.imageUrl,
    required this.sourceName,
    required this.publishedAt,
  });

  factory LiveArticleEntity.fromJson(Map<String, dynamic> json) {
    return LiveArticleEntity(
      title: json['title'] as String? ?? 'Untitled',
      description: json['description'] as String?,
      url: json['url'] as String,
      imageUrl: json['urlToImage'] as String?,
      sourceName:
          (json['source'] as Map<String, dynamic>?)?['name'] as String? ??
              'Unknown source',
      publishedAt: DateTime.tryParse(json['publishedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
