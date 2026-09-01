import 'dart:typed_data';

import 'package:gbc/common/http_client.dart';
import 'package:gbc/data/profile.dart';
import 'package:gbc/data/source/profile_data_source.dart';

final profileRepository = ProfileRepository(ProfileRemoteDataSource(restClient));

abstract class IProfileRepository {
  Future<ProfileEntity> getMyProfile();
  Future<ProfileEntity> updateProfile({
    String? username,
    String? bio,
    String? avatarUrl,
  });
  Future<String> uploadAvatar({
    required Uint8List bytes,
    required String fileExtension,
  });
  Future<bool> checkUsernameAvailable(String username);
}

class ProfileRepository implements IProfileRepository {
  final IProfileDataSource dataSource;

  ProfileRepository(this.dataSource);

  @override
  Future<ProfileEntity> getMyProfile() {
    return dataSource.getMyProfile();
  }

  @override
  Future<ProfileEntity> updateProfile({
    String? username,
    String? bio,
    String? avatarUrl,
  }) {
    return dataSource.updateProfile(
      username: username,
      bio: bio,
      avatarUrl: avatarUrl,
    );
  }

  @override
  Future<String> uploadAvatar({
    required Uint8List bytes,
    required String fileExtension,
  }) {
    return dataSource.uploadAvatar(bytes: bytes, fileExtension: fileExtension);
  }

  @override
  Future<bool> checkUsernameAvailable(String username) {
    return dataSource.checkUsernameAvailable(username);
  }
}
