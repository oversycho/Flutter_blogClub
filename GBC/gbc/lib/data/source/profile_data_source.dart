import 'package:dio/dio.dart';
import 'package:gbc/common/auth_header.dart';
import 'package:gbc/common/jwt_helper.dart';
import 'package:gbc/data/common/http_response_validator.dart';
import 'package:gbc/data/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IProfileDataSource {
  Future<ProfileEntity> getMyProfile();
}

class ProfileRemoteDataSource
    with HttpResponseValidator
    implements IProfileDataSource {
  final Dio httpClient;

  ProfileRemoteDataSource(this.httpClient);

  @override
  Future<ProfileEntity> getMyProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Not authenticated');
    }
    final String? userId = userIdFromAccessToken(accessToken);
    if (userId == null) {
      throw Exception('Could not determine current user');
    }

    final response = await httpClient.get(
      'profiles',
      queryParameters: {'id': 'eq.$userId', 'select': '*'},
      options: await authHeader(),
    );
    validateResponse(response);

    final rows = response.data as List;
    if (rows.isEmpty) {
      throw Exception('Profile not found');
    }
    return ProfileEntity.fromJson(rows.first as Map<String, dynamic>);
  }
}
