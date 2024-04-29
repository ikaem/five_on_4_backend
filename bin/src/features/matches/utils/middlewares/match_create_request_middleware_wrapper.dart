import 'dart:async';

import 'package:shelf/shelf.dart';

import '../../../../wrappers/local/custom_middleware/custom_middleware_wrapper.dart';

class MatchCreateRequestMiddlewareWrapper implements CustomMiddlewareWrapper {
  const MatchCreateRequestMiddlewareWrapper({
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