import 'dart:async';

import 'package:five_on_4_backend/src/features/auth/utils/middlewares/authorize_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/auth/utils/validators/authorize_request_validator.dart';
import 'package:five_on_4_backend/src/features/matches/presentation/controllers/search_matches_controller.dart';
import 'package:five_on_4_backend/src/features/players/presentation/router/players_router.dart';
import 'package:five_on_4_backend/src/features/players/utils/middlewares/search_players_request_middleware_wrapper.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  // controllers
  final searchMatchesController = _MockSearchMatchesController();

  // request handlers - not validators here - we dont care about it - this is effectively inner handlers
  final authorizationMiddlewareRequestHandler =
      _MockMiddlewareRequestHandlerCallback();
  final searchPlayersMiddlewareRequestHandler =
      _MockMiddlewareRequestHandlerCallback();

  // middleware wrappers
  final requestAuthorizationMiddleware =
      _MockAuthorizeRequestMiddlewareWrapper();
  final searchPlayersMiddlewareWrapper =
      _MockSearchPlayersRequestMiddlewareWrapper();

  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });

  setUp(() {
    // request handlers
    when(() => authorizationMiddlewareRequestHandler(any())).thenAnswer(
      // (_) async => null,
      (_) async {
        // return Response(200);
        return null;
      },
    );
    when(() => searchPlayersMiddlewareRequestHandler(any())).thenAnswer(
      // (_) async => null,
      (_) async {
        // return Response(200);
        return null;
      },
    );

    // middleware wrappers
    when(() => requestAuthorizationMiddleware()).thenReturn(
      // (innerHandler) {
      //   return authorizationMiddlewareRequestHandler.call;
      // },
      createMiddleware(
        requestHandler: authorizationMiddlewareRequestHandler.call,
      ),
      // TODO we could have usedd createMiddleware here
      // (innerHandler) => (request) => innerHandler(request),
    );
    when(() => searchPlayersMiddlewareWrapper()).thenReturn(
      // (innerHandler) {
      //   return searchPlayersMiddlewareRequestHandler.call;
      // },
      // using create middleware to make sure we can simply return null from above request handlers and propagate request to next middlewares
      createMiddleware(
        requestHandler: searchPlayersMiddlewareRequestHandler.call,
      ),
      // TODO we could have usedd createMiddleware here
      // (innerHandler) => (request) => innerHandler(request),
    );

    // controllers
    when(() => searchMatchesController.call(any())).thenAnswer(
      (_) async => Response.ok('searchMatchesController'),
    );
  });

  tearDown(() {
    reset(searchMatchesController);
    // middleware wrappers
    reset(requestAuthorizationMiddleware);
    reset(searchPlayersMiddlewareRequestHandler);
    // request handlers
    reset(authorizationMiddlewareRequestHandler);
    reset(searchPlayersMiddlewareRequestHandler);
  });

  group("$PlayersRouter", () {
    group("get /search", () {
      final realRequest =
          Request('get', Uri.parse('https://www.example/search'));
      test(
        "given [AuthorizeRequestMiddlewareWrapper] instance"
        "when a request is made to the endpoint"
        "then should call [requestAuthorizationMiddleware]'s inner handler to ensure that middleware is triggered",
        () async {
          // setup

          // given
          final playersRouter = PlayersRouter(
            searchMatchesController: searchMatchesController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            searchPlayersRequestMiddlewareWrapper:
                searchPlayersMiddlewareWrapper,
          );

          // when
          await playersRouter.router(realRequest);

          // then
          final captured = verify(() => authorizationMiddlewareRequestHandler(
                captureAny(),
              ));

          final capturedRequest = captured.captured.single as Request;

          expect(
              capturedRequest.method,
              equals(
                realRequest.method,
              ));

          expect(
              capturedRequest.url,
              equals(
                realRequest.url,
              ));

          // cleanup
        },
      );

      test(
        "given [SearchPlayersRequestMiddlewareWrapper] instance"
        "when a request is made to the endpoint"
        "then should call [searchPlayersMiddlewareWrapper]'s inner handler to ensure that middleware is triggered",
        () async {
          // setup

          // given
          final playersRouter = PlayersRouter(
            searchMatchesController: searchMatchesController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            searchPlayersRequestMiddlewareWrapper:
                searchPlayersMiddlewareWrapper,
          );

          // when
          await playersRouter.router(realRequest);

          // then
          final captured = verify(() => searchPlayersMiddlewareRequestHandler(
                captureAny(),
              ));

          final capturedRequest = captured.captured.single as Request;

          expect(
              capturedRequest.method,
              equals(
                realRequest.method,
              ));

          expect(
              capturedRequest.url,
              equals(
                realRequest.url,
              ));

          // cleanup
        },
      );

      test(
        "given [SearchMatchesController] instance"
        "when a request is made to the endpoint"
        "then should call [searchMatchesController]'s call method",
        () async {
          // setup
          final playersRouter = PlayersRouter(
            searchMatchesController: searchMatchesController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            searchPlayersRequestMiddlewareWrapper:
                searchPlayersMiddlewareWrapper,
          );

          // given

          // when
          await playersRouter.router(realRequest);

          // then
          final captured = verify(() => searchMatchesController.call(
                captureAny(),
              ));
          final capturedRequest = captured.captured.single as Request;

          expect(
              capturedRequest.method,
              equals(
                realRequest.method,
              ));

          expect(
              capturedRequest.url,
              equals(
                realRequest.url,
              ));

          // cleanup
        },
      );
    });
  });
}

class _MockSearchMatchesController extends Mock
    implements SearchMatchesController {}

class _MockAuthorizeRequestMiddlewareWrapper extends Mock
    implements AuthorizeRequestMiddlewareWrapper {}

class _MockSearchPlayersRequestMiddlewareWrapper extends Mock
    implements SearchPlayersRequestMiddlewareWrapper {}

// validator
// TODO this not mimic real validator - it is just a simple request handler used to ensure that middleware wrapper will pass request to its middleware, and then that middleware will pass request to inner handler
// these are effectively inner handlers
class _MockMiddlewareRequestHandlerCallback extends Mock {
  FutureOr<Response?> call(Request request);
}

class _FakeRequest extends Fake implements Request {}
