import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/core/domain/exceptions/jwt_exceptions.dart';
import 'package:five_on_4_backend/src/wrappers/libraries/dart_jsonwebtoken/dart_jsonwebtoken_wrapper.dart';

void main() {
  group("$DartJsonWebTokenWrapper", () {
    final jwtSecret = "jwtSecret";

    group(
      ".sign()",
      () {
        test(
          "given a secret is passed to the constructor"
          "when call sign() with a payload"
          "then should return expected token",
          () async {
            // setup
            final payload = {"key": "value"};
            final expiresIn = Duration(
              days: 7,
            );

            // given
            final dartJsonWebTokenWrapper = DartJsonWebTokenWrapper(
              jwtSecret: jwtSecret,
            );

            // when
            final token = dartJsonWebTokenWrapper.sign(
              payload: payload,
              expiresIn: expiresIn,
            );

            final expectedToken = _createTestToken(
              payload: payload,
              jwtSecret: jwtSecret,
              expiresIn: expiresIn,
            );

            expect(
              token,
              equals(expectedToken),
            );

            print("hello");

            // cleanup
          },
        );
      },
    );

    group(".verify()", () {
      test(
        "given an invalid token "
        "when call verify() "
        "then should throw expected exception",
        () async {
          // setup
          final dartJsonWebTokenWrapper = DartJsonWebTokenWrapper(
            jwtSecret: jwtSecret,
          );
          final token = "invalid_token";

          // when & then
          expect(
              () => dartJsonWebTokenWrapper.verify(
                    token: token,
                  ),
              throwsA(isA<JsonWebTokenInvalidException>()));

          // cleanup
        },
      );

      test(
        "given an expired token "
        "when call verify() "
        "then should throw expected exception",
        () async {
          // setup
          final dartJsonWebTokenWrapper = DartJsonWebTokenWrapper(
            jwtSecret: jwtSecret,
          );
          final payload = {"key": "value"};

          // given
          final token = _createTestToken(
            payload: payload,
            jwtSecret: jwtSecret,
            expiresIn: Duration(
              seconds: -1,
            ),
          );

          // when & then
          expect(
            () => dartJsonWebTokenWrapper.verify(
              token: token,
            ),
            throwsA(
              isA<JsonWebTokenExpiredException>(),
            ),
          );
        },
      );

      test(
        "given valid token"
        "when call verify()"
        "then should return expected result",
        () async {
          // setup
          final dartJsonWebTokenWrapper = DartJsonWebTokenWrapper(
            jwtSecret: jwtSecret,
          );

          final payload = {"key": "value"};

          // given
          final token = _createTestToken(
            payload: payload,
            jwtSecret: jwtSecret,
            expiresIn: Duration(
              days: 7,
            ),
          );

          // when
          final result = dartJsonWebTokenWrapper.verify<Map<String, dynamic>>(
            token: token,
          );

          // then
          expect(
            result,
            containsPair("key", equals("value")),
            // equals(payload),
          );

          // cleanup
        },
      );
    });
  });
}

String _createTestToken({
  required Map<String, dynamic> payload,
  required String jwtSecret,
  required Duration expiresIn,
}) {
  final jwt = JWT(payload);
  final token = jwt.sign(
    SecretKey(jwtSecret),
    expiresIn: expiresIn,
    // notBefore: Duration.zero
  );

  return token;
}
