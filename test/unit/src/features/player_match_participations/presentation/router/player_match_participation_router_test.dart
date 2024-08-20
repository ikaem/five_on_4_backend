import 'dart:async';

import 'package:five_on_4_backend/src/features/auth/utils/middlewares/authorize_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/presentation/controllers/store_player_match_participation_controller.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/presentation/router/player_match_participation_router.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/utils/middlewares/store_player_match_participation_request_middleware_wrapper.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
// controllers
  final storePlayerMatchParticipationController =
      _MockStorePlayerMatchParticipationController();

  // request handlers
  final authorizationMiddlewareRequestHandler =
      _MockMidlewareRequestHandlerCallback();
  final storePlayerMatchParticipationRequestMiddlewareRequestHandler =
      _MockMidlewareRequestHandlerCallback();

  // middlewares
  final authorizeRequestMiddlewareWrapper =
      _MockAuthorizeRequestMiddlewareWrapper();
  final storePlayerMatchParticipationRequestMiddlewareWrapper =
      _MockStorePlayerMatchParticipationRequestMiddlewareWrapper();

  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });

  setUp(() {
    // request handlers
    when(() => authorizationMiddlewareRequestHandler(any()))
        .thenAnswer((_) async => null);

    when(() =>
            storePlayerMatchParticipationRequestMiddlewareRequestHandler(any()))
        .thenAnswer((_) async => null);

    // middlewares
    when(() => authorizeRequestMiddlewareWrapper()).thenReturn(
      createMiddleware(
        requestHandler: authorizationMiddlewareRequestHandler.call,
      ),
    );

    when(() => storePlayerMatchParticipationRequestMiddlewareWrapper())
        .thenReturn(
      createMiddleware(
        requestHandler:
            storePlayerMatchParticipationRequestMiddlewareRequestHandler.call,
      ),
    );

    // controllers
    when(() => storePlayerMatchParticipationController.call(any()))
        .thenAnswer((_) async => Response.ok('ok'));

    when(() => storePlayerMatchParticipationController.call(any()))
        .thenAnswer((_) async => Response.ok('ok'));
  });

  tearDown(() {
    // request handlers
    reset(authorizationMiddlewareRequestHandler);
    reset(storePlayerMatchParticipationRequestMiddlewareRequestHandler);

    // middlewares
    reset(authorizeRequestMiddlewareWrapper);
    reset(storePlayerMatchParticipationRequestMiddlewareWrapper);

    // controllers
    reset(storePlayerMatchParticipationController);
  });

  group(
    "$PlayerMatchParticipationRouter",
    () {
      group(
        ".post /store",
        () {
          final realRequest = Request(
            "post",
            Uri.parse("https://www.example/store"),
          );

          test(
            "given [AuthorizeRequestMiddlewareWrapper] instance"
            "when [Request] is made to the endpoint"
            "then should call [requestAuthorizationMiddleware]'s inner handler to ensure that middleware is triggered",
            () async {
              // setup
              final PlayerMatchParticipationRouter
                  playerMatchParticipationRouter =
                  PlayerMatchParticipationRouter(
                storePlayerMatchParticipationController:
                    storePlayerMatchParticipationController,
                requestAuthorizationMiddleware:
                    authorizeRequestMiddlewareWrapper,
                storePlayerMatchParticipationRequestMiddlewareWrapper:
                    storePlayerMatchParticipationRequestMiddlewareWrapper,
              );

              // given

              // when
              await playerMatchParticipationRouter.router(realRequest);

              // then
              final captured =
                  verify(() => authorizationMiddlewareRequestHandler(
                        captureAny(),
                      )).captured;
              final capturedRequest = captured.single as Request;

              expect(capturedRequest.method, equals(realRequest.method));
              expect(capturedRequest.url, equals(realRequest.url));

              // cleanup
            },
          );

          test(
            "given [StorePlayerMatchParticipationRequestMiddlewareWrapper] instance"
            "when a [Request] is made to the endpoint"
            "then should call [StorePlayerMatchParticipationRequestMiddlewareWrapper]'s inner handler to ensure that middleware is triggered",
            () async {
              // setup
              final PlayerMatchParticipationRouter
                  playerMatchParticipationRouter =
                  PlayerMatchParticipationRouter(
                storePlayerMatchParticipationController:
                    storePlayerMatchParticipationController,
                requestAuthorizationMiddleware:
                    authorizeRequestMiddlewareWrapper,
                storePlayerMatchParticipationRequestMiddlewareWrapper:
                    storePlayerMatchParticipationRequestMiddlewareWrapper,
              );

              // given

              // when
              await playerMatchParticipationRouter.router(realRequest);

              // then
              final captured = verify(() =>
                  storePlayerMatchParticipationRequestMiddlewareRequestHandler(
                    captureAny(),
                  )).captured;

              final capturedRequest = captured.single as Request;

              expect(capturedRequest.method, equals(realRequest.method));
              expect(capturedRequest.url, equals(realRequest.url));

              // cleanup
            },
          );

          test(
            "given [StorePlayerMatchParticipationController] instance"
            "when a [Request] is made to the endpoint"
            "then should call [StorePlayerMatchParticipationController] once",
            () async {
              // setup
              final PlayerMatchParticipationRouter
                  playerMatchParticipationRouter =
                  PlayerMatchParticipationRouter(
                storePlayerMatchParticipationController:
                    storePlayerMatchParticipationController,
                requestAuthorizationMiddleware:
                    authorizeRequestMiddlewareWrapper,
                storePlayerMatchParticipationRequestMiddlewareWrapper:
                    storePlayerMatchParticipationRequestMiddlewareWrapper,
              );

              // given

              // when
              await playerMatchParticipationRouter.router(realRequest);

              // then
              final captured =
                  verify(() => storePlayerMatchParticipationController.call(
                        captureAny(),
                      )).captured;

              final capturedRequest = captured.single as Request;

              expect(capturedRequest.method, equals(realRequest.method));
              expect(capturedRequest.url, equals(realRequest.url));

              // cleanup
            },
          );
        },
      );
    },
  );
}

class _MockStorePlayerMatchParticipationController extends Mock
    implements StorePlayerMatchParticipationController {}

class _MockAuthorizeRequestMiddlewareWrapper extends Mock
    implements AuthorizeRequestMiddlewareWrapper {}

class _MockStorePlayerMatchParticipationRequestMiddlewareWrapper extends Mock
    implements StorePlayerMatchParticipationRequestMiddlewareWrapper {}

class _MockMidlewareRequestHandlerCallback extends Mock {
  FutureOr<Response?> call(Request request);
}

class _FakeRequest extends Fake implements Request {}
