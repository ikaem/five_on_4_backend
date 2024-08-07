import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/auth/utils/middlewares/authorize_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/auth/utils/validators/authorize_request_validator.dart';
// TODO this can go away

void main() {
  group("$AuthorizeRequestMiddlewareWrapper", () {
    group(".call()", () {
      test(
        "given a requestHandler "
        "when request trigges the middleware"
        "then should call provided requestHandler",
        () async {
          // setup
          final request = Request("get", Uri.parse("https://example.com/1"));

          // given
          final authorizeRequestValidator = _MockAuthorizeRequestValidator();
          when(() => authorizeRequestValidator.validate(
              validatedRequestHandler:
                  any(named: "validatedRequestHandler"))).thenReturn(
            (request) {
              return (Request request) async {
                return Response.ok("ok");
              }(request);
            },
          );

          final middlewareWrapper = AuthorizeRequestMiddlewareWrapper(
            authorizeRequestValidator: authorizeRequestValidator,
          );

          // get middleware from the wrapper
          final middleware = middlewareWrapper.call();
          // get middleware request handler
          final setupRequestHandler = middleware((request) async {
            return Response.ok(
                "Returning from the router-specific handler - request propagates to the request handler.");
          });

          // when
          // send request to the middleware request handler
          await setupRequestHandler(request);

          // then
          // verify that request handler was called
          verify(() => authorizeRequestValidator.validate(
              validatedRequestHandler:
                  any(named: "validatedRequestHandler"))).called(1);

          // given
          // setup request handler - the validator that will handle request in this case
          // final requestHandler = _MockRequestHandlerCallbackWrapper();
          // when(() => requestHandler.validate(request)).thenAnswer(
          //   (_) async {
          //     // if return null, request will propagate to the request handler
          //     // if return Response, request will not propagate to the router request handler
          //     return Response.ok(
          //         "Returning from middleware - request does not propagate to the request handler.");
          //   },
          // );

          // // setup middleware
          // final middlewareWrapper = AuthorizeRequestMiddlewareWrapper(
          //   requestHandler: requestHandler.validate,
          // );
          // // get middleware from the wrapper
          // final middleware = middlewareWrapper.call();
          // // get middlewrare request handler
          // final setupRequestHandler = middleware((request) async {
          //   return Response.ok(
          //       "Returning from the router-specific handler - request propagates to the request handler.");
          // });

          // // when
          // // send request to the middleware request handler
          // await setupRequestHandler(request);

          // // then
          // // verify that request handler was called
          // verify(() => requestHandler.validate(request)).called(1);

          // cleanup
        },
      );
    });
  });
}

// class _MockRequestHandlerCallbackWrapper extends Mock {
//   FutureOr<Response?> validate(Request request);
// }

class _MockAuthorizeRequestValidator extends Mock
    implements AuthorizeRequestValidator {}
