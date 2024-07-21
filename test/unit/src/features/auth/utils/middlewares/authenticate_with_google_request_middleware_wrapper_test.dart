import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/auth/utils/middlewares/authenticate_with_google_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/auth/utils/validators/authenticate_with_google_request_validator.dart';

void main() {
  group("$AuthenticateWithGoogleRequestMiddlewareWrapper", () {
    group(".call()", () {
      test(
        "given AuthenticateWithGoogleRequestValidator instance"
        "when request is passed to the middleware"
        "then should call the provided AuthenticateWithGoogleRequestValidator.validate()",
        () async {
          // setup
          final request = Request(
            "post",
            Uri.parse("https://example.com/"),
          );

          // given
          final authenticateWithGoogleRequestValidator =
              _MockAuthenticateWithGoogleRequestValidator();
          when(() => authenticateWithGoogleRequestValidator.validate(
                validatedRequestHandler: any(named: "validatedRequestHandler"),
              )).thenReturn(
            (request) {
              return (Request request) async {
                return Response.ok("ok");
              }(request);
            },
          );

          final middlewareWrapper =
              AuthenticateWithGoogleRequestMiddlewareWrapper(
            authenticateWithGoogleRequestValidator:
                authenticateWithGoogleRequestValidator,
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
          // verify that request handler (validator) was called
          verify(() => authenticateWithGoogleRequestValidator.validate(
                validatedRequestHandler: any(named: "validatedRequestHandler"),
              )).called(1);

          // cleanup
        },
      );
    });
  });
}

class _MockAuthenticateWithGoogleRequestValidator extends Mock
    implements AuthenticateWithGoogleRequestValidator {}
