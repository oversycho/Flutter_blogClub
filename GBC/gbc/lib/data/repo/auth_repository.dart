import 'package:flutter/material.dart';
import 'package:gbc/common/http_client.dart';
import 'package:gbc/data/auth_info.dart';
import 'package:gbc/data/source/auth_data_source.dart';

final authRepository = AuthRepository(AuthRemoteDataSource(authClient));

abstract class IAuthRepository {
  Future<void> login(String email, String password);
}

class AuthRepository implements IAuthRepository {
  final IAuthDataSource dataSource;

  AuthRepository(this.dataSource);

  @override
  Future<void> login(String email, String password) async {
    final AuthInfo authInfo = await dataSource.login(email, password);
    debugPrint("access Token IS ------------>        " + authInfo.accessToken);
  }
}
