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
    final middleware = createMiddleware(
      // requestHandler: _requestHandler,
      requestHandler: _registerWithEmailAndPasswordRequestValidator.validate,
    );
    return middleware;
  }
}
