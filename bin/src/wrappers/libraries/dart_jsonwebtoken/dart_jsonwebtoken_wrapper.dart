import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../../../features/core/domain/exceptions/jwt_exceptions.dart';

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

  T verify<T>({
    // String verify({
    required String token,
  }) {
    try {
      final jwt = JWT.verify(token, SecretKey(_jwtSecret));
      final payload = jwt.payload as T;

      return payload;
    } on JWTExpiredException {
      throw JsonWebTokenExpiredException(token);
    } catch (e) {
      throw JsonWebTokenInvalidException(token);
    }
  }
}

// TODO possibly create value for this, move to values in core
// TODO probably dont need this even - or maybe we do
// class JWTValidatedPayload extends Equatable {
//   JWTValidatedPayload({
//     required this.isExpired,
//     required this.isInvalid,
//     // required this.isException,
//     required this.data,
//   });

//   final bool isExpired;
//   final bool isInvalid;
//   // final bool isException;
//   final Map<String, dynamic> data;

//   @override
//   List<Object?> get props => [
//         isExpired,
//         isInvalid,
//         // isException,
//         data,
//       ];
// }
