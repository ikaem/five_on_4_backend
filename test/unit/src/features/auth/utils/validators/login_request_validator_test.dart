import 'dart:async';
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
  final validatedRequestHandler = _MockValidateRequestHandlderWrapper();

  // tested class
  final loginRequestValidator = LoginRequestValidator();

  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });

  tearDown(() {
    reset(request);
    reset(validatedRequestHandler);
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

          // // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // // when
          final response = await loginRequestValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);
          final responseString = jsonDecode(await response.readAsString());

          // // then
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
          final response = await loginRequestValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);
          final responseString = jsonDecode(await response.readAsString());

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

      // // should return expected response when email is invalid
      test(
        "given a request with email being invalid"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            LoginRequestBodyKeyConstants.EMAIL.value: "email",
            LoginRequestBodyKeyConstants.PASSWORD.value: "password",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await loginRequestValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);
          final responseString = jsonDecode(await response.readAsString());

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Invalid email.",
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

      // // should return expected response when password is missing
      test(
        "given a request with no password"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            LoginRequestBodyKeyConstants.EMAIL.value: "test@test.net",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await loginRequestValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);
          final responseString = jsonDecode(await response.readAsString());

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Password is required.",
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

      // // should return expected response when password is not a string
      test(
        "given a request with password not being a string"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            LoginRequestBodyKeyConstants.EMAIL.value: "test@test.net",
            LoginRequestBodyKeyConstants.PASSWORD.value: 1,
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await loginRequestValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);
          final responseString = jsonDecode(await response.readAsString());

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Invalid data type supplied for password.",
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

      test(
        "given a request with valid email and password"
        "when .validate() is called"
        "then should return result of call to validatedRequestHandler",
        () async {
          // setup
          final changedRequest = _FakeRequest();

          final requestMap = {
            LoginRequestBodyKeyConstants.EMAIL.value: "test@test.net",
            LoginRequestBodyKeyConstants.PASSWORD.value: "password",
          };

          final validatedRequestHandlerResponse = Response(200);
          when(() => validatedRequestHandler(any()))
              .thenAnswer((i) async => validatedRequestHandlerResponse);

          when(() => request.change(context: any(named: "context")))
              .thenAnswer((i) => changedRequest);
          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await loginRequestValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);
          // final responseString = jsonDecode(await response.readAsString());

          // then
          verify(() => validatedRequestHandler(changedRequest)).called(1);
          expect(response, equals(validatedRequestHandlerResponse));

          // cleanup
        },
      );
    });
  });
}

class _MockRequest extends Mock implements Request {}

class _MockValidateRequestHandlderWrapper extends Mock {
  // FutureOr<Response?> call(Request request);
  Future<Response> call(Request request);
}

class _FakeRequest extends Fake implements Request {}
