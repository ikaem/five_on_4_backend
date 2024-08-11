// what do we need
// get params - maybe because there is not params in request - lets try

import 'dart:collection';

import 'package:five_on_4_backend/src/features/core/utils/constants/request_constants.dart';
import 'package:five_on_4_backend/src/features/players/utils/constants/get_player_request_url_params_key_constants.dart';
import 'package:five_on_4_backend/src/features/players/utils/validators/get_player_request_validator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:test/test.dart';

import '../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();
  final validatedRequestHandler = _MockValidatedRequestHandlerWrapper();

  final validator = GetPlayerRequestValidator();

  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });

  tearDown(() {
    reset(request);
    reset(validatedRequestHandler);
  });

  group(
    "$GetPlayerRequestValidator",
    () {
      group(
        ".validate()",
        () {
          test(
            "given [Request] without valid [id] url parameter"
            "when [.validate] is called"
            "then should return expected response",
            () async {
              // setup
              final paramsMap = {};
              final contextMap = {
                _shelfRouterParamsKey: paramsMap,
              };

              // given
              when(() => request.context).thenReturn(contextMap);

              // when
              final response = await validator.validate(
                validatedRequestHandler: validatedRequestHandler.call,
              )(request);
              final responseString = await response.readAsString();

              // then
              print("what");

              final expectedResponse = generateTestBadRequestResponse(
                responseMessage: "Invalid player id provided.",
              );
              final expectedResponseString =
                  await expectedResponse.readAsString();

              expect(responseString, equals(expectedResponseString));
              expect(response.statusCode, equals(expectedResponse.statusCode));

              // cleanup
            },
          );

          test(
            "given a valid [Request]"
            "when [.validate()] is called"
            "then should return result of call to [validatedRequestHandler]",
            () async {
              // setup
              final changedRequest = _FakeRequest();
              final paramsMap = {
                GetPlayerRequestUrlParamsKeyConstants.ID: "1",
              };
              // TODO we have to stub this specific map
              final contextMap = {
                _shelfRouterParamsKey: paramsMap,
              };

              final validatedRequestHandlerResponse = Response(200);
              when(() => validatedRequestHandler.call(any()))
                  .thenAnswer((_) async => validatedRequestHandlerResponse);

              when(() => request.change(context: any(named: "context")))
                  .thenReturn(changedRequest);

              // given
              when(() => request.context).thenReturn(contextMap);

              // when
              final response = await validator.validate(
                  validatedRequestHandler:
                      validatedRequestHandler.call)(request);

              // then
              verify(() => validatedRequestHandler.call(changedRequest))
                  .called(1);
              expect(response, equals(validatedRequestHandlerResponse));

              // cleanup
            },
          );

          test(
            "given a valid [Request]"
            "when [.validate()] is called"
            "then should should have expected changed [Request] pass ed to [validatedRequestHandler]",
            () async {
              // setup
              final paramsMap = {
                GetPlayerRequestUrlParamsKeyConstants.ID: "1",
              };
              final contextMap = {
                _shelfRouterParamsKey: paramsMap,
              };

              when(() => validatedRequestHandler(any()))
                  .thenAnswer((_) async => Response(200));

              // given
              final realRequest = Request(
                "get",
                Uri.parse("http://example/players"),
                context: contextMap,
              );

              // when
              await validator.validate(
                validatedRequestHandler: validatedRequestHandler.call,
              )(realRequest);

              // then
              final expectedValidatedUrlParametersData = {
                GetPlayerRequestUrlParamsKeyConstants.ID: 1,
              };

              final captured =
                  verify(() => validatedRequestHandler(captureAny())).captured;
              final changedRequest = captured.first as Request;
              final validatedUrlParametersData = changedRequest.context[
                  RequestConstants.VALIDATED_URL_PARAMETERS_DATA.value];

              expect(
                validatedUrlParametersData,
                equals(expectedValidatedUrlParametersData),
              );

              // cleanup
            },
          );
        },
      );
    },
  );
}

class _MockRequest extends Mock implements Request {}

class _MockValidatedRequestHandlerWrapper extends Mock {
  Future<Response> call(Request request);
}

class _FakeRequest extends Fake implements Request {}

const _shelfRouterParamsKey = "shelf_router/params";
