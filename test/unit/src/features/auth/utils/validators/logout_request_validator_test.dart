import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/utils/validators/logout_request_validator.dart';
import '../../../../../../../bin/src/features/core/domain/use_cases/get_access_token_data_from_access_jwt/get_access_token_data_from_access_jwt_use_case.dart';
import '../../../../../../../bin/src/features/core/domain/use_cases/get_cookie_by_name_in_string/get_cookie_by_name_in_string_use_case.dart';
import '../../../../../../../bin/src/features/core/domain/values/access_token_data_value.dart';
import '../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();
  final getCookieByNameInStringUseCase = _MockGetCookieByNameInStringUseCase();
  final getAccessTokenDataFromAccessJwtUseCase =
      _MockGetAccessTokenDataFromAccessJwtUseCase();

// tested class
  final validator = LogoutRequestValidator(
    getCookieByNameInStringUseCase: getCookieByNameInStringUseCase,
    getAccessTokenDataFromAccessJwtUseCase:
        getAccessTokenDataFromAccessJwtUseCase,
  );

  tearDown(() {
    reset(request);
    reset(getCookieByNameInStringUseCase);
    reset(getAccessTokenDataFromAccessJwtUseCase);
  });

  group(
    "$LogoutRequestValidator",
    () {
      group(".validate()", () {
        // should return expected response if no cookies in request
        test(
          "given a request without cookies"
          "when .validate() is called"
          "then should return expected response",
          () async {
            // setup

            // given
            when(() => request.headers).thenReturn({});

            // when
            final response = await validator.validate(request);
            final responseString = await response!.readAsString();

            // then
            final expectedResponse = generateTestBadRequestResponse(
              responseMessage: "No cookies found in request.",
              cookies: null,
            );
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, expectedResponseString);
            expect(response.statusCode, expectedResponse.statusCode);
            expect(response.headers[HttpHeaders.setCookieHeader],
                expectedResponse.headers[HttpHeaders.setCookieHeader]);

            // cleanup
          },
        );

        // should return expected response if no required cookie is in request
        test(
          "given a request without accessToken cookie"
          "when .validate() is called"
          "then should return expected response",
          () async {
            // setup
            when(() => getCookieByNameInStringUseCase(
                  cookiesString: any(named: "cookiesString"),
                  cookieName: any(named: "cookieName"),
                )).thenReturn(null);

            // given
            // specify any other cookie
            when(() => request.headers).thenReturn({
              HttpHeaders.cookieHeader: "some_cookie=some_cookie_value",
            });

            // when
            final response = await validator.validate(request);
            final responseString = await response!.readAsString();

            // then
            final expectedResponse = generateTestBadRequestResponse(
              responseMessage: "No accessToken cookie found in request.",
              cookies: [],
            );
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, expectedResponseString);
            expect(response.statusCode, expectedResponse.statusCode);
            expect(response.headers[HttpHeaders.setCookieHeader],
                expectedResponse.headers[HttpHeaders.setCookieHeader]);

            // cleanup
          },
        );

        // should return expected response if invalid auth token in cookie
        test(
          "given a request with invalid auth token in cookie"
          "when .validate() is called"
          "then should return expected response",
          () async {
            // setup
            final cookie =
                _generateTestCookie(name: "accessToken", value: "invalid_jwt");

            when(() => getCookieByNameInStringUseCase(
                  cookiesString: any(named: "cookiesString"),
                  cookieName: any(named: "cookieName"),
                )).thenReturn(cookie);

            // given
            when(() => request.headers).thenReturn({
              HttpHeaders.cookieHeader: cookie.toString(),
            });

            final invalidAccessTokenData = AccessTokenDataValueInvalid(
              jwt: cookie.value,
            );
            when(() => getAccessTokenDataFromAccessJwtUseCase(
                  jwt: any(named: "jwt"),
                )).thenReturn(invalidAccessTokenData);

            // when
            final response = await validator.validate(request);
            final responseString = await response!.readAsString();

            // then
            final expectedResponse = generateTestBadRequestResponse(
              responseMessage: "Invalid auth token in cookie.",
              cookies: [],
            );
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, expectedResponseString);
            expect(response.statusCode, expectedResponse.statusCode);
            expect(response.headers[HttpHeaders.setCookieHeader],
                expectedResponse.headers[HttpHeaders.setCookieHeader]);

            // cleanup
          },
        );

        // should return expected response if expired auth token in cookie
        test(
          "given a request with expired auth token in cookie"
          "when .validate() is called"
          "then should <state we expect to happen>",
          () async {
            // setup
            final cookie =
                _generateTestCookie(name: "accessToken", value: "expired_jwt");

            when(() => getCookieByNameInStringUseCase(
                  cookiesString: any(named: "cookiesString"),
                  cookieName: any(named: "cookieName"),
                )).thenReturn(cookie);

            // given
            when(() => request.headers).thenReturn({
              HttpHeaders.cookieHeader: cookie.toString(),
            });

            final expiredAccessTokenData = AccessTokenDataValueExpired(
              jwt: cookie.value,
            );
            when(() => getAccessTokenDataFromAccessJwtUseCase(
                  jwt: any(named: "jwt"),
                )).thenReturn(expiredAccessTokenData);

            // when
            final response = await validator.validate(request);
            final responseString = await response!.readAsString();

            // then
            final expectedResponse = generateTestBadRequestResponse(
              responseMessage: "Expired auth token in cookie.",
              cookies: [],
            );
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, expectedResponseString);
            expect(response.statusCode, expectedResponse.statusCode);
            expect(response.headers[HttpHeaders.setCookieHeader],
                expectedResponse.headers[HttpHeaders.setCookieHeader]);

            // cleanup
          },
        );

        // should return null if all good
      });
    },
  );
}

class _MockRequest extends Mock implements Request {}

class _MockGetCookieByNameInStringUseCase extends Mock
    implements GetCookieByNameInStringUseCase {}

class _MockGetAccessTokenDataFromAccessJwtUseCase extends Mock
    implements GetAccessTokenDataFromAccessJwtUseCase {}

Cookie _generateTestCookie({required String name, required String value}) {
  return Cookie(name, value);
}
