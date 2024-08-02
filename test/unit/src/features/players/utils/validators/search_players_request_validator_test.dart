// TODO here we dont have invalid stuff - all filters can be null - but lets stick to the convention

import 'dart:convert';

import 'package:five_on_4_backend/src/features/core/utils/constants/request_constants.dart';
import 'package:five_on_4_backend/src/features/players/utils/constants/search_players_request_body_key_constants.dart';
import 'package:five_on_4_backend/src/features/players/utils/validators/search_players_request_validator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  final request = _MockRequest();
  final validatedRequestHandler = _MockValidatedRequestHandlderWrapper();

// tested class
  final validator = const SearchPlayersRequestValidator();

  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });

  tearDown(() {
    reset(request);
    reset(validatedRequestHandler);
  });

  group("$SearchPlayersRequestValidator", () {
    group(".validate()", () {
      // should throw UnimplementedError
      test(
        "given a valid request"
        "when .validate() is called"
        "then should return result of a call to validatedRequestHandler",
        () async {
          // setup
          final changedRequest = _FakeRequest();

          final uri =
              Uri.parse("http://www.test.com/players/search?name_term=name");

          final validatedRequestHandlerResponse = Response(200);
          when(() => validatedRequestHandler.call(any()))
              .thenAnswer((_) async => validatedRequestHandlerResponse);
          when(() => request.change(context: any(named: "context")))
              .thenReturn(changedRequest);
          when(() => request.url).thenReturn(uri);

          // given

          // when
          final response = await validator.validate(
              validatedRequestHandler: validatedRequestHandler.call)(request);

          // then
          expect(response, equals(validatedRequestHandlerResponse));
        },
      );

      test(
        "given a valid request"
        "when [.validate()] is called"
        "then should have expected [changedRequest] passed to [validatedRequestHandler]",
        () async {
          // setup
          final uri =
              Uri.parse("http://www.test.com/players/search?name_term=name");

          when(() => validatedRequestHandler(any()))
              .thenAnswer((_) async => Response(200));
          when(() => request.url).thenReturn(uri);

          // given
          final originalRequest = Request(
            "get",
            uri,
          );

          // when
          await validator.validate(
              validatedRequestHandler: validatedRequestHandler.call)(
            originalRequest,
          );

          // then
          final expectedValidatedUrlQueryParamsData = {
            SearchPlayersRequestBodyKeyConstants.NAME_TERM.value: "name",
          };

          final captured =
              verify(() => validatedRequestHandler.call(captureAny())).captured;
          final changedRequest = captured.first as Request;
          final validatedUrlQueryParamsData = changedRequest
              .context[RequestConstants.VALIDATED_URL_QUERY_PARAMS.value];

          expect(validatedUrlQueryParamsData,
              equals(expectedValidatedUrlQueryParamsData));
          // cleanup
        },
      );
    });
  });
}

class _MockRequest extends Mock implements Request {}

class _MockValidatedRequestHandlderWrapper extends Mock {
  Future<Response> call(Request request);
}

class _FakeRequest extends Fake implements Request {}
