import "dart:core";

sealed class JsonWebTokenException implements Exception {
  JsonWebTokenException({
    required this.message,
  });

  final String message;

  @override
  String toString() {
    return "$runtimeType: $message";
  }
}

class JsonWebTokenExpiredException extends JsonWebTokenException {
  JsonWebTokenExpiredException(
    String token,
  ) : super(message: "JWT token $token has expired.");
}

class JsonWebTokenInvalidException extends JsonWebTokenException {
  JsonWebTokenInvalidException(
    String token,
  ) : super(message: "JWT token $token is invalid.");
}
