import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/core/domain/use_cases/get_cookie_by_name_in_request/get_cookie_by_name_in_request_use_case.dart';
import 'package:five_on_4_backend/src/wrappers/local/cookies_handler/cookies_handler_wrapper.dart';

void main() {
  final cookiesHandlerWrapper = _MockCookiesHandlerWrapper();

  // tested class
  final getCookieByNameInRequestUseCase = GetCookieByNameInRequestUseCase(
    cookiesHandlerWrapper: cookiesHandlerWrapper,
  );

  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });

  tearDown(() {
    reset(cookiesHandlerWrapper);
  });

  group("$GetCookieByNameInRequestUseCase", () {
    group(".call()", () {
      test(
        "given an invalid cookie name"
        "when call() is called"
        "then should return null",
        () async {
          // setup
          when(
            () => cookiesHandlerWrapper.findCookieByNameInRequest(
              request: any(named: "request"),
              cookieName: any(named: "cookieName"),
            ),
          ).thenReturn(null);

          // given
          final cookieName = "invalid_cookie_name";

          // when
          final result = getCookieByNameInRequestUseCase(
            request: _FakeRequest(),
            cookieName: cookieName,
          );

          // then
          expect(result, isNull);

          // cleanup
        },
      );

      test(
        "given a valid cookie name"
        "when call() is called"
        "then should return the cookie",
        () async {
          // setup
          when(
            () => cookiesHandlerWrapper.findCookieByNameInRequest(
              request: any(named: "request"),
              cookieName: any(named: "cookieName"),
            ),
          ).thenReturn(_testCookie);

          // given
          final cookieName = "cookie_name";

          // when
          final result = getCookieByNameInRequestUseCase(
            request: _FakeRequest(),
            cookieName: cookieName,
          );

          // then
          expect(result!, isNotNull);
          expect(result.name, equals(cookieName));
          expect(result.value, equals("cookie_value"));
        },
      );
    });
  });
}

class _MockCookiesHandlerWrapper extends Mock
    implements CookiesHandlerWrapper {}

class _FakeRequest extends Fake implements Request {}

final _testCookie = Cookie("cookie_name", "cookie_value");
