import 'dart:convert';
import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/utils/constants/login_request_body_key_constants.dart';
import '../../../../../../../bin/src/features/auth/utils/validators/login_request_validator.dart';
import '../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();

  // tested class
  final loginRequestValidator = LoginRequestValidator();

  tearDown(() {
    reset(request);
  });

  group("$LoginRequestValidator", () {
    group(".validate()", () {
      // should return expected response when emaul is missing
      test(
        "given a request with no email"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            LoginRequestBodyKeyConstants.PASSWORD.value: "password",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await loginRequestValidator.validate(request);
          final responseString = jsonDecode(await response!.readAsString());

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Email is required.",
            cookies: [],
          );
          final expectedResponseString = jsonDecode(
            await expectedResponse.readAsString(),
          );

          expect(response.statusCode, equals(expectedResponse.statusCode));
          expect(responseString, equals(expectedResponseString));
          expect(response.headers[HttpHeaders.setCookieHeader],
              equals(expectedResponse.headers[HttpHeaders.setCookieHeader]));

          // cleanup
        },
      );

      // should return expected response when email is not a string
      test(
        "given a request with email not being a string"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            LoginRequestBodyKeyConstants.EMAIL.value: 1,
            LoginRequestBodyKeyConstants.PASSWORD.value: "password",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await loginRequestValidator.validate(request);
          final responseString = jsonDecode(await response!.readAsString());

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Invalid data type supplied for email.",
            cookies: [],
          );
          final expectedResponseString = jsonDecode(
            await expectedResponse.readAsString(),
          );

          expect(response.statusCode, equals(expectedResponse.statusCode));
          expect(responseString, equals(expectedResponseString));
          expect(response.headers[HttpHeaders.setCookieHeader],
              equals(expectedResponse.headers[HttpHeaders.setCookieHeader]));

          // cleanup
        },
      );

      // should return expected response when email is invalid

      // should return expected response when password is missing

      // should return expected response when password is not a string
    });
  });
}

class _MockRequest extends Mock implements Request {}
