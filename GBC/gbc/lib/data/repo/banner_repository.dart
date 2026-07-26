import 'package:gbc/common/http_client.dart';
import 'package:gbc/data/banner.dart';
import 'package:gbc/data/source/banner_data_source.dart';

final bannerRepository = BannerRepository(BannerRemoteDataSource(restClient));

abstract class IBannerRepository {
  Future<List<BannerEntty>> getBanners();
}

class BannerRepository implements IBannerRepository {
  final IBannerDataSource dataSource;

  BannerRepository(this.dataSource);
  @override
  Future<List<BannerEntty>> getBanners() => dataSource.getBanners();
}
