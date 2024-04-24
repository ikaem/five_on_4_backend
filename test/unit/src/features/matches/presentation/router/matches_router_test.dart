import 'dart:async';
import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

// import '../../../../../../../bin/src/features/auth/utils/middlewares/another_authorization_middleware.dart';
// import '../../../../../../../bin/src/features/auth/utils/middlewares/authorization_middleware.dart';
import '../../../../../../../bin/src/features/matches/presentation/controllers/get_match_controller.dart';
import '../../../../../../../bin/src/features/matches/presentation/router/matches_router.dart';

// ((Request) => FutureOr<Response>) => (Request) => FutureOr<Response>

Middleware function = (innerHandler) {
  return (request) {
    return Future.sync(() => innerHandler(request)).then((response) {
      return response;
    });
  };
};

void main() {
  final getMatchController = _MockGetMatchController();
  // final authorizationMiddleware = _MockAuthorizationMiddleware();

  // // tested class
  // final matchesRouter = MatchesRouter(
  //   getMatchController: getMatchController,
  //   authorizationMiddleware: authorizationMiddleware,
  // );

  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });

  tearDown(() {
    reset(getMatchController);
    // reset(authorizationMiddleware);
  });

  group("$MatchesRouter", () {
    group("/<id>", () {
      final realRequest = Request(
        "get",
        Uri.parse("https://example.com/1"),
      );

      test(
        "given authorizationMiddlewareWrapper instance"
        "when set get listener for /<id> endpoint"
        "then should call the authorizationMiddlewareWrapper instance",
        () async {
          // setup

          // given

          // when

          // then

          // cleanup
        },
      );

      test(
        "given AuthorizationMiddleware instance "
        "when a request to the endpoint is made"
        "then should call the AuthorizationMiddleware instance",
        () async {
          // final getMatchController = _MockGetMatchController();
          // final authorizationMiddleware = _MockAuthorizationMiddleware();

          // when(() => authorizationMiddleware.call()).thenReturn(
          //   createMiddleware(
          //     requestHandler: (request) {
          //       return Response.ok("ok");
          //     },
          //   ),
          // );
          // setup
          when(() => getMatchController.call(any()))
              .thenAnswer((invocation) async => Response.ok("ok"));

          // given
          // when(() => authorizationMiddleware.call())
          //     .thenReturn(createMiddleware());

          // tested class
          // NOTE: router has to be created only after middleware is stubbed up because the router uses it immediatley
          // final anotherAuthorizationMiddleware = AnotherAuthorizationMiddleware(
          //   onValidateRequest: (request) async {
          //     return Response.ok("ok");
          //   },
          // );
          // final matchesRouter = MatchesRouter(
          //   getMatchController: getMatchController,
          //   authorizationMiddleware: authorizationMiddleware,
          //   anotherAuthorizationMiddleware: anotherAuthorizationMiddleware,
          // );

          // when
          // final router = await matchesRouter.router(realRequest);
          // final responseAsString = await router.readAsString();

          // then

          print("hello");
          // verify(() => authorizationMiddleware.call()).called(1);
          // verify(() => authorizationMiddleware.call()(any())(any())).called(1);
        },
      );

      // test(
      //   "given GetMatchController instance"
      //   "when a request to the endpoint is made"
      //   "then should call the GetMatchController instance",
      //   () async {
      //     // setup
      //     when(() => authorizationMiddleware.call()).thenReturn(
      //       createMiddleware(),
      //     );

      //     // given
      //     when(() => getMatchController.call(any()))
      //         .thenAnswer((invocation) async => Response.ok("ok"));

      //     // when
      //     final requestHandler = Pipeline()
      //         .addMiddleware(authorizationMiddleware.call())
      //         .addHandler(matchesRouter.router.call);

      //     await requestHandler(realRequest);

      //     // then
      //     verify(() => getMatchController.call(any())).called(1);

      //     // cleanup
      //   },
      // );
    });
  });
}

class _MockGetMatchController extends Mock implements GetMatchController {}

class _FakeRequest extends Fake implements Request {}

// TOD
