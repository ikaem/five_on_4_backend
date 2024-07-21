// TODO this needs testing

import 'dart:async';

import 'package:shelf/shelf.dart';

import '../../../../wrappers/local/custom_middleware/custom_middleware_wrapper.dart';
import '../validators/authorize_request_validator.dart';

// import '../../../../wrappers/local/custom_middleware/custom_middleware.dart';

class AuthorizeRequestMiddlewareWrapper implements CustomMiddlewareWrapper {
  // const AuthorizeRequestMiddlewareWrapper({
  //   required FutureOr<Response?> Function(Request request)? requestHandler,
  // }) : _requestHandler = requestHandler;

  // final FutureOr<Response?> Function(Request request)? _requestHandler;

  const AuthorizeRequestMiddlewareWrapper({
    required AuthorizeRequestValidator authorizeRequestValidator,
  }) : _authorizeRequestValidator = authorizeRequestValidator;

  final AuthorizeRequestValidator _authorizeRequestValidator;

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

      return _authorizeRequestValidator.validate(
        validatedRequestHandler: validatedRequestHandler,
      );

      // return validator(validatedRequestHandler: validatedRequestHandler);
    }

    return middleware;

    // final middleware = createMiddleware(
    //   requestHandler: _requestHandler,
    // );
    // return middleware;

    // final middleware = createMiddleware(
    //   // requestHandler: _requestHandler,
    //   requestHandler: _authorizeRequestValidator.validate,
    // );
    // return middleware;
  }
}
