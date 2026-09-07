import 'package:dio/dio.dart';
import 'package:gbc/data/auth_info.dart';
import 'package:gbc/data/common/http_response_validator.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String email, String password);
  Future<AuthInfo?> register(String username, String email, String password);
  Future<AuthInfo> refreshToken(String token);
  Future<void> resendConfirmationEmail(String email);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> updatePassword({
    required String accessToken,
    required String newPassword,
  });
}

class AuthRemoteDataSource
    with HttpResponseValidator
    implements IAuthDataSource {
  final Dio httpClient;

  AuthRemoteDataSource(this.httpClient);

  @override
  Future<AuthInfo> login(String email, String password) async {
    final response = await httpClient.post(
      'token?grant_type=password',
      data: {"email": email, "password": password},
    );
    validateResponse(response);
    return AuthInfo(
      response.data["access_token"],
      response.data["refresh_token"],
    );
  }

  @override
  Future<AuthInfo> refreshToken(String token) async {
    final response = await httpClient.post(
      "token?grant_type=refresh_token",
      data: {"refresh_token": token},
    );
    validateResponse(response);
    return AuthInfo(
      response.data["access_token"],
      response.data["refresh_token"],
    );
  }

  @override
  Future<AuthInfo?> register(
    String username,
    String email,
    String password,
  ) async {
    final response = await httpClient.post(
      'signup',
      data: {
        "email": email,
        "password": password,
        "data": {"username": username},
      },
    );
    validateResponse(response);

    if (response.data["access_token"] != null) {
      return AuthInfo(
        response.data["access_token"],
        response.data["refresh_token"],
      );
    }
    return null;
  }

  @override
  Future<void> resendConfirmationEmail(String email) async {
    final response = await httpClient.post(
      'resend',
      data: {"type": "signup", "email": email},
    );
    validateResponse(response);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    // redirect_to must exactly match an entry in Supabase's
    // Authentication > URL Configuration > Redirect URLs allow-list,
    // or Supabase silently falls back to the project's Site URL instead.
    final response = await httpClient.post(
      'recover',
      queryParameters: {'redirect_to': 'gbcreset://reset-password'},
      data: {'email': email},
    );
    validateResponse(response);
  }

  @override
  Future<void> updatePassword({
    required String accessToken,
    required String newPassword,
  }) async {
    // Supabase identifies WHICH user's password to change via the
    // recovery access_token in the Authorization header — not via any
    // field in the request body.
    final response = await httpClient.put(
      'user',
      data: {'password': newPassword},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    validateResponse(response);
  }
}
