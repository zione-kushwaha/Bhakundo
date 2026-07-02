class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'A server error occurred.']);

  @override
  String toString() => 'ServerException: $message';
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'A cache error occurred.']);

  @override
  String toString() => 'CacheException: $message';
}
