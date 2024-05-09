import 'dart:async';
import 'dart:math';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/utils/middlewares/login_request_middleware_wrapper.dart';
import '../../../../../../../bin/src/features/auth/utils/validators/login_request_validator.dart';

void main() {
  // setUpAll(() {
  //   registerFallbackValue(_FakeRequest());
  // });

  group("$LoginRequestMiddlewareWrapper", () {
    group(".call()", () {
      test(
        "given LoginRequestValidator instance"
        "when request is passed to the middleware"
        "then should call the provided LoginRequestValidator.validate()",
        () async {
          // setup
          final request = Request("post", Uri.parse("https://example.com/"));

          // given
          final loginRequestValidator = _MockLoginRequestValidator();
          when(() => loginRequestValidator.validate(
              validatedRequestHandler:
                  any(named: "validatedRequestHandler"))).thenReturn(
              // (request) => loginRequestHandlerCallback.call(request));
              (request) {
            // return loginRequestHandlerCallback.call(request);
            return (Request request) async {
              return Response.ok("ok");
            }(request);
          });

          final middlewareWrapper = LoginRequestMiddlewareWrapper(
            loginRequestValidator: loginRequestValidator,
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
          verify(() => loginRequestValidator.validate(
              validatedRequestHandler:
                  any(named: "validatedRequestHandler"))).called(1);

          // cleanup
        },
      );
    });
  });
}

// class _MockRequestHandlerCallbackWrapper extends Mock {
//   FutureOr<Response?> validate(Request request);
// }

class _MockLoginRequestValidator extends Mock
    implements LoginRequestValidator {}

// class _MockLoginRequestValidatorCallback extends Mock {
//   Future<Response> call(Request request);
// }

// class _FakeRequest extends Fake implements Request {}
