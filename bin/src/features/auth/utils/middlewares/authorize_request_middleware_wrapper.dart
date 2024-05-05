// TODO this needs testing

import 'dart:async';

import 'package:shelf/shelf.dart';

import '../../../../wrappers/local/custom_middleware/custom_middleware_wrapper.dart';

// import '../../../../wrappers/local/custom_middleware/custom_middleware.dart';

class AuthorizeRequestMiddlewareWrapper implements CustomMiddlewareWrapper {
  const AuthorizeRequestMiddlewareWrapper({
    required FutureOr<Response?> Function(Request request)? requestHandler,
  }) : _requestHandler = requestHandler;

  final FutureOr<Response?> Function(Request request)? _requestHandler;

  @override
  Middleware call() {
    final middleware = createMiddleware(
      requestHandler: _requestHandler,
    );
    return middleware;
  }
}
