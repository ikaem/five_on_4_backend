import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/matches/presentation/controllers/create_match_controller.dart';
import '../../../../../../../bin/src/features/matches/presentation/controllers/get_match_controller.dart';
import '../../../../../../../bin/src/features/matches/presentation/router/matches_router.dart';
import '../../../../../../../bin/src/features/matches/utils/middlewares/match_create_request_middleware_wrapper.dart';
import '../../../../../../../bin/src/wrappers/local/custom_middleware/custom_middleware_wrapper.dart';

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

  // middleware
  final requestAuthorizationMiddleware =
      _MockRequestAuthorizationMiddlewareWrapper();
  final matchCreateRequestMiddleware =
      _MockMatchCreateRequestMiddlewareWrapper();

  // validators
  final authorizationRequestHandler = _MockMiddlewareRequestHandlerCallback();
  final matchCreateRequestHandler = _MockMiddlewareRequestHandlerCallback();

  setUp(() {
    // validators
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

    // middleware
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

    // controllers
    when(() => createMatchController.call(any()))
        .thenAnswer((invocation) async {
      return Response.ok("ok");
    });
    when(() => getMatchController.call(any())).thenAnswer((invocation) async {
      return Response.ok("ok");
    });
  });

  tearDown(() {
    reset(getMatchController);
    reset(createMatchController);
    reset(requestAuthorizationMiddleware);
    reset(matchCreateRequestMiddleware);
    reset(authorizationRequestHandler);
    reset(matchCreateRequestHandler);
  });

  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });
  group("$MatchesRouter", () {
    group("post /", () {
      final realRequest = Request("post", Uri.parse("https://example.com/"));

      test(
        "given AuthorizationMiddleware instance"
        "when a request to the endpoint is made"
        "then should call the AuthorizationMiddleware's request handler",
        () async {
          // setup
          final matchesRouter = MatchesRouter(
            getMatchController: getMatchController,
            createMatchController: createMatchController,
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            matchCreateRequestMiddleware: matchCreateRequestMiddleware,
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
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            matchCreateRequestMiddleware: matchCreateRequestMiddleware,
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
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            matchCreateRequestMiddleware: matchCreateRequestMiddleware,
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
            requestAuthorizationMiddleware: requestAuthorizationMiddleware,
            createMatchController: createMatchController,
            matchCreateRequestMiddleware: matchCreateRequestMiddleware,
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
          createMatchController: createMatchController,
          matchCreateRequestMiddleware: matchCreateRequestMiddleware,
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

class _MockCreateMatchController extends Mock
    implements CreateMatchController {}

class _MockRequestAuthorizationMiddlewareWrapper extends Mock
    implements CustomMiddlewareWrapper {}

class _MockMatchCreateRequestMiddlewareWrapper extends Mock
    implements MatchCreateRequestMiddlewareWrapper {}

class _MockMiddlewareRequestHandlerCallback extends Mock {
  FutureOr<Response?> call(Request request);
}

class _FakeRequest extends Fake implements Request {}

// TOD
