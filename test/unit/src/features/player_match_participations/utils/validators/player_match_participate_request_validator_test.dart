import 'package:five_on_4_backend/src/features/core/utils/constants/request_constants.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/utils/validators/player_match_participate_request_validator.dart';
import 'package:five_on_4_backend/src/features/players/utils/validators/search_players_request_validator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();
  final validatedRequestHandler = _MockValidatedRequestHandlderWrapper();

  // tested class
  final validator = const PlayerMatchParticipateRequestValidator();

  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });

  tearDown(() {
    reset(request);
    reset(validatedRequestHandler);
  });

  group("$PlayerMatchParticipateRequestValidator", () {
    group(
      ".validate()",
      () {
        // given no participation status
        test(
          "given a [Request] without valid [participationStatus] query parameter"
          "when [.validate()] is called"
          "then should return expected response",
          () async {
            // setup
            // TODO lets leave it like this for now - the url
            final uri =
                Uri.parse("http://www.test.com/match-participation/store");

            // final someRequest = Request("post", uri);

            // given
            when(() => request.url).thenReturn(uri);

            // when
            final response = await validator.validate(
              validatedRequestHandler: validatedRequestHandler.call,
            )(request);
            final responseString = await response.readAsString();

            // then
            final expectedResponse = generateTestBadRequestResponse(
                responseMessage: "No participation status provided.");
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, equals(expectedResponseString));
            expect(response.statusCode, equals(expectedResponse.statusCode));

            // cleanup
          },
        );

        // given no match id
        test(
          "given a [Request] without valid [matchId] query parameter"
          "when [.validate()] is called"
          "then should return expected response",
          () async {
            // setup
            final uri = Uri.parse(
                "http://www.test.com/match-participation/store?participation_status=pendingDecision");

            // given
            when(() => request.url).thenReturn(uri);

            // when
            final response = await validator.validate(
              validatedRequestHandler: validatedRequestHandler.call,
            )(request);
            final responseString = await response.readAsString();

            // then
            final expectedResponse = generateTestBadRequestResponse(
                responseMessage: "No match id provided.");
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, equals(expectedResponseString));
            expect(response.statusCode, equals(expectedResponse.statusCode));

            // cleanup
          },
        );

        // given no player id
        test(
          "given a [Request] without valid [playerId] query parameter"
          "when [.validate()] is called"
          "then should return expected response",
          () async {
            // setup
            final uri = Uri.parse(
                "http://www.test.com/match-participation/store?participation_status=pendingDecision&match_id=1");

            // given
            when(() => request.url).thenReturn(uri);

            // when
            final response = await validator.validate(
              validatedRequestHandler: validatedRequestHandler.call,
            )(request);
            final responseString = await response.readAsString();

            // then
            final expectedResponse = generateTestBadRequestResponse(
                responseMessage: "No player id provided.");
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, equals(expectedResponseString));
            expect(response.statusCode, equals(expectedResponse.statusCode));

            // cleanup
          },
        );

        // given invalid participation status
        test(
          "given a [Request] with invalid [participationStatus] query parameter"
          "when [.validate()] is called"
          "then should return expected response",
          () async {
            // setup
            final uri = Uri.parse(
                "http://www.test.com/match-participation/store?participation_status=invalidStatus&match_id=1&player_id=1");

            // given
            when(() => request.url).thenReturn(uri);

            // when
            final response = await validator.validate(
              validatedRequestHandler: validatedRequestHandler.call,
            )(request);
            final responseString = await response.readAsString();

            // then
            final expectedResponse = generateTestBadRequestResponse(
                responseMessage: "Invalid participation status provided.");
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, equals(expectedResponseString));
            expect(response.statusCode, equals(expectedResponse.statusCode));

            // cleanup
          },
        );

        // given match id cannot be converted to int
        test(
          "given a [Request] with invalid [matchId] query parameter"
          "when [.validate()] is called"
          "then should return expected response",
          () async {
            // setup
            final uri = Uri.parse(
                "http://www.test.com/match-participation/store?participation_status=pendingDecision&match_id=invalidMatchId&player_id=1");

            // given
            when(() => request.url).thenReturn(uri);

            // when
            final response = await validator.validate(
              validatedRequestHandler: validatedRequestHandler.call,
            )(request);
            final responseString = await response.readAsString();

            // then
            final expectedResponse = generateTestBadRequestResponse(
                responseMessage: "Invalid match id provided.");
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, equals(expectedResponseString));
            expect(response.statusCode, equals(expectedResponse.statusCode));

            // cleanup
          },
        );

        // given player id cannot be converted to int
        test(
          "given a [Request] with invalid [playerId] query parameter"
          "when [.validate()] is called"
          "then should return expected response",
          () async {
            // setup
            final uri = Uri.parse(
                "http://www.test.com/match-participation/store?participation_status=pendingDecision&match_id=1&player_id=invalidPlayerId");

            // given
            when(() => request.url).thenReturn(uri);

            // when
            final response = await validator.validate(
              validatedRequestHandler: validatedRequestHandler.call,
            )(request);
            final responseString = await response.readAsString();

            // then
            final expectedResponse = generateTestBadRequestResponse(
                responseMessage: "Invalid player id provided.");
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, equals(expectedResponseString));
            expect(response.statusCode, equals(expectedResponse.statusCode));

            // cleanup
          },
        );

        // given valid request, call validated request handler
        test(
          "given a valid request"
          "when [.validate()] is called"
          "then should return result of a call to validatedRequestHandler",
          () async {
            // setup
            final fakeRequest = _FakeRequest();

            final uri = Uri.parse(
                "http://www.test.com/match-participation/store?participation_status=pendingDecision&match_id=1&player_id=1");

            final validatedRequestHandlerResponse = Response(200);
            when(() => validatedRequestHandler.call(any()))
                .thenAnswer((_) async => validatedRequestHandlerResponse);

            when(() => request.change(context: any(named: "context")))
                .thenReturn(fakeRequest);

            // given
            when(() => request.url).thenReturn(uri);

            // when
            final response = await validator.validate(
                validatedRequestHandler: validatedRequestHandler.call)(request);

            // then
            expect(response, equals(validatedRequestHandlerResponse));
          },
        );

        // given valid request with pending participation status, expected changed request
        test(
          "given a [Request] with [participationStatus] query parameter set to 'pendingDecision'"
          "when [.validate()] is called"
          "then should call [validatedRequestHandler] with expected [changedRequest]",
          () async {
            // setup
            when(() => validatedRequestHandler(any()))
                .thenAnswer((_) async => Response(200));

            // given
            final realRequest = Request(
              "post",
              Uri.parse(
                  "http://www.test.com/match-participation/store?participation_status=pendingDecision&match_id=1&player_id=1"),
            );

            // when
            await validator.validate(
              validatedRequestHandler: validatedRequestHandler.call,
            )(realRequest);

            // then
            final expectedValidatedUrlQueryParamsData = {
              "participation_status": "pendingDecision",
              "match_id": 1,
              "player_id": 1,
            };

            final capturedRequest = verify(() => validatedRequestHandler(
                  captureAny(),
                )).captured.first as Request;

            final validatedUrlQueryParamsData = capturedRequest
                .context[RequestConstants.VALIDATED_URL_QUERY_PARAMS.value];

            expect(
              validatedUrlQueryParamsData,
              equals(expectedValidatedUrlQueryParamsData),
            );

            // cleanup
          },
        );

        // given valid request with accepted participation status, expected changed request
        test(
          "given a [Request] with [participationStatus] query parameter set to 'arriving'"
          "when [.validate()] is called"
          "then should call [validatedRequestHandler] with expected [changedRequest]",
          () async {
            // setup
            when(() => validatedRequestHandler(any()))
                .thenAnswer((_) async => Response(200));

            // given
            final realRequest = Request(
              "post",
              Uri.parse(
                  "http://www.test.com/match-participation/store?participation_status=arriving&match_id=1&player_id=1"),
            );

            // when
            await validator.validate(
              validatedRequestHandler: validatedRequestHandler.call,
            )(realRequest);

            // then
            final expectedValidatedUrlQueryParamsData = {
              "participation_status": "arriving",
              "match_id": 1,
              "player_id": 1,
            };

            final capturedRequest = verify(() => validatedRequestHandler(
                  captureAny(),
                )).captured.first as Request;

            final validatedUrlQueryParamsData = capturedRequest
                .context[RequestConstants.VALIDATED_URL_QUERY_PARAMS.value];

            expect(
              validatedUrlQueryParamsData,
              equals(expectedValidatedUrlQueryParamsData),
            );

            // cleanup
          },
        );

        // given valid request with rejected participation status, expected changed request
        test(
          "given a [Request] with [participationStatus] query parameter set to 'notArriving'"
          "when [.validate()] is called"
          "then should call [validatedRequestHandler] with expected [changedRequest]",
          () async {
            // setup
            when(() => validatedRequestHandler(any()))
                .thenAnswer((_) async => Response(200));

            // given
            final realRequest = Request(
              "post",
              Uri.parse(
                  "http://www.test.com/match-participation/store?participation_status=notArriving&match_id=1&player_id=1"),
            );

            // when
            await validator.validate(
              validatedRequestHandler: validatedRequestHandler.call,
            )(realRequest);

            // then
            final expectedValidatedUrlQueryParamsData = {
              "participation_status": "notArriving",
              "match_id": 1,
              "player_id": 1,
            };

            final capturedRequest = verify(() => validatedRequestHandler(
                  captureAny(),
                )).captured.first as Request;

            final validatedUrlQueryParamsData = capturedRequest
                .context[RequestConstants.VALIDATED_URL_QUERY_PARAMS.value];

            expect(
              validatedUrlQueryParamsData,
              equals(expectedValidatedUrlQueryParamsData),
            );

            // cleanup
          },
        );
      },
    );
  });
}

class _MockRequest extends Mock implements Request {}

class _MockValidatedRequestHandlderWrapper extends Mock {
  Future<Response> call(Request request);
}

class _FakeRequest extends Fake implements Request {}

// TODO test for data source for participation - it should not store participation if match or player dont exist - test that to make sure there is a throw
