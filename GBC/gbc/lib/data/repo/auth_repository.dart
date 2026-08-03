import 'package:flutter/material.dart';
import 'package:gbc/common/http_client.dart';
import 'package:gbc/data/auth_info.dart';
import 'package:gbc/data/source/auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepository = AuthRepository(AuthRemoteDataSource(authClient));

abstract class IAuthRepository {
  Future<void> login(String email, String password);
  Future<void> register(String username, String email, String password);
  Future<void> refreshToken();
}

class AuthRepository implements IAuthRepository {
  final IAuthDataSource dataSource;
  static final ValueNotifier<AuthInfo?> authChangeNotifier = ValueNotifier(
    null,
  );
  AuthRepository(this.dataSource);

  @override
  Future<void> login(String email, String password) async {
    final AuthInfo authInfo = await dataSource.login(email, password);
    _persistAuthTokens(authInfo);
    debugPrint("access Token IS ------------>        " + authInfo.accessToken);
  }

  @override
  Future<void> register(String username, String email, String password) async {
    final AuthInfo authInfo = await dataSource.register(
      username,
      email,
      password,
    );
    _persistAuthTokens(authInfo);
    debugPrint("access Token IS ------------>        " + authInfo.accessToken);
  }

  @override
  Future<void> refreshToken() async {
    final AuthInfo authInfo = await dataSource.refreshToken("aka43whyheto");

    _persistAuthTokens(authInfo);
  }

  Future<void> _persistAuthTokens(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("access_token", authInfo.accessToken);
    sharedPreferences.setString("refresh_token", authInfo.refreshToken);
  }

  Future<void> loadAuthInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String accessToken =
        sharedPreferences.getString("access_token") ?? '';
    final String refreshToken =
        sharedPreferences.getString("refresh_token") ?? '';
    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      authChangeNotifier.value = AuthInfo(accessToken, refreshToken);
    }
  }
}
