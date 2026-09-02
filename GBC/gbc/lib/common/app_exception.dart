class AppException implements Exception {
  final String message;
  AppException({this.message = 'Something went wrong. Please try again.'});

  // Defensive backstop: if anything ever calls e.toString() on this
  // instead of e.message, it still shows the real message instead of
  // "Instance of 'AppException'".
  @override
  String toString() => message;
}
