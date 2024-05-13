import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/core/utils/helpers/response_generator.dart';

void main() {
  group("$ResponseGenerator", () {
    group(".success()", () {
      test(
        "given required arguments "
        "when .generate() is called"
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

      // given custom http status code is provided, then should return expected response
      test(
        "given custom http status code is provided "
        "when .generate() is called"
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

      // given no data is provided, then should return expected response
      test(
        "given no data is provided "
        "when .generate() is called "
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

      // should return json response
      test(
        "given response is returned "
        "when examine response headers "
        "then should have content type set as json",
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

          // then
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