import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../../../bin/src/features/core/domain/use_cases/get_cookie_by_name_in_string/get_cookie_by_name_in_string_use_case.dart';
import '../../../../../../../../bin/src/wrappers/local/cookies_handler/cookies_handler_wrapper.dart';

void main() {
  final cookiesHandlerWrapper = _MockCookiesHandlerWrapper();

  // tested class
  final getCookieByNameInStringUseCase = GetCookieByNameInStringUseCase(
    cookiesHandlerWrapper: cookiesHandlerWrapper,
  );

  tearDown(() {
    reset(cookiesHandlerWrapper);
  });

  group("$GetCookieByNameInStringUseCase", () {
    group(".call()", () {
      test(
        "given an invalid cookie name"
        "when call() is called"
        "then should return null",
        () async {
          // setup
          when(
            () => cookiesHandlerWrapper.findCookieByNameInString(
              cookiesString: any(named: "cookiesString"),
              cookieName: any(named: "cookieName"),
            ),
          ).thenReturn(null);

          // given
          final cookieName = "invalid_cookie_name";

          // when
          final result = getCookieByNameInStringUseCase(
            cookiesString: "",
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
            () => cookiesHandlerWrapper.findCookieByNameInString(
              cookiesString: any(named: "cookiesString"),
              cookieName: any(named: "cookieName"),
            ),
          ).thenReturn(_testCookie);

          // given
          final cookieName = "cookie_name";

          // when
          final result = getCookieByNameInStringUseCase(
            cookiesString: "",
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

final _testCookie = Cookie("cookie_name", "cookie_value");
