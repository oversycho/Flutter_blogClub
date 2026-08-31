import 'package:gbc/common/http_client.dart';
import 'package:gbc/data/profile.dart';
import 'package:gbc/data/source/profile_data_source.dart';

final profileRepository = ProfileRepository(ProfileRemoteDataSource(restClient));

abstract class IProfileRepository {
  Future<ProfileEntity> getMyProfile();
}

class ProfileRepository implements IProfileRepository {
  final IProfileDataSource dataSource;

  ProfileRepository(this.dataSource);

  @override
  Future<ProfileEntity> getMyProfile() {
    return dataSource.getMyProfile();
  }
}
