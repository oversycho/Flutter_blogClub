import 'package:dio/dio.dart';

/// Base Supabase config for THIS project (sfkoqdnlvmznnvgdnbdr).
const String _supabaseUrl = 'https://sfkoqdnlvmznnvgdnbdr.supabase.co';
const String _supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNma29xZG5sdm16bm52Z2RuYmRyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQzMDc3NDAsImV4cCI6MjA5OTg4Mzc0MH0.LhQu8YzZ295ri4Ia2rNdAKz4kuK7Pu3q_dBrz76pq68';

/// REST client — for querying tables/views/rpc (profiles, posts_feed, etc).
/// No interceptor here on purpose — each data source method that needs
/// auth attaches the token itself via authHeader() (see auth_header.dart).
final Dio restClient = Dio(
  BaseOptions(
    baseUrl: '$_supabaseUrl/rest/v1/',
    headers: {'apikey': _supabaseAnonKey, 'Content-Type': 'application/json'},
  ),
);

/// Auth client — for signup/login/refresh/logout (different base path).
final Dio authClient = Dio(
  BaseOptions(
    baseUrl: '$_supabaseUrl/auth/v1/',
    headers: {'apikey': _supabaseAnonKey, 'Content-Type': 'application/json'},
  ),
);
