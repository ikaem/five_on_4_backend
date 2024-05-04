import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/utils/middlewares/logout_request_middleware_wrapper.dart';

void main() {
  group(
    "$LogoutRequestMiddlewareWrapper",
    () {
      group(".call()", () {
        test(
          "given a requestHandler"
          "when request trigges the middleware"
          "then should call provided requestHandler",
          () async {
            // setup
            final request = Request("post", Uri.parse("https://example.com/"));

            // given
            // setup request handler - the validator that will handle request in this case
            final requestHandler = _MockRequestHandlerCallbackWrapper();
            when(() => requestHandler.validate(request)).thenAnswer(
              (_) async {
                // if return null, request will propagate to the actual request handler (router)
                // if return Response, request will not propagate to the router request handler
                return Response.ok(
                    "Returning from middleware - request does not propagate to the request handler.");
              },
            );

            // setup middleware
            final middlewareWrapper = LogoutRequestMiddlewareWrapper(
              requestHandler: requestHandler.validate,
            );
            // get middleware from the wrapper
            final middleware = middlewareWrapper.call();
            // get middlewrare request handler - not the validator itself
            final setupRequestHandler = middleware((request) async {
              // this will not be returned because the request will not propagate to this handler because validator will return a response
              return Response.ok(
                  "Returning from the router-specific handler - request propagates to the request handler.");
            });

            // when
            // send request to the middleware request handler
            await setupRequestHandler(request);

            // then
            // verify that request handler (validator) was called
            verify(() => requestHandler.validate(request)).called(1);

            // cleanup
          },
        );
      });
    },
  );
}

class _MockRequestHandlerCallbackWrapper extends Mock {
  FutureOr<Response?> validate(Request request);
}
