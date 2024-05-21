import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../bin/src/wrappers/local/cookies_handler/cookies_handler_wrapper.dart';

void main() {
  final request = _MockRequest();

  // tested class
  final cookiesHandlerWrapper = CookiesHandlerWrapper();

  tearDown(() {
    reset(request);
  });

  group("$CookiesHandlerWrapper", () {
// TODO test
    group(".getCookiesStringFromRequest", () {});

    group(".findCookieByNameInRequest", () {
// should return null if there is no cookies in the request
      test(
        "given a request with no cookies"
        "when call .findCookieByNameInRequest()"
        "then should return null",
        () async {
          // setup

          // given
          when(() => request.headers).thenReturn({});

          // when
          final result = cookiesHandlerWrapper.findCookieByNameInRequest(
            request: request,
            cookieName: "cookie_name",
          );

          // then
          expect(result, isNull);

          // cleanup
        },
      );

// should return null if there is no searched for cookie by name
      test(
        "given <pre-condition to the test>"
        "when <behavior we are specifying>"
        "then should <state we expect to happen>",
        () async {
          // setup
          const cookiesString =
              "token_1=your_access_token_value; Expires=Thursday, 25-Dec-2025 23:13:00 GMT; HttpOnly; Secure;token_2=your_another_cookie_value; Expires=Thursday, 25-Dec-2025 23:13:00 GMT; HttpOnly; Secure";

          // given
          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader: cookiesString,
          });

          // when
          final result = cookiesHandlerWrapper.findCookieByNameInRequest(
            request: request,
            cookieName: "missing_cookie_name",
          );

          // then
          expect(result, isNull);

          // cleanup
        },
      );

// should return expected cookie if request is valid
      test(
        "given valid request with single cookie"
        "when call .findCookieByNameInRequest()"
        "then should return expected cookie",
        () async {
          // setup
          const cookiesString =
              "found_token=your_access_token_value; Expires=Thursday, 25-Dec-2025 23:13:00 GMT; HttpOnly; Secure";

          // given
          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader: cookiesString,
          });

          // when
          final result = cookiesHandlerWrapper.findCookieByNameInRequest(
            request: request,
            cookieName: "found_token",
          );

          // then
          final expectedCookie =
              Cookie.fromSetCookieValue("found_token=your_access_token_value");
          expect(
            result.toString(),
            equals(expectedCookie.toString()),
          );

          // cleanup
        },
      );

      test(
        "given valid request with multiple cookies"
        "when call .findCookieByNameInRequest()"
        "then should return expected cookie",
        () async {
          // setup
          const cookiesString =
              "found_token=your_access_token_value; Expires=Thursday, 25-Dec-2025 23:13:00 GMT; HttpOnly; Secure;token_2=your_another_cookie_value; Expires=Thursday, 25-Dec-2025 23:13:00 GMT; HttpOnly; Secure";

          // given
          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader: cookiesString,
          });

          // when
          final result = cookiesHandlerWrapper.findCookieByNameInRequest(
            request: request,
            cookieName: "found_token",
          );

          // then
          final expectedCookie =
              Cookie.fromSetCookieValue("found_token=your_access_token_value");

          expect(
            result.toString(),
            equals(expectedCookie.toString()),
          );

          // cleanup
        },
      );
    });
  });
}

class _MockRequest extends Mock implements Request {}

// TODO let it stay here as a reference
// const _cookiesString =
//     "b=a; Path=/; Expires=Mon, 01 Nov 2021 21:46:17 GMT, c=d; expires=Tue, 01 Nov 2022 07:57:25 GMT; HttpOnly; path=/; Domain=.d.es";
