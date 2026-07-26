import 'package:dio/dio.dart';
import 'package:gbc/data/categories.dart';
import 'package:gbc/data/common/http_response_validator.dart';

abstract class ICategoiresDataSource {
  Future<List<CategoriesEntity>> getCategories();
}

class CategoriesRemoteDataSource
    with HttpResponseValidator
    implements ICategoiresDataSource {
  final Dio httpClient;

  CategoriesRemoteDataSource(this.httpClient);

  @override
  Future<List<CategoriesEntity>> getCategories() async {
    final response = await httpClient.get('categories');
    validateResponse(response);
    final List<CategoriesEntity> categories = [];
    (response.data as List).forEach((jsonObject) {
      categories.add(CategoriesEntity.fromJson(jsonObject));
    });
    return categories;
  }
}
