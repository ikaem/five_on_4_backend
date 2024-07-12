import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/core/utils/validators/request_validator.dart';
import 'package:five_on_4_backend/src/features/matches/utils/middlewares/match_create_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/matches/utils/validators/match_create_request_validator.dart';

void main() {
  group("$MatchCreateRequestMiddlewareWrapper", () {
    group(".call()", () {
      test(
        "given MatchCreateRequestValidator instance"
        "when request is passed to the middleware"
        "then should call the provided MatchCreateRequestValidator.validate()",
        () async {
          // setup
          final request = Request("post", Uri.parse("https://example.com/"));

          // given
          final matchCreateRequestHandler = _MockMatchCreateRequestValidator();
          when(() => matchCreateRequestHandler.validate(
                validatedRequestHandler: any(named: "validatedRequestHandler"),
              )).thenReturn((request) {
            return (Request request) async {
              return Response.ok("ok");
            }(request);
          });

          final middlewareWrapper = MatchCreateRequestMiddlewareWrapper(
            matchCreateRequestValidator: matchCreateRequestHandler,
          );

          // get middleware from the wrapper
          final middleware = middlewareWrapper.call();
          // get middleware request handler
          final setupRequestHandler = middleware((request) async {
            // request will not propagate to this handler
            return Response.ok(
                "Returning from the router-specific handler - request propagates to the request handler.");
          });

          // when
          // send request to the middleware request handler
          await setupRequestHandler(request);

          // then
          // verify that request handler was called
          verify(() => matchCreateRequestHandler.validate(
                validatedRequestHandler: any(named: "validatedRequestHandler"),
              )).called(1);

          // given

          // // setup
          // final request = Request("post", Uri.parse("https://example.com/"));

          // // given
          // // setup request handler - the validator that will handle request in this case
          // final requestHandler = _MockRequestHandlerCallbackWrapper();
          // when(() => requestHandler.validate(request))
          //     .thenAnswer((invocation) async {
          //   // if null is returned, request will propagate to the actual route request handler

          //   // if Response is returned, request will not propagate to the actual route request handler - instead, the response will be returned
          //   return Response.ok(
          //       "Returning from middleware - request does not propagate to the request handler.");
          // });

          // // setup middleware wrapper
          // final middlewareWrapper = MatchCreateRequestMiddlewareWrapper(
          //   requestHandler: requestHandler.validate,
          // );

          // // get middleware from the wrapper
          // final middleware = middlewareWrapper.call();
          // // get middleware request handler
          // final setupRequestHandler = middleware((request) async {
          //   // request will not propagate to this handler
          //   return Response.ok(
          //       "Returning from the router-specific handler - request propagates to the request handler.");
          // });

          // // when
          // // send request to the middleware request handler
          // await setupRequestHandler(request);

          // // then
          // // verify that request handler was called
          // verify(() => requestHandler.validate(request)).called(1);

          // // cleanup
        },
      );
    });
  });
}

// class _MockRequestHandlerCallbackWrapper extends Mock {
//   FutureOr<Response?> validate(Request request);
// }

class _MockMatchCreateRequestValidator extends Mock
    implements MatchCreateRequestValidator {}
