import 'package:dio/dio.dart';
import 'package:gbc/data/banner.dart';
import 'package:gbc/data/common/http_response_validator.dart';

abstract class IBannerDataSource {
  Future<List<BannerEntty>> getBanners();
}

class BannerRemoteDataSource
    with HttpResponseValidator
    implements IBannerDataSource {
  final Dio httpClient;

  BannerRemoteDataSource(this.httpClient);

  @override
  Future<List<BannerEntty>> getBanners() async {
    final response = await httpClient.get('banners');
    validateResponse(response);
    final List<BannerEntty> banners = [];
    (response.data as List).forEach((jsonObject) {
      banners.add(BannerEntty.fromJson(jsonObject));
    });
    return banners;
  }
}
