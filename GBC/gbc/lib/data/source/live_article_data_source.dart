import 'package:dio/dio.dart';
import 'package:gbc/common/app_exception.dart';
import 'package:gbc/data/live_article.dart';

abstract class ILiveArticleDataSource {
  Future<List<LiveArticleEntity>> getGameNews();
}

class LiveArticleRemoteDataSource implements ILiveArticleDataSource {
  final Dio httpClient;

  LiveArticleRemoteDataSource(this.httpClient);

  @override
  Future<List<LiveArticleEntity>> getGameNews() async {
    final response = await httpClient.get(
      'everything',
      queryParameters: {
        'q': 'gaming OR "video game" OR esports',
        'language': 'en',
        'sortBy': 'publishedAt',
        'pageSize': '20',
      },
    );

    // NewsAPI's own error shape: {"status": "error", "code": ..., "message": ...}
    // — different from Supabase's, so this doesn't reuse HttpResponseValidator.
    final data = response.data;
    if (data is! Map || data['status'] != 'ok') {
      final message = (data is Map ? data['message'] : null) as String? ??
          'Failed to load game news.';
      throw AppException(message: message);
    }

    final articles = data['articles'] as List;
    return articles
        .map((e) => LiveArticleEntity.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
