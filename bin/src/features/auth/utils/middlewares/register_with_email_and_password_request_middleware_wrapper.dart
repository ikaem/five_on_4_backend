import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf/src/middleware.dart';

import '../../../../wrappers/local/custom_middleware/custom_middleware_wrapper.dart';
import '../validators/register_with_email_and_password_request_validator.dart';

class RegisterWithEmailAndPasswordRequestMiddlewareWrapper
    implements CustomMiddlewareWrapper {
  // const RegisterWithEmailAndPasswordRequestMiddlewareWrapper({
  //   required FutureOr<Response?> Function(Request request)? requestHandler,
  // }) : _requestHandler = requestHandler;

  // final FutureOr<Response?> Function(Request request)? _requestHandler;

  const RegisterWithEmailAndPasswordRequestMiddlewareWrapper({
    required RegisterWithEmailAndPasswordRequestValidator
        registerWithEmailAndPasswordRequestValidator,
  }) : _registerWithEmailAndPasswordRequestValidator =
            registerWithEmailAndPasswordRequestValidator;

  final RegisterWithEmailAndPasswordRequestValidator
      _registerWithEmailAndPasswordRequestValidator;

  @override
  Middleware call() {
    // TODO this is same everywhere - so there has to be a way to abstract this
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

      // TODO only this is different
      return _registerWithEmailAndPasswordRequestValidator.validate(
        validatedRequestHandler: validatedRequestHandler,
      );

      // return validator(validatedRequestHandler: validatedRequestHandler);
    }

    return middleware;

    // final middleware = createMiddleware(
    //   // requestHandler: _requestHandler,
    //   // requestHandler: _registerWithEmailAndPasswordRequestValidator.validate,

    // );
    // return middleware;
  }
}
