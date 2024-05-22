import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../../../bin/src/features/core/domain/exceptions/jwt_exceptions.dart';
import '../../../../../../../../bin/src/features/core/domain/use_cases/get_refresh_token_data_from_access_jwt/get_refresh_token_data_from_access_jwt_use_case.dart';
import '../../../../../../../../bin/src/features/core/domain/values/access_token_data_value.dart';
import '../../../../../../../../bin/src/wrappers/libraries/dart_jsonwebtoken/dart_jsonwebtoken_wrapper.dart';

void main() {
  final dartJsonWebTokenWrapper = _MockDartJsonWebTokenWrapper();

  // tested class
  final getAccessTokenDataFromAccessJwtUseCase =
      GetAccessTokenDataFromAccessJwtUseCase(
    dartJsonWebTokenWrapper: dartJsonWebTokenWrapper,
  );

  tearDown(() {
    reset(dartJsonWebTokenWrapper);
  });

  group("$GetAccessTokenDataFromAccessJwtUseCase", () {
    group(".call()", () {
      final jwt = "jwt";

      test(
        "given invalid jwt "
        "when .call() is called "
        "then should return null",
        () async {
          // setup

          // given
          when(() => dartJsonWebTokenWrapper.verify<Map<String, dynamic>>(
                token: jwt,
              )).thenThrow(JsonWebTokenInvalidException(jwt));

          // when
          final result = getAccessTokenDataFromAccessJwtUseCase.call(
            jwt: jwt,
          );

          // then
          final expectedResult = AccessTokenDataValueInvalid(jwt: jwt);
          expect(result, equals(expectedResult));

          // cleanup
        },
      );

      test(
        "given expired jwt "
        "when .call() is called "
        "then should return null",
        () async {
          // setup

          // given
          when(() => dartJsonWebTokenWrapper.verify<Map<String, dynamic>>(
                token: jwt,
              )).thenThrow(JsonWebTokenExpiredException(jwt));

          // when
          final result = getAccessTokenDataFromAccessJwtUseCase.call(
            jwt: jwt,
          );

          // then
          final expectedResult = AccessTokenDataValueExpired(jwt: jwt);
          expect(result, equals(expectedResult));

          // cleanup
        },
      );

      test(
        "given valid jwt "
        "when .call() is called "
        "then should return expected response",
        () async {
          // setup
          final payload = {
            "playerId": 1,
            "authId": 2,
          };

          // given
          when(() => dartJsonWebTokenWrapper.verify<Map<String, dynamic>>(
                token: jwt,
              )).thenReturn(payload);

          // when
          final result = getAccessTokenDataFromAccessJwtUseCase.call(
            jwt: jwt,
          );

          // then
          final expectedResult = AccessTokenDataValueValid(
            playerId: payload["playerId"]!,
            authId: payload["authId"]!,
          );
          expect(result, equals(expectedResult));

          // cleanup
        },
      );
    });
  });
}

class _MockDartJsonWebTokenWrapper extends Mock
    implements DartJsonWebTokenWrapper {}
