import 'dart:async';

import 'package:five_on_4_backend/src/features/matches/presentation/controllers/search_matches_controller.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/matches/presentation/controllers/create_match_controller.dart';
import 'package:five_on_4_backend/src/features/matches/presentation/controllers/get_match_controller.dart';
import 'package:five_on_4_backend/src/features/matches/presentation/controllers/get_player_matches_overview_controller.dart';
import 'package:five_on_4_backend/src/features/matches/presentation/router/matches_router.dart';
import 'package:five_on_4_backend/src/features/matches/utils/middlewares/get_player_matches_overview_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/matches/utils/middlewares/match_create_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/wrappers/local/custom_middleware/custom_middleware_wrapper.dart';

// TODO stay here as a reference
// Middleware function = (innerHandler) {
//   return (request) {
//     return Future.sync(() => innerHandler(request)).then((response) {
//       return response;
//     });
//   };
// };

void main() {
  // controllers
  final getMatchController = _MockGetMatchController();
  final createMatchController = _MockCreateMatchController();
  final getPlayerMatchesOverviewController =
      _MockGetPlayerMatchesOverviewController();
  final searchMatchesController = _MockSearchMatchesController();

  // middleware
  final requestAuthorizationMiddleware =
      _MockRequestAuthorizationMiddlewareWrapper();
  final matchCreateRequestMiddleware =
      _MockMatchCreateRequestMiddlewareWrapper();
  final getPlayerMatchesOverviewRequestMiddleware =
      _MockGetPlayerMatchesOverviewRequestMiddlewareWrapper();
  final searchMatchesRequestMiddlewareWrapper =
      _MockSearchMatchesRequestMiddlewareWrapper();

  // validators
  final authorizationRequestHandler = _MockMiddlewareRequestHandlerCallback();
  final matchCreateRequestHandler = _MockMiddlewareRequestHandlerCallback();
  final getPlayerMatchesOverviewRequestHandler =
      _MockMiddlewareRequestHandlerCallback();
  final searchMatchesRequestHandler = _MockMiddlewareRequestHandlerCallback();

  setUp(() {
    // validators - these are not validators - these are
    when(() => authorizationRequestHandler.call(any()))
        .thenAnswer((invocation) async {
      // NOTE return null to propagate request to the next middleware - the handler
      return null;
    });
    when(() => matchCreateRequestHandler.call(any()))
        .thenAnswer((invocation) async {
      // NOTE return null to propagate request to the next middleware - the handler
      return null;
    });
    when(() => getPlayerMatchesOverviewRequestHandler.call(any()))
        .thenAnswer((invocation) async {
      // NOTE return null to propagate request to the next middleware - the handler
      return null;
    });
    when(() => searchMatchesRequestHandler.call(any()))
        .thenAnswer((invocation) async {
      // NOTE return null to propagate request to the next middleware - the handler
      return null;
    });

    // middleware
    // TODO this is ok, i guess - we already that middleware calls the validator
    // here we just want to test that middware will call the handler with correct rquest
    // here we just want to verify that whatever request is passed to the middleware, middleware will pass it on
    when(() => requestAuthorizationMiddleware.call()).thenReturn(
      createMiddleware(
        requestHandler: authorizationRequestHandler.call,
      ),
    );
    when(() => matchCreateRequestMiddleware.call()).thenReturn(
      createMiddleware(
        requestHandler: matchCreateRequestHandler.call,
      ),
    );
    when(() => getPlayerMatchesOverviewRequestMiddleware.call()).thenReturn(
      createMiddleware(
        requestHandler: getPlayerMatchesOverviewRequestHandler.call,
      ),
    );
    when(() => searchMatchesRequestMiddlewareWrapper.call()).thenReturn(
      createMiddleware(
        requestHandler: searchMatchesRequestHandler.call,
      ),
    );

    // controllers
    when(() => createMatchController.call(any()))
        .thenAnswer((invocation) async {
      return Response.ok("ok");
    });
    when(() => getMatchController.call(any())).thenAnswer((invocation) async {
      return Response.ok("ok");
    });
    when(() => getPlayerMatchesOverviewController.call(any()))
        .thenAnswer((invocation) async {
      return Response.ok("ok");
    });
    when(() => searchMatchesController.call(any()))
        .thenAnswer((invocation) async {
      return Response.ok("ok");
    });
  });

  tearDown(() {
    reset(getMatchController);
    reset(createMatchController);
    reset(getPlayerMatchesOverviewController);
    reset(searchMatchesController);
    reset(requestAuthorizationMiddleware);
    reset(matchCreateRequestMiddleware);
    reset(getPlayerMatchesOverviewRequestMiddleware);
    reset(searchMatchesRequestMiddlewareWrapper);
    reset(authorizationRequestHandler);
    reset(matchCreateRequestHandler);
    reset(getPlayerMatchesOverviewRequestHandler);
    reset(searchMatchesRequestHandler);
  });

  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });
  group("$MatchesRouter", () {
    group(
      // TODO in future, this should be a get
      "post /search",
      () {
        final realRequest = Request(
          "get",
          // TODO this is bad test - it does not actually test /search - it test something else
          Uri.parse("https://example.com/"),
        );

        // TODO missing test for controller

        test(
          "given AuthorizationMiddleware instance"
          "when a request to the endpoint is made"
          // TODO we effectively test here that middleware is triggered
          // NOTE: and for controller, we test that the controller is triggered
          "then should call the AuthorizationMiddleware's request handler",
          () async {
            // setup

            // given
            final matchesRouter = MatchesRouter(
              getMatchController: getMatchController,
              createMatchController: createMatchController,
              getPlayerMatchesOverviewController:
                  getPlayerMatchesOverviewController,
              searchMatchesController: searchMatchesController,
              requestAuthorizationMiddleware: requestAuthorizationMiddleware,
              matchCreateRequestMiddleware: matchCreateRequestMiddleware,
              getPlayerMatchesOverviewRequestMiddleware:
                  getPlayerMatchesOverviewRequestMiddleware,
              searchMatchesRequestMiddlewareWrapper:
                  searchMatchesRequestMiddlewareWrapper,
            );

            // when
            await matchesRouter.router(realRequest);

            // then
            final captured = verify(
              () => authorizationRequestHandler.call(captureAny()),
            ).captured;
            final capturedRequest = captured[0] as Request;

            expect(capturedRequest.method, equals(realRequest.method));
            expect(capturedRequest.url, equals(realRequest.url));

            // cleanup
          },
        );
      },
    );

    group("get /player-matches-overview", () {
      final realRequest = Request(
          "get", Uri.parse("https://example.com/player-matches-overview"));

      test(
        "given AuthorizationMiddleware instance"
        "when a request to the endpoint is made"
        "then should call the AuthorizationMiddleware's request handler with correct request",
        () async {
          // setup
          final matchesRouter = MatchesRouter(
            getMatchController: getMatchController,
            createMatchController: createMatchController,
            getPlayerMatchesOverviewController:
                getPlayerMatchesOverviewController,
            searchMatchesController: searchMatchesController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            matchCreateRequestMiddleware: matchCreateRequestMiddleware,
            getPlayerMatchesOverviewRequestMiddleware:
                getPlayerMatchesOverviewRequestMiddleware,
            searchMatchesRequestMiddlewareWrapper:
                searchMatchesRequestMiddlewareWrapper,
          );

          // given

          // when
          await matchesRouter.router(realRequest);

          // then
          final captured = verify(
            () => authorizationRequestHandler.call(captureAny()),
          ).captured;
          final capturedRequest = captured[0] as Request;

          expect(capturedRequest.method, equals(realRequest.method));
          expect(capturedRequest.url, equals(realRequest.url));

          // cleanup
        },
      );

      test(
        "given GetPlayerMatchesOverviewRequestMiddleware instance"
        "when a request to the endpoint is made"
        "then should call the GetPlayerMatchesOverviewRequestMiddleware's request handler",
        () async {
          // setup
          final matchesRouter = MatchesRouter(
            getMatchController: getMatchController,
            createMatchController: createMatchController,
            getPlayerMatchesOverviewController:
                getPlayerMatchesOverviewController,
            searchMatchesController: searchMatchesController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            matchCreateRequestMiddleware: matchCreateRequestMiddleware,
            getPlayerMatchesOverviewRequestMiddleware:
                getPlayerMatchesOverviewRequestMiddleware,
            searchMatchesRequestMiddlewareWrapper:
                searchMatchesRequestMiddlewareWrapper,
          );

          // given

          // when
          await matchesRouter.router(realRequest);

          // then
          final captured = verify(
            () => getPlayerMatchesOverviewRequestHandler.call(captureAny()),
          ).captured;
          final capturedRequest = captured[0] as Request;

          expect(capturedRequest.method, equals(realRequest.method));
          expect(capturedRequest.url, equals(realRequest.url));

          // cleanup
        },
      );

      test(
        "given GetPlayerMatchesOverviewController instance"
        "when a request to the endpoint is made"
        "then should call the GetPlayerMatchesOverviewController instance",
        () async {
          // setup
          final matchesRouter = MatchesRouter(
            getMatchController: getMatchController,
            createMatchController: createMatchController,
            getPlayerMatchesOverviewController:
                getPlayerMatchesOverviewController,
            searchMatchesController: searchMatchesController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            matchCreateRequestMiddleware: matchCreateRequestMiddleware,
            getPlayerMatchesOverviewRequestMiddleware:
                getPlayerMatchesOverviewRequestMiddleware,
            searchMatchesRequestMiddlewareWrapper:
                searchMatchesRequestMiddlewareWrapper,
          );

          // given

          // when
          await matchesRouter.router(realRequest);

          // then
          final captured = verify(
            () => getPlayerMatchesOverviewController.call(captureAny()),
          ).captured;
          final capturedRequest = captured[0] as Request;

          expect(capturedRequest.method, equals(realRequest.method));
          expect(capturedRequest.url, equals(realRequest.url));

          // cleanup
        },
      );
    });

    group("post /", () {
      final realRequest = Request("post", Uri.parse("https://example.com/"));

      test(
        "given AuthorizationMiddleware instance"
        "when a request to the endpoint is made"
        "then should call the AuthorizationMiddleware's request handler",
        () async {
          // setup
          // TODO maybe this can be moved up
          final matchesRouter = MatchesRouter(
            getMatchController: getMatchController,
            createMatchController: createMatchController,
            getPlayerMatchesOverviewController:
                getPlayerMatchesOverviewController,
            searchMatchesController: searchMatchesController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            matchCreateRequestMiddleware: matchCreateRequestMiddleware,
            getPlayerMatchesOverviewRequestMiddleware:
                getPlayerMatchesOverviewRequestMiddleware,
            searchMatchesRequestMiddlewareWrapper:
                searchMatchesRequestMiddlewareWrapper,
          );

          // given

          // when
          await matchesRouter.router(realRequest);

          // then
          final captured =
              verify(() => authorizationRequestHandler.call(captureAny()))
                  .captured;
          final captureRequest = captured.first as Request;

          expect(captureRequest.method, equals(realRequest.method));
          expect(captureRequest.url, equals(realRequest.url));

          // cleanup
        },
      );

      test(
        "given MatchCreateRequestMiddleware instance"
        "when a request to the endpoint is made"
        "then should call the MatchCreateRequestMiddleware's request handler",
        () async {
          // setup
          final matchesRouter = MatchesRouter(
            getMatchController: getMatchController,
            createMatchController: createMatchController,
            getPlayerMatchesOverviewController:
                getPlayerMatchesOverviewController,
            searchMatchesController: searchMatchesController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            matchCreateRequestMiddleware: matchCreateRequestMiddleware,
            getPlayerMatchesOverviewRequestMiddleware:
                getPlayerMatchesOverviewRequestMiddleware,
            searchMatchesRequestMiddlewareWrapper:
                searchMatchesRequestMiddlewareWrapper,
          );

          // given

          // when
          await matchesRouter.router(realRequest);

          // then
          final captured =
              verify(() => matchCreateRequestHandler.call(captureAny()))
                  .captured;
          final capturedRequest = captured[0] as Request;

          expect(capturedRequest.method, equals(realRequest.method));
          expect(capturedRequest.url, equals(realRequest.url));

          // cleanup
        },
      );

      test(
        "given createMatchController instance"
        "when a request to the endpoint is made"
        "then should call the CreateMatchController instance",
        () async {
          // setup
          final matchesRouter = MatchesRouter(
            getMatchController: getMatchController,
            createMatchController: createMatchController,
            getPlayerMatchesOverviewController:
                getPlayerMatchesOverviewController,
            searchMatchesController: searchMatchesController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            matchCreateRequestMiddleware: matchCreateRequestMiddleware,
            getPlayerMatchesOverviewRequestMiddleware:
                getPlayerMatchesOverviewRequestMiddleware,
            searchMatchesRequestMiddlewareWrapper:
                searchMatchesRequestMiddlewareWrapper,
          );

          // given

          // when
          await matchesRouter.router(realRequest);

          // then
          final captured =
              verify(() => createMatchController.call(captureAny())).captured;
          final capturedRequest = captured[0] as Request;

          expect(capturedRequest.method, equals(realRequest.method));
          expect(capturedRequest.url, equals(realRequest.url));

          // cleanup
        },
      );
    });

    group("get /<id>", () {
      final realRequest = Request(
        "get",
        Uri.parse("https://example.com/1"),
      );
      //

      test(
        "given AuthorizationMiddleware instance "
        "when a request to the endpoint is made"
        "then should call the AuthorizationMiddleware's request handler",
        () async {
          // setup
          final matchesRouter = MatchesRouter(
            getMatchController: getMatchController,
            createMatchController: createMatchController,
            getPlayerMatchesOverviewController:
                getPlayerMatchesOverviewController,
            searchMatchesController: searchMatchesController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            matchCreateRequestMiddleware: matchCreateRequestMiddleware,
            getPlayerMatchesOverviewRequestMiddleware:
                getPlayerMatchesOverviewRequestMiddleware,
            searchMatchesRequestMiddlewareWrapper:
                searchMatchesRequestMiddlewareWrapper,
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
          createMatchController: createMatchController,
          getPlayerMatchesOverviewController:
              getPlayerMatchesOverviewController,
          searchMatchesController: searchMatchesController,
          requestAuthorizationMiddleware: requestAuthorizationMiddleware,
          matchCreateRequestMiddleware: matchCreateRequestMiddleware,
          getPlayerMatchesOverviewRequestMiddleware:
              getPlayerMatchesOverviewRequestMiddleware,
          searchMatchesRequestMiddlewareWrapper:
              searchMatchesRequestMiddlewareWrapper,
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

// controllers
class _MockGetMatchController extends Mock implements GetMatchController {}

class _MockCreateMatchController extends Mock
    implements CreateMatchController {}

class _MockGetPlayerMatchesOverviewController extends Mock
    implements GetPlayerMatchesOverviewController {}

class _MockSearchMatchesController extends Mock
    implements SearchMatchesController {}

// middleware
class _MockRequestAuthorizationMiddlewareWrapper extends Mock
    implements CustomMiddlewareWrapper {}

class _MockMatchCreateRequestMiddlewareWrapper extends Mock
    implements MatchCreateRequestMiddlewareWrapper {}

class _MockGetPlayerMatchesOverviewRequestMiddlewareWrapper extends Mock
    implements GetPlayerMatchesOverviewRequestMiddlewareWrapper {}

class _MockSearchMatchesRequestMiddlewareWrapper extends Mock
    implements CustomMiddlewareWrapper {}

// validator
class _MockMiddlewareRequestHandlerCallback extends Mock {
  FutureOr<Response?> call(Request request);
}

class _FakeRequest extends Fake implements Request {}

// TOD
