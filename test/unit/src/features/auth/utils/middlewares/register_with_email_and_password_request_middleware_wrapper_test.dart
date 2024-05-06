import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/utils/middlewares/register_with_email_and_password_request_middleware_wrapper.dart';

void main() {
  group("$RegisterWithEmailAndPasswordRequestMiddlewareWrapper", () {
    group(".call()", () {
      test(
        "given <pre-condition to the test>"
        "when <behavior we are specifying>"
        "then should <state we expect to happen>",
        () async {
          // setup
          final request = Request("post", Uri.parse("https://example.com/"));

          // given
          // setup request handler - the validator that will handle request in this case
          final requestHandler = _MockRequestHandlerCallbackWrapper();
          when(() => requestHandler.validate(request))
              .thenAnswer((invocation) async {
            // if null is returned, request will propagate to the actual route request handler

            // if Response is returned, request will not propagate to the actual route request handler - instead, the response will be returned
            return Response.ok(
                "Returning from middleware - request does not propagate to the request handler.");
          });

          // setup middleware wrapper
          final middlewareWrapper =
              RegisterWithEmailAndPasswordRequestMiddlewareWrapper(
            requestHandler: requestHandler.validate,
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
          verify(() => requestHandler.validate(request)).called(1);

          // cleanup
        },
      );
    });
  });
}

class _MockRequestHandlerCallbackWrapper extends Mock {
  FutureOr<Response?> validate(Request request);
}