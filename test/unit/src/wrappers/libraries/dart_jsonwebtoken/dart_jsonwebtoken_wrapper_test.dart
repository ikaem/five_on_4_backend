import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:test/test.dart';

import '../../../../../../bin/src/wrappers/libraries/dart_jsonwebtoken/dart_jsonwebtoken_wrapper.dart';

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
        "then should return expected payload",
        () async {
          // setup
          final dartJsonWebTokenWrapper = DartJsonWebTokenWrapper(
            jwtSecret: jwtSecret,
          );

          // given
          // final token = _createTestToken(
          //   payload: {"key": "value"},
          //   jwtSecret: jwtSecret,
          //   expiresIn: Duration(
          //     days: 7,
          //   ),
          // );
          final token = "invalid_token";

          // when
          final payload = dartJsonWebTokenWrapper.verify(
            token: token,
          );

          // then
          final expectedPayload = JWTValidatedPayload(
            isInvalid: true,
            isExpired: false,
            // isException: false,
            data: {},
          );

          expect(
            payload,
            equals(expectedPayload),
            // equals({"key": "value"}),
          );

          // cleanup
        },
      );

      test(
        "given an expired token "
        "when call verify() "
        "then should return expected payload",
        () async {
          // setup
          final dartJsonWebTokenWrapper = DartJsonWebTokenWrapper(
            jwtSecret: jwtSecret,
          );

          // given
          final token = _createTestToken(
            payload: {"key": "value"},
            jwtSecret: jwtSecret,
            expiresIn: Duration(
              seconds: -1,
            ),
          );

          // when
          final payload = dartJsonWebTokenWrapper.verify(
            token: token,
          );

          // then
          final expectedPayload = JWTValidatedPayload(
            isInvalid: false,
            isExpired: true,
            // isException: false,
            data: {},
          );

          expect(
            payload,
            equals(expectedPayload),
            // equals({"key": "value"}),
          );

          // cleanup
        },
      );

      test(
        "given a valid token "
        "when call verify() "
        "then should return expected payload",
        () async {
          // setup
          final dartJsonWebTokenWrapper = DartJsonWebTokenWrapper(
            jwtSecret: jwtSecret,
          );

          // given
          final token = _createTestToken(
            payload: {"key": "value"},
            jwtSecret: jwtSecret,
            expiresIn: Duration(
              days: 7,
            ),
          );

          // when
          final payload = dartJsonWebTokenWrapper.verify(
            token: token,
          );

          expect(
            payload.isExpired,
            isFalse,
          );

          expect(
            payload.isInvalid,
            isFalse,
          );

          expect(payload.data, containsPair("key", equals("value")));

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
