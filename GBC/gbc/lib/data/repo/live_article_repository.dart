import 'package:gbc/common/http_client.dart';
import 'package:gbc/data/live_article.dart';
import 'package:gbc/data/source/live_article_data_source.dart';

final liveArticleRepository = LiveArticleRepository(
  LiveArticleRemoteDataSource(newsApiClient),
);

abstract class ILiveArticleRepository {
  Future<List<LiveArticleEntity>> getGameNews();
}

class LiveArticleRepository implements ILiveArticleRepository {
  final ILiveArticleDataSource dataSource;

  LiveArticleRepository(this.dataSource);

  @override
  Future<List<LiveArticleEntity>> getGameNews() {
    return dataSource.getGameNews();
  }
}
