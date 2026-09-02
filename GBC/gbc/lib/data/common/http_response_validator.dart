import 'package:dio/dio.dart';
import 'package:gbc/common/app_exception.dart';

mixin HttpResponseValidator {
  void validateResponse(Response response) {
    final statusCode = response.statusCode ?? 0;
    if (statusCode >= 200 && statusCode < 300) return;

    // Supabase error shapes vary by endpoint:
    // - GoTrue (auth):   {"error_code": "...", "msg": "..."}  or {"error": "...", "error_description": "..."}
    // - PostgREST (rest): {"code": "...", "message": "...", "details": ..., "hint": ...}
    final data = response.data;
    String message = 'Something went wrong ($statusCode).';
    if (data is Map) {
      message =
          (data['msg'] ??
                  data['error_description'] ??
                  data['message'] ??
                  data['error'] ??
                  message)
              .toString();
    }
    throw AppException(message: message);
  }
}
