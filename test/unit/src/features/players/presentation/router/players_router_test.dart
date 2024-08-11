import 'dart:async';

import 'package:five_on_4_backend/src/features/auth/utils/middlewares/authorize_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/players/presentation/controllers/get_player_controller.dart';
import 'package:five_on_4_backend/src/features/players/presentation/controllers/search_players_controller.dart';
import 'package:five_on_4_backend/src/features/players/presentation/router/players_router.dart';
import 'package:five_on_4_backend/src/features/players/utils/middlewares/get_player_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/players/utils/middlewares/search_players_request_middleware_wrapper.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  // controllers
  final searchPlayersController = _MockSearchPlayersController();
  final getPlayerController = _MockGetPlayerController();
  final getPlayerRequestMiddlewareWrapper =
      _MockGetPlayerRequestMiddlewareWrapper();

  // request handlers - not validators here - we dont care about it - this is effectively inner handlers
  final authorizationMiddlewareRequestHandler =
      _MockMiddlewareRequestHandlerCallback();
  final searchPlayersMiddlewareRequestHandler =
      _MockMiddlewareRequestHandlerCallback();
  final getPlayerMiddlewareRequestHandler =
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
    when(() => getPlayerMiddlewareRequestHandler(any())).thenAnswer(
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
    when(() => getPlayerRequestMiddlewareWrapper()).thenReturn(
      // (innerHandler) {
      //   return getPlayerMiddlewareRequestHandler.call;
      // },
      createMiddleware(
        requestHandler: getPlayerMiddlewareRequestHandler.call,
      ),
      // TODO we could have usedd createMiddleware here
      // (innerHandler) => (request) => innerHandler(request),
    );

    // controllers
    when(() => searchPlayersController.call(any())).thenAnswer(
      (_) async => Response.ok('searchMatchesController'),
    );
    when(() => getPlayerController.call(any())).thenAnswer(
      (_) async => Response.ok('getPlayerController'),
    );
  });

  tearDown(() {
    reset(searchPlayersController);
    reset(getPlayerController);
    // middleware wrappers
    reset(requestAuthorizationMiddleware);
    reset(searchPlayersMiddlewareRequestHandler);
    reset(getPlayerRequestMiddlewareWrapper);
    // request handlers
    reset(authorizationMiddlewareRequestHandler);
    reset(searchPlayersMiddlewareRequestHandler);
    reset(getPlayerMiddlewareRequestHandler);
  });

  group("$PlayersRouter", () {
    group(".get /<id>", () {
      final realRequest = Request('get', Uri.parse('https://www.example/1'));

      test(
        "given [AuthorizeRequestMiddlewareWrapper] instance"
        "when a [Request] is made to the endpoint"
        "then should call [requestAuthorizationMiddleware]'s inner handler to ensure that middleware is triggered",
        () async {
          // setup

          final playersRouter = PlayersRouter(
            searchPlayersController: searchPlayersController,
            getPlayerController: getPlayerController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            searchPlayersRequestMiddlewareWrapper:
                searchPlayersMiddlewareWrapper,
            getPlayerRequestMiddlewareWrapper:
                getPlayerRequestMiddlewareWrapper,
          );
          // given

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
        "given [GetPlayerRequestMiddlewareWrapper] instance"
        "when a [Request] is made to the endpoint"
        "then should call [getPlayerRequestMiddlewareWrapper]'s inner handler to ensure that middleware is triggered",
        () async {
          // setup

          final playersRouter = PlayersRouter(
            searchPlayersController: searchPlayersController,
            getPlayerController: getPlayerController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            searchPlayersRequestMiddlewareWrapper:
                searchPlayersMiddlewareWrapper,
            getPlayerRequestMiddlewareWrapper:
                getPlayerRequestMiddlewareWrapper,
          );
          // given

          // when
          await playersRouter.router(realRequest);

          // then
          final captured = verify(() => getPlayerMiddlewareRequestHandler(
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
        "given [GetPlayerController] instance"
        "when a [Request] is made to the endpoint"
        "then should call [getPlayerController] once",
        () async {
          // setup
          final playersRouter = PlayersRouter(
            searchPlayersController: searchPlayersController,
            getPlayerController: getPlayerController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            searchPlayersRequestMiddlewareWrapper:
                searchPlayersMiddlewareWrapper,
            getPlayerRequestMiddlewareWrapper:
                getPlayerRequestMiddlewareWrapper,
          );

          // given

          // when
          await playersRouter.router(realRequest);

          // then
          final captured = verify(() => getPlayerController.call(
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

    group("get /search", () {
      final realRequest =
          Request('get', Uri.parse('https://www.example/search'));
      test(
        "given [AuthorizeRequestMiddlewareWrapper] instance"
        "when a request is made to the endpoint"
        "then should call [requestAuthorizationMiddleware]'s inner handler to ensure that middleware is triggered",
        () async {
          // setup
          final playersRouter = PlayersRouter(
            searchPlayersController: searchPlayersController,
            getPlayerController: getPlayerController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            searchPlayersRequestMiddlewareWrapper:
                searchPlayersMiddlewareWrapper,
            getPlayerRequestMiddlewareWrapper:
                getPlayerRequestMiddlewareWrapper,
          );

          // given

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
            searchPlayersController: searchPlayersController,
            getPlayerController: getPlayerController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            searchPlayersRequestMiddlewareWrapper:
                searchPlayersMiddlewareWrapper,
            getPlayerRequestMiddlewareWrapper:
                getPlayerRequestMiddlewareWrapper,
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
            searchPlayersController: searchPlayersController,
            getPlayerController: getPlayerController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            searchPlayersRequestMiddlewareWrapper:
                searchPlayersMiddlewareWrapper,
            getPlayerRequestMiddlewareWrapper:
                getPlayerRequestMiddlewareWrapper,
          );

          // given

          // when
          await playersRouter.router(realRequest);

          // then
          final captured = verify(() => searchPlayersController.call(
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

// controllers
class _MockSearchPlayersController extends Mock
    implements SearchPlayersController {}

class _MockGetPlayerController extends Mock implements GetPlayerController {}

// middleware wrappers
class _MockAuthorizeRequestMiddlewareWrapper extends Mock
    implements AuthorizeRequestMiddlewareWrapper {}

class _MockSearchPlayersRequestMiddlewareWrapper extends Mock
    implements SearchPlayersRequestMiddlewareWrapper {}

class _MockGetPlayerRequestMiddlewareWrapper extends Mock
    implements GetPlayerRequestMiddlewareWrapper {}

// validator
// TODO this not mimic real validator - it is just a simple request handler used to ensure that middleware wrapper will pass request to its middleware, and then that middleware will pass request to inner handler
// these are effectively inner handlers
class _MockMiddlewareRequestHandlerCallback extends Mock {
  FutureOr<Response?> call(Request request);
}

class _FakeRequest extends Fake implements Request {}
