import 'package:test/test.dart';

import '../../../../../../bin/src/wrappers/local/cookies_handler/cookies_handler_wrapper.dart';

const cookiesString =
    "b=a; Path=/; Expires=Mon, 01 Nov 2021 21:46:17 GMT, c=d; expires=Tue, 01 Nov 2022 07:57:25 GMT; HttpOnly; path=/; Domain=.d.es";

void main() {
  final cookiesHandlerWrapper = CookiesHandlerWrapper();

  group("$CookiesHandlerWrapper", () {
    group(".findCookieByNameInString", () {
      test(
        "given a cookie name not present in the cookies string"
        "when findCookieByNameInString() is called"
        "then should return null",
        () async {
          // setup
          const cookiesString =
              "token_1=your_access_token_value; Expires=Thursday, 25-Dec-2025 23:13:00 GMT; HttpOnly; Secure;token_2=your_another_cookie_value; Expires=Thursday, 25-Dec-2025 23:13:00 GMT; HttpOnly; Secure";

          // given
          const missingCookieName = "missing_cookie_name";

          // when
          final result = cookiesHandlerWrapper.findCookieByNameInString(
            cookiesString: cookiesString,
            cookieName: missingCookieName,
          );

          // then
          expect(result, isNull);

          // cleanup
        },
      );

      test(
        "given a cookie name present in the cookies string"
        "when findCookieByNameInString() is called"
        "then should return the cookie",
        () async {
          // setup
          const cookiesString =
              "token_1=your_access_token_value; Expires=Thursday, 25-Dec-2025 23:13:00 GMT; HttpOnly; Secure;token_2=your_another_cookie_value; Expires=Thursday, 25-Dec-2025 23:13:00 GMT; HttpOnly; Secure";

          // given
          const cookieName = "token_1";

          // when
          final result = cookiesHandlerWrapper.findCookieByNameInString(
            cookiesString: cookiesString,
            cookieName: cookieName,
          );

          // then
          expect(result, isNotNull);
          expect(result!.name, equals(cookieName));
          expect(result.value, equals("your_access_token_value"));

          // cleanup
        },
      );
    });
  });
}
