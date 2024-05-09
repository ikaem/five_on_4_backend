import 'dart:async';

import 'package:shelf/shelf.dart';

import '../../../../wrappers/local/custom_middleware/custom_middleware_wrapper.dart';
import '../validators/logout_request_validator.dart';

class LogoutRequestMiddlewareWrapper implements CustomMiddlewareWrapper {
  const LogoutRequestMiddlewareWrapper({
    // required FutureOr<Response?> Function(Request request)? requestHandler,
    required LogoutRequestValidator logoutRequestValidator,
  }) : _logoutRequestValidator = logoutRequestValidator;

  // final FutureOr<Response?> Function(Request request)? _requestHandler;
  final LogoutRequestValidator _logoutRequestValidator;

  @override
  Middleware call() {
    Future<Response> Function(Request) middleware(
      FutureOr<Response> Function(Request) innerHandler,
    ) {
      Future<Response> validatedRequestHandler(Request validatedRequest) async {
        return Future.sync(() => innerHandler(validatedRequest))
            .then((Response response) {
          return response;
        });
      }

      // return (Request request) {
      //   return Future.sync(() => innerHandler(request)).then((response) {
      //     return response;
      //   });
      // };

      return _logoutRequestValidator.validate(
        validatedRequestHandler: validatedRequestHandler,
      );

      // return validator(validatedRequestHandler: validatedRequestHandler);
    }

    return middleware;

    // final middleware = createMiddleware(
    //   requestHandler: _requestHandler,
    // );
    // return middleware;
  }
}
