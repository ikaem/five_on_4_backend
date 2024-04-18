import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/utils/middlewares/authorization_middleware.dart';
import '../../../../../../../bin/src/features/matches/presentation/controllers/get_match_controller.dart';
import '../../../../../../../bin/src/features/matches/presentation/router/matches_router.dart';

void main() {
  final getMatchController = _MockGetMatchController();
  final authorizationMiddleware = _MockAuthorizationMiddleware();

  // tested class
  final matchesRouter = MatchesRouter(
    getMatchController: getMatchController,
    authorizationMiddleware: authorizationMiddleware,
  );

  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });

  tearDown(() {
    reset(getMatchController);
    reset(authorizationMiddleware);
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
        "then should call the AuthorizationMiddleware instance",
        () async {
          // setup
          when(() => getMatchController.call(any()))
              .thenAnswer((invocation) async => Response.ok("ok"));

          // given
          when(() => authorizationMiddleware.call()).thenReturn(
            createMiddleware(),
          );

          // when
          final requestHandler = Pipeline()
              .addMiddleware(authorizationMiddleware.call())
              .addHandler(matchesRouter.router.call);

          await requestHandler(realRequest);

          // then

          verify(() => authorizationMiddleware.call()).called(1);
        },
      );

      test(
        "given GetMatchController instance"
        "when a request to the endpoint is made"
        "then should call the GetMatchController instance",
        () async {
          // setup
          when(() => authorizationMiddleware.call()).thenReturn(
            createMiddleware(),
          );

          // given
          when(() => getMatchController.call(any()))
              .thenAnswer((invocation) async => Response.ok("ok"));

          // when
          final requestHandler = Pipeline()
              .addMiddleware(authorizationMiddleware.call())
              .addHandler(matchesRouter.router.call);

          await requestHandler(realRequest);

          // then
          verify(() => getMatchController.call(any())).called(1);

          // cleanup
        },
      );
    });
  });
}

class _MockGetMatchController extends Mock implements GetMatchController {}

class _MockAuthorizationMiddleware extends Mock
    implements AuthorizationMiddleware {
  // TODO test

  // @override
  // Middleware call() {
  //   // final middleware = createMiddleware(
  //   //   requestHandler: (p0) {
  //   //     return null;
  //   //   },
  //   // );

  //   // return middleware;

  //   // TODO: implement call
  //   return (innerHandler) {
  //     return (request) {
  //       // return request;
  //       return Future.sync(() => innerHandler(request)).then((response) {
  //         return response;
  //       });
  //     };
  //   };
  // }
}

class _FakeRequest extends Fake implements Request {}
