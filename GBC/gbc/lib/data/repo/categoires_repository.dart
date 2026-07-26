import 'package:gbc/common/http_client.dart';
import 'package:gbc/data/categories.dart';
import 'package:gbc/data/source/categoires_data_source.dart';

final categoriesRepository = CategoiresRepository(
  CategoriesRemoteDataSource(restClient),
);

abstract class ICategoriesRepository {
  Future<List<CategoriesEntity>> getCategories();
}

class CategoiresRepository implements ICategoriesRepository {
  final ICategoiresDataSource dataSource;

  CategoiresRepository(this.dataSource);

  @override
  Future<List<CategoriesEntity>> getCategories() => dataSource.getCategories();
}
