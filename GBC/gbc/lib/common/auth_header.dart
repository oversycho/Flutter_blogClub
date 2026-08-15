import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Returns Dio [Options] with `Authorization: Bearer {token}` attached if
/// the user is logged in, or empty headers if not. Pass this as the
/// `options:` argument on any Dio call that needs auth:
///
///   await httpClient.post('rpc/toggle_like', data: {...}, options: await authHeader());
Future<Options> authHeader() async {
  final prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('access_token');

  return Options(
    headers: accessToken != null && accessToken.isNotEmpty
        ? {'Authorization': 'Bearer $accessToken'}
        : {},
  );
}
