import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../../../bin/src/features/core/domain/use_cases/get_access_token_data_from_access_jwt/get_access_token_data_from_access_jwt_use_case.dart';
import '../../../../../../../../bin/src/features/core/domain/values/access_token_data_value.dart';
import '../../../../../../../../bin/src/wrappers/libraries/dart_jsonwebtoken/dart_jsonwebtoken_wrapper.dart';

void main() {
  final dartJsonWebTokenWrapper = _MockDartJsonWebTokenWrapper();

  // tested class
  final getAccessTokenDataFromAccessJwtUseCase =
      GetAccessTokenDataFromAccessJwtUseCase(
    dartJsonWebTokenWrapper: dartJsonWebTokenWrapper,
  );

  setUp(() {
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

          when(() => dartJsonWebTokenWrapper.verify(token: jwt)).thenReturn(
            JWTValidatedPayload(
              isInvalid: true,
              isExpired: false,
              data: {},
            ),
          );

          // when
          final result = getAccessTokenDataFromAccessJwtUseCase.call(
            jwt: jwt,
          );

          // then
          expect(result, isNull);

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

          when(() => dartJsonWebTokenWrapper.verify(token: jwt)).thenReturn(
            JWTValidatedPayload(
              isInvalid: false,
              isExpired: true,
              data: {},
            ),
          );

          // when
          final result = getAccessTokenDataFromAccessJwtUseCase.call(
            jwt: jwt,
          );

          // then
          expect(result, isNull);

          // cleanup
        },
      );

      test(
        "given valid jwt "
        "when .call() is called "
        "then should return AccessTokenData",
        () async {
          // setup

          // given
          final playerId = 1;
          final authId = 2;

          when(() => dartJsonWebTokenWrapper.verify(token: jwt)).thenReturn(
            JWTValidatedPayload(
              isInvalid: false,
              isExpired: false,
              data: {
                "playerId": playerId,
                "authId": authId,
              },
            ),
          );

          // when
          final result = getAccessTokenDataFromAccessJwtUseCase.call(
            jwt: jwt,
          );

          // then
          expect(
            result,
            equals(
              AccessTokenDataValue(
                playerId: playerId,
                authId: authId,
              ),
            ),
          );

          // cleanup
        },
      );
    });
  });
}

class _MockDartJsonWebTokenWrapper extends Mock
    implements DartJsonWebTokenWrapper {}
