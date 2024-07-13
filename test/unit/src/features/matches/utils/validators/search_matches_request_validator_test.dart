import 'dart:convert';

import 'package:five_on_4_backend/src/features/matches/utils/constants/search_matches_request_body_key_constants.dart';
import 'package:five_on_4_backend/src/features/matches/utils/validators/search_matches_request_validator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  final request = _MockRequest();
  final validatedRequestHandler = _MockValidatedRequestHandlderWrapper();

  // tested class
  final validator = const SearchMatchesRequestValidator();

  setUp(() {
    registerFallbackValue(_FakeRequest());
  });

  tearDown(() {
    reset(request);
    reset(validatedRequestHandler);
  });

  group("$SearchMatchesRequestValidator", () {
    group(".validate()", () {
// should return result of call to validatedRequestHandler
      test(
        "given a valid request"
        "when .validate() is called"
        "then should return result of call to validatedRequestHandler",
        () async {
          // setup
          final changedRequest = _FakeRequest();

          final requestMap = {
            // TODO this can also be null, no problem - we can do it in other test for expected changed request
            SearchMatchesRequestBodyKeyConstants.MATCH_TITLE.value: "title",
          };

          final validatedRequestHandlerResponse = Response(200);
          when(() => validatedRequestHandler.call(any()))
              .thenAnswer((_) async => validatedRequestHandlerResponse);

          when(() => request.change(context: any(named: "context")))
              .thenReturn(changedRequest);

          // given
          when(() => request.readAsString())
              .thenAnswer((_) async => jsonEncode(requestMap));

          // when
          final response = await validator.validate(
              validatedRequestHandler: validatedRequestHandler.call)(request);

          // then
          expect(response, equals(validatedRequestHandlerResponse));

          // cleanup
        },
      );

// should have expected changed request passed to validatedRequestHandler
      test(
        "given <pre-condition to the test>"
        "when <behavior we are specifying>"
        "then should <state we expect to happen>",
        () async {
          // setup
          final requestMap = {
            // NOTE: match title is allowed to be null - maybe some other filters are used in search
            SearchMatchesRequestBodyKeyConstants.MATCH_TITLE.value: null,
          };

          when(() => validatedRequestHandler(any()))
              .thenAnswer((_) async => Response(200));

          // given
          final originalRequest = Request(
            "post",
            Uri.parse("http://www.test.com/"),
            body: jsonEncode(requestMap),
          );

          // when
          await validator.validate(
              validatedRequestHandler:
                  validatedRequestHandler.call)(originalRequest);

          // then
          final expectedValidatedBodyData = {
            SearchMatchesRequestBodyKeyConstants.MATCH_TITLE.value: null,
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
  Future<Response> call(Request request);
}

class _FakeRequest extends Fake implements Request {}
