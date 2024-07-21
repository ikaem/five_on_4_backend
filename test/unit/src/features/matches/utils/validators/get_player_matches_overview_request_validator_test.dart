import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/matches/utils/constants/get_player_matches_overview_request_body_key_constants.dart';
import 'package:five_on_4_backend/src/features/matches/utils/validators/get_player_matches_overview_request_validator.dart';
import '../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();
  final validatedRequestHandler = _MockValidatedRequestHandlerWrapper();

  // tested class
  final validator = const GetPlayerMatchesOverviewRequestValidator();

  setUp(() {
    registerFallbackValue(_FakeRequest());
  });

  tearDown(() {
    reset(request);
    reset(validatedRequestHandler);
  });

  group("$GetPlayerMatchesOverviewRequestValidator", () {
    // should return expected response if no playerId in request
    test(
      "given no playerId in request"
      "when .validate() is called"
      "then should return expected response",
      () async {
        // setup
        final requestMap = {};

        // given
        when(() => request.readAsString())
            .thenAnswer((invocation) async => jsonEncode(requestMap));

        // when
        final response = await validator.validate(
          validatedRequestHandler: validatedRequestHandler.call,
        )(request);
        final responseString = await response.readAsString();

        // then
        final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "playerId is required.");
        final expectedResponseString = await expectedResponse.readAsString();

        expect(responseString, expectedResponseString);
        expect(response.statusCode, expectedResponse.statusCode);

        // cleanup
      },
    );

    // should return result of call to validatedRequestHandler if request is valid
    test(
      "given a valid request"
      "when .validate() is called"
      "then should return result of cvall to validatedRequestHandler",
      () async {
        // setup
        final changedRequest = _FakeRequest();

        final requestMap = {
          GetPlayerMatchesOverviewRequestBodyKeyConstants.PLAYER_ID.value: 1,
        };

        final validatedRequestHandlerResponse = Response(200);
        when(() => validatedRequestHandler.call(any()))
            .thenAnswer((invocation) async => validatedRequestHandlerResponse);

        when(() => request.change(context: any(named: "context"))).thenReturn(
          changedRequest,
        );

        // given
        when(() => request.readAsString())
            .thenAnswer((invocation) async => jsonEncode(requestMap));

        // when
        final response = await validator.validate(
          validatedRequestHandler: validatedRequestHandler.call,
        )(request);

        // then
        verify(() => validatedRequestHandler.call(changedRequest)).called(1);
        expect(response, equals(validatedRequestHandlerResponse));

        // cleanup
      },
    );

    // should pass expected changed request to validatedRequestHandler if request is valid
    test(
      "given a valid request"
      "when .validate() is called"
      "then should have expected changedRequest passed to validatedRequestHandler",
      () async {
        // setup
        final requestMap = {
          GetPlayerMatchesOverviewRequestBodyKeyConstants.PLAYER_ID.value: 1,
        };

        when(() => validatedRequestHandler.call(any())).thenAnswer(
          (invocation) async => Response(200),
        );

        // given
        final originalRequest = Request(
          "post",
          Uri.parse("http://www.test.com/"),
          body: jsonEncode(requestMap),
        );

        // when
        await validator.validate(
          validatedRequestHandler: validatedRequestHandler.call,
        )(originalRequest);

        // then
        final expectedValidatedBodyData = {
          GetPlayerMatchesOverviewRequestBodyKeyConstants.PLAYER_ID.value: 1,
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
}

class _MockRequest extends Mock implements Request {}

class _MockValidatedRequestHandlerWrapper extends Mock {
  Future<Response> call(Request request);
}

class _FakeRequest extends Fake implements Request {}
