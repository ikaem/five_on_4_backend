import 'dart:async';

import 'package:five_on_4_backend/src/features/players/utils/validators/get_player_request_validator.dart';
import 'package:five_on_4_backend/src/wrappers/local/custom_middleware/custom_middleware_wrapper.dart';
import 'package:shelf/shelf.dart';

class GetPlayerRequestMiddlewareWrapper implements CustomMiddlewareWrapper {
  const GetPlayerRequestMiddlewareWrapper({
    required GetPlayerRequestValidator getPlayerRequestValidator,
  }) : _getPlayerRequestValidator = getPlayerRequestValidator;

  final GetPlayerRequestValidator _getPlayerRequestValidator;

  @override
  Middleware call() {
    return _middleware;
  }

  Future<Response> Function(Request) _middleware(
    FutureOr<Response> Function(Request) innerHandler,
  ) {
    // define another innher function in here - so it is easier to test it later - this could possibly be define outside too
    Future<Response> validatedRequestHandler(Request validatedRequest) async {
      return Future.sync(() => innerHandler(validatedRequest))
          .then((Response response) {
        return response;
      });
    }

    return _getPlayerRequestValidator.validate(
      validatedRequestHandler: validatedRequestHandler,
    );
  }
}
