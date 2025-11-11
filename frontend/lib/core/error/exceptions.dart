class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException(this.message, {this.statusCode});
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}

class ValidationException implements Exception {
  final String message;
  final Map<String, List<String>>? errors;

  ValidationException(this.message, {this.errors});
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);
}
