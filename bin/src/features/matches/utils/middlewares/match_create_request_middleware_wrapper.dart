import 'dart:async';

import 'package:shelf/shelf.dart';

import '../../../../wrappers/local/custom_middleware/custom_middleware_wrapper.dart';
import '../validators/match_create_request_validator.dart';

class MatchCreateRequestMiddlewareWrapper implements CustomMiddlewareWrapper {
  // const MatchCreateRequestMiddlewareWrapper({
  //   required FutureOr<Response?> Function(Request request)? requestHandler,
  // }) : _requestHandler = requestHandler;

  // final FutureOr<Response?> Function(Request request)? _requestHandler;

  const MatchCreateRequestMiddlewareWrapper({
    required MatchCreateRequestValidator matchCreateRequestValidator,
  }) : _matchCreateRequestValidator = matchCreateRequestValidator;

  final MatchCreateRequestValidator _matchCreateRequestValidator;

  @override
  Middleware call() {
    final middleware = createMiddleware(
      // requestHandler: _requestHandler,
      requestHandler: _matchCreateRequestValidator.validate,
    );
    return middleware;
  }
}
