import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/auth/domain/use_cases/create_refresh_jwt_cookie/create_refresh_jwt_cookie_use_case.dart';
import 'package:five_on_4_backend/src/features/auth/utils/constants/jwt_duration_constants.dart';
import 'package:five_on_4_backend/src/wrappers/libraries/dart_jsonwebtoken/dart_jsonwebtoken_wrapper.dart';

void main() {
  final dartJsonWebTokenWrapper = _MockDartJsonWebTokenWrapper();

  // tested class
  final createRefreshJwtCookieUseCase = CreateRefreshJwtCookieUseCase(
    dartJsonWebTokenWrapper: dartJsonWebTokenWrapper,
  );

  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  tearDown(() {
    reset(dartJsonWebTokenWrapper);
  });

  group("$CreateRefreshJwtCookieUseCase", () {
    group(".call()", () {
      test(
        "given authId and playerId are provided"
        "when .call() is called"
        "then should call DartJsonWebTokenWrapper with expected values",
        () async {
          // setup
          when(() => dartJsonWebTokenWrapper.sign(
                payload: any(named: "payload"),
                expiresIn: any(named: "expiresIn"),
              )).thenReturn("jwt");

          // given
          final authId = 1;
          final playerId = 1;

          // when
          createRefreshJwtCookieUseCase(
            authId: authId,
            playerId: playerId,
          );

          // then
          verify(() => dartJsonWebTokenWrapper.sign(
                payload: {
                  "authId": authId,
                  "playerId": playerId,
                },
                expiresIn: JwtDurationConstants.REFRESH_TOKEN_DURATION.value,
              )).called(1);

          // cleanup
        },
      );

      test(
        "given custom duration is provided"
        "when .call() is called"
        "then should call DartJsonWebTokenWrapper.call with the provided custom duration value",
        () async {
          // setup
          when(() => dartJsonWebTokenWrapper.sign(
                payload: any(named: "payload"),
                expiresIn: any(named: "expiresIn"),
              )).thenReturn("jwt");

          // given
          final authId = 1;
          final playerId = 1;
          final customDuration = Duration(seconds: 1);

          // when
          createRefreshJwtCookieUseCase(
            authId: authId,
            playerId: playerId,
            expiresIn: customDuration,
          );

          // then
          verify(() => dartJsonWebTokenWrapper.sign(
                payload: {
                  "authId": authId,
                  "playerId": playerId,
                },
                expiresIn: customDuration,
              )).called(1);

          // cleanup
        },
      );

      test(
        "given required arguments provided"
        "when .call() is called"
        "then should retzrb expected cookie",
        () async {
          // setup
          when(() => dartJsonWebTokenWrapper.sign(
                payload: any(named: "payload"),
                expiresIn: any(named: "expiresIn"),
              )).thenReturn("jwt");

          // given
          final authId = 1;
          final playerId = 1;

          // when
          final cookie = createRefreshJwtCookieUseCase(
            authId: authId,
            playerId: playerId,
          );

          // then
          final expectedCookie = Cookie.fromSetCookieValue(
            "refresh_token=jwt; HttpOnly; Secure; Path=/",
          );

          expect(cookie.toString(), expectedCookie.toString());

          // cleanup
        },
      );
    });
  });
}

class _MockDartJsonWebTokenWrapper extends Mock
    implements DartJsonWebTokenWrapper {}
