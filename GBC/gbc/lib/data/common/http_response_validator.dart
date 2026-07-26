import 'package:dio/dio.dart';
import 'package:gbc/common/app_exception.dart';

mixin HttpResponseValidator {
  validateResponse(Response response) {
    if (response.statusCode != 200) {
      throw AppException();
    }
  }
}
