import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:gbc/common/auth_header.dart';
import 'package:gbc/common/http_client.dart';
import 'package:gbc/common/jwt_helper.dart';
import 'package:gbc/data/common/http_response_validator.dart';
import 'package:gbc/data/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IProfileDataSource {
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

class ProfileRemoteDataSource
    with HttpResponseValidator
    implements IProfileDataSource {
  final Dio httpClient;

  ProfileRemoteDataSource(this.httpClient);

  Future<String> _currentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Not authenticated');
    }
    final String? userId = userIdFromAccessToken(accessToken);
    if (userId == null) {
      throw Exception('Could not determine current user');
    }
    return userId;
  }

  @override
  Future<ProfileEntity> getMyProfile() async {
    final userId = await _currentUserId();

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

  @override
  Future<ProfileEntity> updateProfile({
    String? username,
    String? bio,
    String? avatarUrl,
  }) async {
    final userId = await _currentUserId();
    final auth = await authHeader();

    final response = await httpClient.patch(
      'profiles',
      queryParameters: {'id': 'eq.$userId'},
      data: {
        if (username != null) 'username': username,
        if (bio != null) 'bio': bio,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      },
      options: Options(
        headers: {...auth.headers ?? {}, 'Prefer': 'return=representation'},
      ),
    );
    validateResponse(response);

    final rows = response.data as List;
    if (rows.isEmpty) {
      throw Exception('Profile update failed');
    }
    return ProfileEntity.fromJson(rows.first as Map<String, dynamic>);
  }

  @override
  Future<bool> checkUsernameAvailable(String username) async {
    final response = await httpClient.post(
      'rpc/is_username_available',
      data: {'check_username': username},
    );
    validateResponse(response);
    return response.data as bool;
  }

  @override
  Future<String> uploadAvatar({
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('You must be logged in to upload an avatar.');
    }
    final userId = await _currentUserId();

    // Fixed filename (not timestamped) — a new upload simply overwrites the
    // old avatar rather than accumulating orphaned files in storage forever.
    final String path = '$userId/avatar.$fileExtension';

    final response = await storageClient.post(
      'object/avatars/$path',
      data: bytes,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': _mimeTypeFor(fileExtension),
          // Without this, re-uploading the same filename after a change
          // returns a 409 Conflict instead of replacing it.
          'x-upsert': 'true',
        },
      ),
    );
    validateResponse(response);

    // Cache-bust so the new avatar actually shows instead of a cached old one.
    final cacheBuster = DateTime.now().millisecondsSinceEpoch;
    return '$supabasePublicStorageUrl/avatars/$path?v=$cacheBuster';
  }

  String _mimeTypeFor(String extension) {
    switch (extension.toLowerCase()) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      case 'jpg':
      case 'jpeg':
      default:
        return 'image/jpeg';
    }
  }
}
