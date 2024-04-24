import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/matches/presentation/controllers/get_match_controller.dart';
import '../../../../../../../bin/src/features/matches/presentation/router/matches_router.dart';
import '../../../../../../../bin/src/wrappers/local/custom_middleware/custom_middleware_wrapper.dart';

Middleware function = (innerHandler) {
  return (request) {
    return Future.sync(() => innerHandler(request)).then((response) {
      return response;
    });
  };
};

void main() {
  final getMatchController = _MockGetMatchController();
  final requestAuthorizationMiddleware =
      _MockRequestAuthorizationMiddlewareWrapper();
  final authorizationRequestHandler = _MockMiddlewareRequestHandlerCallback();

  setUp(() {
    when(() => authorizationRequestHandler.call(any()))
        .thenAnswer((invocation) async {
      // NOTE return null to propagate request to the next middleware - the handler
      return null;
    });
    when(() => requestAuthorizationMiddleware.call()).thenReturn(
      createMiddleware(
        requestHandler: authorizationRequestHandler.call,
      ),
    );

    when(() => getMatchController.call(any())).thenAnswer((invocation) async {
      return Response.ok("ok");
    });
  });

  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });

  tearDown(() {
    reset(getMatchController);
    reset(requestAuthorizationMiddleware);
    reset(authorizationRequestHandler);
  });

  group("$MatchesRouter", () {
    group("/<id>", () {
      final realRequest = Request(
        "get",
        Uri.parse("https://example.com/1"),
      );

      test(
        "given AuthorizationMiddleware instance "
        "when a request to the endpoint is made"
        "then should call the AuthorizationMiddleware's request handler",
        () async {
          // setup
          final matchesRouter = MatchesRouter(
            getMatchController: getMatchController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
          );

          // given

          // when
          await matchesRouter.router(realRequest);

          // then
          final captured =
              verify(() => authorizationRequestHandler.call(captureAny()))
                  .captured;
          final capturedRequest = captured[0] as Request;

          expect(capturedRequest.method, equals(realRequest.method));
          expect(capturedRequest.url, equals(realRequest.url));

          // cleanup
        },
      );

      test(
          "given GetMatchController instance"
          "when a request to the endpoint is made"
          "then should call the GetMatchController instance", () async {
        // setup
        final matchesRouter = MatchesRouter(
          getMatchController: getMatchController,
          requestAuthorizationMiddleware: requestAuthorizationMiddleware,
        );

        // given

        // when
        await matchesRouter.router(realRequest);

        // then
        final captured =
            verify(() => getMatchController.call(captureAny())).captured;
        final capturedRequest = captured[0] as Request;

        expect(capturedRequest.method, equals(realRequest.method));
        expect(capturedRequest.url, equals(realRequest.url));

        // cleanup
      });
    });
  });
}

class _MockGetMatchController extends Mock implements GetMatchController {}

class _MockRequestAuthorizationMiddlewareWrapper extends Mock
    implements CustomMiddlewareWrapper {}

class _MockMiddlewareRequestHandlerCallback extends Mock {
  FutureOr<Response?> call(Request request);
}

class _FakeRequest extends Fake implements Request {}

// TOD
