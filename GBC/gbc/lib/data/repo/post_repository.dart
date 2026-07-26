import 'package:gbc/common/http_client.dart';
import 'package:gbc/data/post.dart';
import 'package:gbc/data/source/post_data_source.dart';

final postRepository = PostRepository(PostRemoteDataSource(restClient));

abstract class IPostReposiotry {
  Future<List<PostEntity>> getPosts();
}

class PostRepository implements IPostReposiotry {
  final IPostDataSource dataSource;

  PostRepository(this.dataSource);
  @override
  Future<List<PostEntity>> getPosts() {
    return dataSource.getPosts();
  }
}
