import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/matches/utils/constants/match_create_request_body_key_constants.dart';
import '../../../../../../../bin/src/features/matches/utils/validators/match_create_request_validator.dart';
import '../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();
  final validatedRequestHandler = _MockValidatedRequestHandlderWrapper();

  // tested class
  final matchCreateRequestValidator = MatchCreateRequestValidator();

  setUp(() {
    registerFallbackValue(_FakeRequest());
  });

  tearDown(() {
    reset(request);
    reset(validatedRequestHandler);
  });

  group("$MatchCreateRequestValidator", () {
    group(".validate()", () {
      // TODO tests are not exhaustive - need empty, need null, need invalid data types, etc.
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
          final response = await matchCreateRequestValidator.validate(
              validatedRequestHandler: validatedRequestHandler.call)(request);

          // then
          // final expectedResponse = _generateTestBadRequestResponse(
          //   responseMessage: "Title is required.",
          // );
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Title is required.",
            // cookies: [],
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
          final response = await matchCreateRequestValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);

          // then
/*           final expectedResponse = _generateTestBadRequestResponse(
            responseMessage: "Description is required.",
          ); */
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Description is required.",
            // cookies: [],
          );
          final responseString = await response.readAsString();

          expect(
            responseString,
            equals(await expectedResponse.readAsString()),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));
          // TODO need to add cookies here as well

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
          final response = await matchCreateRequestValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);

          // then
          // final expectedResponse = _generateTestBadRequestResponse(
          //   responseMessage: "Date and time is required.",
          // );
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Date and time is required.",
            // cookies: [],
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
            final string = jsonEncode(
              requestMap,
            );

            return string;
          });

          // when
          final response = await matchCreateRequestValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Date and time must be in the future.",
            // cookies: [],
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
          final response = await matchCreateRequestValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);

          // then
          // final expectedResponse = _generateTestBadRequestResponse(
          //   responseMessage: "Location is required.",
          // );
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Location is required.",
            // cookies: [],
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
        "given a valid request"
        "when validate() is called"
        "then should return result of call to validatedRequestHandler",
        () async {
          // setup
          final changedRequest = _FakeRequest();

          final requestMap = {
            MatchCreateRequestBodyKeyConstants.TITLE.value: "valid_title",
            MatchCreateRequestBodyKeyConstants.DESCRIPTION.value:
                "valid_description",
            MatchCreateRequestBodyKeyConstants.DATE_AND_TIME.value:
                DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch,
            MatchCreateRequestBodyKeyConstants.LOCATION.value: "valid_location",
          };

          final validatedRequestHandlerResponse = Response(200);
          when(() => validatedRequestHandler.call(any())).thenAnswer(
            (_) async => validatedRequestHandlerResponse,
          );

          when(() => request.change(context: any(named: "context")))
              .thenReturn(changedRequest);

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await matchCreateRequestValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);

          // then
          verify(() => validatedRequestHandler.call(changedRequest)).called(1);
          expect(response, equals(validatedRequestHandlerResponse));

          // cleanup
        },
      );

      test(
        "given a valid request"
        "when validate() is called"
        "then should have expected changedRequest passed to validatedRequestHandler",
        () async {
          // setup
          final requestMap = {
            MatchCreateRequestBodyKeyConstants.TITLE.value: "valid_title",
            MatchCreateRequestBodyKeyConstants.DESCRIPTION.value:
                "valid_description",
            MatchCreateRequestBodyKeyConstants.DATE_AND_TIME.value:
                DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch,
            MatchCreateRequestBodyKeyConstants.LOCATION.value: "valid_location",
          };

          when(() => validatedRequestHandler(any())).thenAnswer(
            (_) async => Response.ok(""),
          );

          // given
          final originalRequest = Request(
            "post",
            Uri.parse("http://www.test.com/"),
            body: jsonEncode(requestMap),
          );

          // when
          await matchCreateRequestValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(originalRequest);

          // then
          final expectedValidatedBodyData = {
            MatchCreateRequestBodyKeyConstants.TITLE.value: "valid_title",
            MatchCreateRequestBodyKeyConstants.DESCRIPTION.value:
                "valid_description",
            MatchCreateRequestBodyKeyConstants.DATE_AND_TIME.value: requestMap[
                MatchCreateRequestBodyKeyConstants.DATE_AND_TIME.value],
            MatchCreateRequestBodyKeyConstants.LOCATION.value: "valid_location",
          };

          final captured =
              verify(() => validatedRequestHandler(captureAny())).captured;
          final changedRequest = captured.first as Request;
          final validatedBodyData = changedRequest.context["validatedBodyData"];

          expect(validatedBodyData, equals(expectedValidatedBodyData));

          // cleanup
        },
      );
    });
  });
}

class _MockRequest extends Mock implements Request {}

class _MockValidatedRequestHandlderWrapper extends Mock {
  // FutureOr<Response?> call(Request request);
  Future<Response> call(Request request);
}

class _FakeRequest extends Fake implements Request {}

// TODO should avoid using this
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
