import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Base Supabase config for THIS project (sfkoqdnlvmznnvgdnbdr).
const String _supabaseUrl = 'https://sfkoqdnlvmznnvgdnbdr.supabase.co';
const String _supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNma29xZG5sdm16bm52Z2RuYmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQzMDc3NDAsImV4cCI6MjA5OTg4Mzc0MH0.LhQu8YzZ295ri4Ia2rNdAKz4kuK7Pu3q_dBrz76pq68';

/// By default, Dio throws a DioException for ANY status code outside
/// 200-299 — BEFORE your code ever sees the response body. That means
/// HttpResponseValidator (which parses Supabase's real error message
/// out of response.data) never actually runs for errors; Dio throws
/// first. Setting validateStatus to always return true makes Dio hand
/// back every response normally, so our own validator can inspect it
/// and surface Supabase's actual message instead of Dio's generic
/// "status code 400" boilerplate.
bool _neverThrowOnStatus(int? status) => true;

/// Refreshes the access token using the stored refresh_token, talking to
/// authClient directly. Lives here (not in auth_repository.dart) on
/// purpose — this file must NOT import auth_repository.dart, since that
/// file already imports THIS one (for authClient) and a two-way import
/// between them is exactly the circular dependency we're avoiding.
/// Returns true if refresh succeeded and new tokens were persisted.
Future<bool> _tryRefreshToken() async {
  final prefs = await SharedPreferences.getInstance();
  final String? refreshToken = prefs.getString('refresh_token');
  if (refreshToken == null || refreshToken.isEmpty) return false;

  final response = await authClient.post(
    'token?grant_type=refresh_token',
    data: {'refresh_token': refreshToken},
  );

  final statusCode = response.statusCode ?? 0;
  if (statusCode < 200 || statusCode >= 300) return false;

  final String? newAccessToken = response.data['access_token'] as String?;
  final String? newRefreshToken = response.data['refresh_token'] as String?;
  if (newAccessToken == null || newRefreshToken == null) return false;

  await prefs.setString('access_token', newAccessToken);
  await prefs.setString('refresh_token', newRefreshToken);
  return true;
}

/// REST client — for querying tables/views/rpc (profiles, posts_feed, etc).
/// Each data source method attaches its own auth header via authHeader()
/// (see auth_header.dart) — this interceptor's ONLY job is: if a request
/// comes back 401 (expired token), silently refresh and retry it ONCE
/// before giving up. Since validateStatus never throws, a 401 arrives as
/// a normal Response, which is why this hooks onResponse, not onError.
final Dio restClient = Dio(
  BaseOptions(
    baseUrl: '$_supabaseUrl/rest/v1/',
    headers: {'apikey': _supabaseAnonKey, 'Content-Type': 'application/json'},
    validateStatus: _neverThrowOnStatus,
  ),
)..interceptors.add(
    InterceptorsWrapper(
      onResponse: (response, handler) async {
        final bool isUnauthorized = response.statusCode == 401;
        final bool alreadyRetried =
            response.requestOptions.extra['retried_after_refresh'] == true;

        if (isUnauthorized && !alreadyRetried) {
          final bool refreshed = await _tryRefreshToken();
          if (refreshed) {
            final prefs = await SharedPreferences.getInstance();
            final String? newAccessToken = prefs.getString('access_token');

            final retryOptions = response.requestOptions;
            retryOptions.extra['retried_after_refresh'] = true;
            if (newAccessToken != null &&
                retryOptions.headers.containsKey('Authorization')) {
              retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
            }

            try {
              final retryResponse = await restClient.fetch(retryOptions);
              return handler.resolve(retryResponse);
            } catch (_) {
              // Retry itself failed — fall through and surface the
              // original 401 rather than throwing something new.
            }
          }
        }
        handler.next(response);
      },
    ),
  );

/// Auth client — for signup/login/refresh/logout (different base path).
final Dio authClient = Dio(
  BaseOptions(
    baseUrl: '$_supabaseUrl/auth/v1/',
    headers: {'apikey': _supabaseAnonKey, 'Content-Type': 'application/json'},
    validateStatus: _neverThrowOnStatus,
  ),
);

/// Storage client — for uploading files (post cover images, avatars, etc).
final Dio storageClient = Dio(
  BaseOptions(
    baseUrl: '$_supabaseUrl/storage/v1/',
    headers: {'apikey': _supabaseAnonKey},
    validateStatus: _neverThrowOnStatus,
  ),
)..interceptors.add(
    InterceptorsWrapper(
      onResponse: (response, handler) async {
        final bool isUnauthorized = response.statusCode == 401;
        final bool alreadyRetried =
            response.requestOptions.extra['retried_after_refresh'] == true;

        if (isUnauthorized && !alreadyRetried) {
          final bool refreshed = await _tryRefreshToken();
          if (refreshed) {
            final prefs = await SharedPreferences.getInstance();
            final String? newAccessToken = prefs.getString('access_token');

            final retryOptions = response.requestOptions;
            retryOptions.extra['retried_after_refresh'] = true;
            if (newAccessToken != null &&
                retryOptions.headers.containsKey('Authorization')) {
              retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
            }

            try {
              final retryResponse = await storageClient.fetch(retryOptions);
              return handler.resolve(retryResponse);
            } catch (_) {}
          }
        }
        handler.next(response);
      },
    ),
  );

/// Public base URL for reading files back out of public buckets.
const String supabasePublicStorageUrl =
    '$_supabaseUrl/storage/v1/object/public';

/// Get a free key at https://newsapi.org — sign up, copy your key here.
/// Free "Developer" tier: works fine from a compiled mobile app, but
/// NewsAPI blocks direct browser/CORS requests on that tier — so this
/// won't work if you build for Flutter Web without a backend proxy.
const String _newsApiKey = 'YOUR_NEWSAPI_KEY_HERE';

final Dio newsApiClient = Dio(
  BaseOptions(
    baseUrl: 'https://newsapi.org/v2/',
    headers: {'X-Api-Key': _newsApiKey},
    validateStatus: _neverThrowOnStatus,
  ),
);
