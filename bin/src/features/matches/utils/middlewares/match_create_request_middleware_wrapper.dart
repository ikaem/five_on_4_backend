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
    // TODO abstract this and use in all middleware wrappers
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

      return _matchCreateRequestValidator.validate(
        validatedRequestHandler: validatedRequestHandler,
      );

      // return validator(validatedRequestHandler: validatedRequestHandler);
    }

    return middleware;

    // TODO this is old
    // final middleware = createMiddleware(
    //   // requestHandler: _requestHandler,
    //   requestHandler: _matchCreateRequestValidator.validate,
    // );
    // return middleware;
  }
}
