import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:equatable/equatable.dart';

class DartJsonWebTokenWrapper {
  DartJsonWebTokenWrapper({
    required String jwtSecret,
  }) : _jwtSecret = jwtSecret;

  final String _jwtSecret;

  String sign({
    required Map<String, dynamic> payload,
    required Duration expiresIn,
  }) {
    final jwt = JWT(payload);
    final token = jwt.sign(
      SecretKey(_jwtSecret),
      expiresIn: expiresIn,
    );

    return token;
  }

  // Map<String, dynamic> verify({
  JWTValidatedPayload verify({
    required String token,
  }) {
    try {
      final jwt = JWT.verify(token, SecretKey(_jwtSecret));

      // TODO maybe this can return whether the token is valid or not, and expired and so on

      // TODO this is dynamic
      return JWTValidatedPayload(
        isInvalid: false,
        isExpired: false,
        // isException: false,
        data: jwt.payload,
      );
    } on JWTExpiredException {
      return JWTValidatedPayload(
        isInvalid: false,
        isExpired: true,
        // isException: false,
        data: {},
      );
    } catch (e) {
      return JWTValidatedPayload(
        isInvalid: true,
        isExpired: false,
        // isException: true,
        data: {},
      );
    }
  }
}

// TODO possibly create value for this, move to values in core
class JWTValidatedPayload extends Equatable {
  JWTValidatedPayload({
    required this.isExpired,
    required this.isInvalid,
    // required this.isException,
    required this.data,
  });

  final bool isExpired;
  final bool isInvalid;
  // final bool isException;
  final Map<String, dynamic> data;

  @override
  List<Object?> get props => [
        isExpired,
        isInvalid,
        // isException,
        data,
      ];
}
