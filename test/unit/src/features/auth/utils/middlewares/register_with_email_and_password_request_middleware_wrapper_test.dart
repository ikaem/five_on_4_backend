import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/utils/middlewares/register_with_email_and_password_request_middleware_wrapper.dart';
import '../../../../../../../bin/src/features/auth/utils/validators/register_with_email_and_password_request_validator.dart';

void main() {
  group("$RegisterWithEmailAndPasswordRequestMiddlewareWrapper", () {
    group(".call()", () {
      test(
        "given RegisterWithEmailAndPasswordRequestValidator"
        "when .call() is called"
        "then should return response from the validator",
        () async {
          // setup
          final request = Request("post", Uri.parse("https://example.com/"));
          final expectedResponse = Response.ok("ok");

          final registerRequestValidator =
              _MockRegiterWithEmailAndPasswordRequestValidator();
          // when(() => registerRequestValidator.validate(
          //     validatedRequestHandler:
          //         any(named: "validatedRequestHandler"))).thenReturn(
          //     (request) {
          //       return (Request request) async => expectedResponse}(request);
          //     });

          when(() => registerRequestValidator.validate(
              validatedRequestHandler:
                  any(named: "validatedRequestHandler"))).thenReturn((request) {
            return (Request request) async {
              return expectedResponse;
            }(request);
          });

          // given
          // setup request handler - the validator that will handle request in this case
          // final requestHandler = _MockRequestHandlerCallbackWrapper();
          // when(() => requestHandler.validate(request))
          //     .thenAnswer((invocation) async {
          //   // if null is returned, request will propagate to the actual route request handler

          //   // if Response is returned, request will not propagate to the actual route request handler - instead, the response will be returned
          //   return Response.ok(
          //       "Returning from middleware - request does not propagate to the request handler.");
          // });

          // // setup middleware wrapper
          final middlewareWrapper =
              RegisterWithEmailAndPasswordRequestMiddlewareWrapper(
            registerWithEmailAndPasswordRequestValidator:
                registerRequestValidator,
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
          final response = await setupRequestHandler(request);

          // then
          expect(response, equals(expectedResponse));
          // verify that request handler was called
          // verify(() => requestHandler.validate(request)).called(1);

          // cleanup
        },
      );
    });
  });
}

class _MockRegiterWithEmailAndPasswordRequestValidator extends Mock
    implements RegisterWithEmailAndPasswordRequestValidator {}

// class _MockRequestHandlerCallbackWrapper extends Mock {
//   FutureOr<Response?> validate(Request request);
// }
