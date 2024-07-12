import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf/src/middleware.dart';

import '../../../../wrappers/local/custom_middleware/custom_middleware_wrapper.dart';
import '../validators/authenticate_with_google_request_validator.dart';

class AuthenticateWithGoogleRequestMiddlewareWrapper
    implements CustomMiddlewareWrapper {
  const AuthenticateWithGoogleRequestMiddlewareWrapper({
    required AuthenticateWithGoogleRequestValidator
        authenticateWithGoogleRequestValidator,
  }) : _authenticateWithGoogleRequestValidator =
            authenticateWithGoogleRequestValidator;

  final AuthenticateWithGoogleRequestValidator
      _authenticateWithGoogleRequestValidator;
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

      return _authenticateWithGoogleRequestValidator.validate(
        validatedRequestHandler: validatedRequestHandler,
      );

      // return validator(validatedRequestHandler: validatedRequestHandler);
    }

    return middleware;
  }
}
