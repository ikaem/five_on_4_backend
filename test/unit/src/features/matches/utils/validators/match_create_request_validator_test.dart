import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/matches/utils/constants/match_create_request_body_key_constants.dart';
import '../../../../../../../bin/src/features/matches/utils/validators/match_create_request_validator.dart';

void main() {
  final request = _MockRequest();

  // tested class
  final matchCreateRequestValidator = MatchCreateRequestValidator();

  tearDown(() {
    reset(request);
  });

  group("$MatchCreateRequestValidator", () {
    group(".validate()", () {
      test(
        "given no title in request"
        "when validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            MatchCreateRequestBodyKeyConstants.DESCRIPTION.value:
                "valid_description",
            MatchCreateRequestBodyKeyConstants.DATE_AND_TIME.value: 1,
            MatchCreateRequestBodyKeyConstants.LOCATION.value: "valid_location",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await matchCreateRequestValidator.validate(request);

          // then
          final expectedResponse = _generateTestBadRequestResponse(
            responseMessage: "Title is required.",
          );
          final responseString = await response!.readAsString();

          expect(
            responseString,
            equals(await expectedResponse.readAsString()),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given no description in request"
        "when validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            MatchCreateRequestBodyKeyConstants.TITLE.value: "valid_title",
            MatchCreateRequestBodyKeyConstants.DATE_AND_TIME.value: 1,
            MatchCreateRequestBodyKeyConstants.LOCATION.value: "valid_location",
          };

          // given
          when(() => request.readAsString()).thenAnswer((i) async {
            // return jsonEncode(requestMap);
            final string = jsonEncode(
              requestMap,
            );

            return string;
          });

          // when
          final response = await matchCreateRequestValidator.validate(request);

          // then
          final expectedResponse = _generateTestBadRequestResponse(
            responseMessage: "Description is required.",
          );
          final responseString = await response!.readAsString();

          expect(
            responseString,
            equals(await expectedResponse.readAsString()),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given no date and time in request"
        "when validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            MatchCreateRequestBodyKeyConstants.TITLE.value: "valid_title",
            MatchCreateRequestBodyKeyConstants.DESCRIPTION.value:
                "valid_description",
            MatchCreateRequestBodyKeyConstants.LOCATION.value: "valid_location",
          };

          // given
          when(() => request.readAsString()).thenAnswer((i) async {
            // return jsonEncode(requestMap);
            final string = jsonEncode(
              requestMap,
            );

            return string;
          });

          // when
          final response = await matchCreateRequestValidator.validate(request);

          // then
          final expectedResponse = _generateTestBadRequestResponse(
            responseMessage: "Date and time is required.",
          );
          final responseString = await response!.readAsString();

          expect(
            responseString,
            equals(await expectedResponse.readAsString()),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given date and time in the past in request"
        "when validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            MatchCreateRequestBodyKeyConstants.TITLE.value: "valid_title",
            MatchCreateRequestBodyKeyConstants.DESCRIPTION.value:
                "valid_description",
            MatchCreateRequestBodyKeyConstants.DATE_AND_TIME.value: 1,
            MatchCreateRequestBodyKeyConstants.LOCATION.value: "valid_location",
          };

          // given
          when(() => request.readAsString()).thenAnswer((i) async {
            // return jsonEncode(requestMap);
            final string = jsonEncode(
              requestMap,
            );

            return string;
          });

          // when
          final response = await matchCreateRequestValidator.validate(request);

          // then
          final expectedResponse = _generateTestBadRequestResponse(
            responseMessage: "Date and time must be in the future.",
          );
          final responseString = await response!.readAsString();

          expect(
            responseString,
            equals(await expectedResponse.readAsString()),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given no location in request"
        "when validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            MatchCreateRequestBodyKeyConstants.TITLE.value: "valid_title",
            MatchCreateRequestBodyKeyConstants.DESCRIPTION.value:
                "valid_description",
            MatchCreateRequestBodyKeyConstants.DATE_AND_TIME.value:
                DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch,
          };

          // given
          when(() => request.readAsString()).thenAnswer((i) async {
            // return jsonEncode(requestMap);
            final string = jsonEncode(
              requestMap,
            );

            return string;
          });

          // when
          final response = await matchCreateRequestValidator.validate(request);

          // then
          final expectedResponse = _generateTestBadRequestResponse(
            responseMessage: "Location is required.",
          );
          final responseString = await response!.readAsString();

          expect(
            responseString,
            equals(await expectedResponse.readAsString()),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // TODO TEST WHEN NULL IS RETURNED TOO
    });
  });
}

class _MockRequest extends Mock implements Request {}

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
