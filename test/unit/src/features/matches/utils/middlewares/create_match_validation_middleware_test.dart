import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/matches/utils/constants/match_create_request_body_constants.dart';
import '../../../../../../../bin/src/features/matches/utils/middlewares/create_match_validation_middleware.dart';

void main() {
  final request = _MockRequest();

  // TODO this no good - create validator for this - and reuse the middleware wrapper

  // tested class
  final createMatchValidationMiddleware = CreateMatchValidationMiddleware();

  tearDown(() {
    reset(request);
  });

  group("$CreateMatchValidationMiddleware", () {
    group(".call()", () {
      final validResponse = Response.ok("ok");

      test(
        "given no title in request "
        "when call() is called "
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            MatchCreateRequestBodyConstants.DESCRIPTION: "valid_description",
            MatchCreateRequestBodyConstants.DATE_AND_TIME: 1,
            MatchCreateRequestBodyConstants.LOCATION: "valid_location",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final requestHandler = _createTestRequestHandlerWithMiddleware(
              middleware: createMatchValidationMiddleware.call(),
              validResponse: validResponse);
          final response = await requestHandler(request);

          // then
          final expectedResponse = _generateTestBadRequestResponse(
            responseMessage: "Title is required.",
          );
          final responseString = await response.readAsString();

          expect(
            responseString,
            equals(await expectedResponse.readAsString()),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given no description in request "
        "when call() is called "
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            MatchCreateRequestBodyConstants.TITLE: "valid_title",
            MatchCreateRequestBodyConstants.DATE_AND_TIME: 1,
            MatchCreateRequestBodyConstants.LOCATION: "valid_location",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final requestHandler = _createTestRequestHandlerWithMiddleware(
              middleware: createMatchValidationMiddleware.call(),
              validResponse: validResponse);
          final response = await requestHandler(request);

          // then
          final expectedResponse = _generateTestBadRequestResponse(
            responseMessage: "Description is required.",
          );
          final responseString = await response.readAsString();

          expect(
            responseString,
            equals(await expectedResponse.readAsString()),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );
    });
  });
}

class _MockRequest extends Mock implements Request {}

FutureOr<Response> Function(Request) _createTestRequestHandlerWithMiddleware({
  required Middleware middleware,
  required Response validResponse,
}) {
  final handler = Pipeline().addMiddleware(middleware).addHandler(
    // TODO this is now a mock handler for requests - router or whatever will be handling requests (called by the server on each request)
    (request) {
      return validResponse;
    },
  );

  return handler;
}

Response _generateTestBadRequestResponse({
  required String responseMessage,
}) {
  return Response.badRequest(
    body: jsonEncode(
      {
        "ok": false,
        "message": responseMessage,
      },
    ),
    headers: {
      "content-type": "application/json",
    },
  );
}
