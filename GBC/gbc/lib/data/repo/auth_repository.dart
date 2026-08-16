import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:gbc/common/app_exception.dart';
import 'package:gbc/common/http_client.dart';
import 'package:gbc/data/auth_info.dart';
import 'package:gbc/data/source/auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Must match the scheme registered in AndroidManifest.xml / Info.plist,
/// and must be added to Supabase Dashboard > Authentication > URL
/// Configuration > Redirect URLs (and Site URL as the fallback).
const String _oauthCallbackScheme = 'gbc';
const String _oauthRedirectUrl = '$_oauthCallbackScheme://login-callback';
const String _supabaseUrl = 'https://sfkoqdnlvmznnvgdnbdr.supabase.co';

final authRepository = AuthRepository(AuthRemoteDataSource(authClient));

abstract class IAuthRepository {
  Future<void> login(String email, String password);

  /// Returns true if logged in immediately (email confirmation disabled),
  /// false if a confirmation email was sent and there's no session yet.
  Future<bool> register(String username, String email, String password);
  Future<void> refreshToken();
  Future<void> signOut();
  Future<void> resendConfirmationEmail(String email);

  /// provider must be 'google' or 'discord'.
  Future<void> signInWithOAuth(String provider);
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
    await _persistAuthTokens(authInfo);
    authChangeNotifier.value = authInfo;
    debugPrint("access Token IS ------------>        ${authInfo.accessToken}");
  }

  @override
  Future<bool> register(String username, String email, String password) async {
    final AuthInfo? authInfo = await dataSource.register(
      username,
      email,
      password,
    );
    if (authInfo == null) {
      return false; // email confirmation required, no session yet
    }
    await _persistAuthTokens(authInfo);
    authChangeNotifier.value = authInfo;
    debugPrint("access Token IS ------------>        ${authInfo.accessToken}");
    return true;
  }

  @override
  Future<void> refreshToken() async {
    if (authChangeNotifier.value != null) {
      final AuthInfo authInfo = await dataSource.refreshToken(
        authChangeNotifier.value!.refreshToken,
      );
      debugPrint(
        '****************** new Token is ${authInfo.refreshToken} ****************',
      );
      authChangeNotifier.value = authInfo;
      await _persistAuthTokens(authInfo);
    }
  }

  @override
  Future<void> resendConfirmationEmail(String email) {
    return dataSource.resendConfirmationEmail(email);
  }

  @override
  Future<void> signInWithOAuth(String provider) async {
    final String authUrl =
        '$_supabaseUrl/auth/v1/authorize?provider=$provider&redirect_to=$_oauthRedirectUrl';

    final String result = await FlutterWebAuth2.authenticate(
      url: authUrl,
      callbackUrlScheme: _oauthCallbackScheme,
    );

    // Supabase returns tokens in the URL FRAGMENT (after #), not as
    // query params, e.g. gbc://login-callback#access_token=...&refresh_token=...
    final Uri resultUri = Uri.parse(result);
    final Map<String, String> fragmentParams = Uri.splitQueryString(
      resultUri.fragment,
    );

    final String? accessToken = fragmentParams['access_token'];
    final String? refreshToken = fragmentParams['refresh_token'];

    if (accessToken == null || refreshToken == null) {
      final String errorDescription =
          fragmentParams['error_description'] ?? 'OAuth sign-in failed.';
      throw AppException(message: errorDescription);
    }

    final AuthInfo authInfo = AuthInfo(accessToken, refreshToken);
    await _persistAuthTokens(authInfo);
    authChangeNotifier.value = authInfo;
    debugPrint("OAuth ($provider) access token: ${authInfo.accessToken}");
  }

  Future<void> _persistAuthTokens(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString("access_token", authInfo.accessToken);
    await sharedPreferences.setString("refresh_token", authInfo.refreshToken);
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

  @override
  Future<void> signOut() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    authChangeNotifier.value = null;
  }
}
