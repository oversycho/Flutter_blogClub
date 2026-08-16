import 'package:dio/dio.dart';
import 'package:gbc/data/auth_info.dart';
import 'package:gbc/data/common/http_response_validator.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String email, String password);
  Future<AuthInfo?> register(String username, String email, String password);
  Future<AuthInfo> refreshToken(String token);
  Future<void> resendConfirmationEmail(String email);
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
        // Custom fields MUST be nested under "data" — Supabase silently
        // ignores unknown top-level fields rather than erroring on them.
        "data": {"username": username},
      },
    );
    validateResponse(response);

    // With email confirmation ON, Supabase returns a user but no
    // access_token — there's no session yet, just a pending account.
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
}
