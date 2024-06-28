import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/utils/constants/auth_response_constants.dart';
import '../../../../../../../bin/src/features/core/utils/helpers/response_generator.dart';

void main() {
  group("$ResponseGenerator", () {
    group(".auth()", () {
      test(
        "given required arguments"
        "when .auth() is called"
        "then should return expected response",
        () async {
          // setup

          // given
          final message = "message";
          final data = {"data": "data"};

          // when
          final response = ResponseGenerator.auth(
            message: message,
            data: data,
            accessToken: "accessToken",
            refreshTokenCookie: Cookie("refresh_token", "refresh_token"),
          );
          final responseBodyString = await response.readAsString();

          // then
          final expectedResponse = Response(HttpStatus.ok,
              body: jsonEncode({
                "ok": true,
                "message": message,
                "data": data,
              }));
          final expectedResponseBodyString =
              await expectedResponse.readAsString();

          expect(response.statusCode, expectedResponse.statusCode);
          expect(responseBodyString, expectedResponseBodyString);

          // cleanup
        },
      );

      test(
        "given custom http status code is provided"
        "when .auth() is called"
        "then should return expected response",
        () async {
          // setup

          // given
          final message = "message";
          final data = {"data": "data"};
          final statusCode = HttpStatus.created;

          // when
          final response = ResponseGenerator.auth(
            message: message,
            data: data,
            statusCode: statusCode,
            accessToken: "accessToken",
            refreshTokenCookie: Cookie("refresh_token", "refresh_token"),
          );
          final responseBodyString = await response.readAsString();

          // then
          final expectedResponse = Response(statusCode,
              body: jsonEncode({
                "ok": true,
                "message": message,
                "data": data,
              }));
          final expectedResponseBodyString =
              await expectedResponse.readAsString();

          expect(response.statusCode, expectedResponse.statusCode);
          expect(responseBodyString, expectedResponseBodyString);

          // cleanup
        },
      );

      test(
        "given response is returned "
        "when examine response headers "
        "then should have content type set as json",
        () async {
          // setup
          final message = "message";
          final data = {"data": "data"};

          // given
          final response = ResponseGenerator.auth(
            message: message,
            data: data,
            accessToken: "accessToken",
            refreshTokenCookie: Cookie("refresh_token", "refresh_token"),
          );

          // when / then
          expect(response.headers[HttpHeaders.contentTypeHeader],
              "application/json");

          // cleanup
        },
      );

      test(
        "given access token is provided"
        "when .auth() is called"
        "then should return response with expected access token in headers ",
        () async {
          // setup

          // given
          final message = "message";
          final data = {"data": "data"};
          final accessToken = "accessToken";
          final refreshTokenCookie = Cookie("refresh_token", "refresh_token");

          // when
          final response = ResponseGenerator.auth(
            message: message,
            data: data,
            accessToken: accessToken,
            refreshTokenCookie: refreshTokenCookie,
          );

          // then
          expect(
            response.headers[AuthResponseConstants.ACCESS_JWT_HEADER_KEY.value],
            accessToken,
          );

          // cleanup
        },
      );

      test(
        "given refresh token cookie is provided"
        "when .auth() is called"
        "then should return response with expected refresh token cookie",
        () async {
          // setup

          // given
          final message = "message";
          final data = {"data": "data"};
          final refreshTokenCookie = Cookie("refresh_token", "refresh_token");
          final accessToken = "accessToken";

          // when
          final response = ResponseGenerator.auth(
            message: message,
            data: data,
            accessToken: accessToken,
            refreshTokenCookie: refreshTokenCookie,
          );

          // then
          final cookies = response.headers[HttpHeaders.setCookieHeader];

          expect(cookies, contains(refreshTokenCookie.toString()));

          // cleanup
        },
      );
    });
    group(".failure()", () {
      test(
        "given required arguments"
        "when .failure() is called"
        "then should return expected response",
        () async {
          // setup

          // given
          final message = "message";
          final statusCode = HttpStatus.badRequest;

          // when
          final response = ResponseGenerator.failure(
            message: message,
            statusCode: statusCode,
          );
          final responseBodyString = await response.readAsString();

          // then
          final expectedResponse = Response(statusCode,
              body: jsonEncode({
                "ok": false,
                "message": message,
              }));
          final expectedResponseBodyString =
              await expectedResponse.readAsString();

          expect(response.statusCode, expectedResponse.statusCode);
          expect(responseBodyString, expectedResponseBodyString);

          // cleanup
        },
      );

      test(
        "given status code is provided"
        "when .failure() is called"
        "then should return response with expected status code",
        () async {
          // setup

          // given
          final message = "message";
          final statusCode = HttpStatus.internalServerError;

          // when
          final response = ResponseGenerator.failure(
            message: message,
            statusCode: statusCode,
          );

          // then
          expect(response.statusCode, statusCode);

          // cleanup
        },
      );

      test(
        "given response is returned "
        "when examine response headers "
        "then should have content type set as json",
        () async {
          // setup
          final message = "message";
          final statusCode = HttpStatus.badRequest;

          // given
          final response = ResponseGenerator.failure(
            message: message,
            statusCode: statusCode,
          );

          // when/then
          expect(
            response.headers[HttpHeaders.contentTypeHeader],
            "application/json",
          );

          // cleanup
        },
      );
    });

    group(".success()", () {
      test(
        "given required arguments "
        "when .success() is called"
        "then should return expected response",
        () async {
          // setup

          // given
          final message = "message";
          final data = {"data": "data"};

          // when
          final response = ResponseGenerator.success(
            message: message,
            data: data,
          );
          final responseBodyString = await response.readAsString();

          // then
          final expectedResponse = Response(HttpStatus.ok,
              body: jsonEncode({
                "ok": true,
                "message": message,
                "data": data,
              }));
          final expectedResponseBodyString =
              await expectedResponse.readAsString();

          expect(response.statusCode, expectedResponse.statusCode);
          expect(responseBodyString, expectedResponseBodyString);

          // cleanup
        },
      );

      test(
        "given custom http status code is provided "
        "when .success() is called"
        "then should return expected response",
        () async {
          // setup

          // given
          final message = "message";
          final data = {"data": "data"};
          final statusCode = HttpStatus.created;

          // when
          final response = ResponseGenerator.success(
            message: message,
            data: data,
            statusCode: statusCode,
          );

          // then

          expect(response.statusCode, statusCode);

          // cleanup
        },
      );

      test(
        "given no data is provided "
        "when .success() is called "
        "then should return expected response",
        () async {
          // setup

          // given
          final message = "message";
          final Map<String, Object?>? data = null;

          // when
          final response = ResponseGenerator.success(
            message: message,
            data: data,
          );
          final responseBodyString = await response.readAsString();

          // then
          final expectedResponse = Response(HttpStatus.ok,
              body: jsonEncode({
                "ok": true,
                "message": message,
              }));
          final expectedResponseBodyString =
              await expectedResponse.readAsString();

          expect(response.statusCode, expectedResponse.statusCode);
          expect(responseBodyString, expectedResponseBodyString);

          // cleanup
        },
      );

      test(
        "given response is returned "
        "when examine response headers "
        "then should have content type set as json",
        () async {
          // setup
          final message = "message";
          final data = {"data": "data"};

          // given
          final response = ResponseGenerator.success(
            message: message,
            data: data,
          );

          // when / then
          expect(
            response.headers[HttpHeaders.contentTypeHeader],
            "application/json",
          );

          // cleanup
        },
      );
    });
  });
}
