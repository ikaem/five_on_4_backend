import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf/src/middleware.dart';

import '../../../../wrappers/local/custom_middleware/custom_middleware_wrapper.dart';
import '../validators/get_player_matches_overview_request_validator.dart';

// TODO all of this could be just one class, and always just pass it the validator

class GetPlayerMatchesOverviewRequestMiddlewareWrapper
    implements CustomMiddlewareWrapper {
  const GetPlayerMatchesOverviewRequestMiddlewareWrapper({
    required GetPlayerMatchesOverviewRequestValidator
        getPlayerMatchesOverviewRequestValidator,
  }) : _getPlayerMatchesOverviewRequestValidator =
            getPlayerMatchesOverviewRequestValidator;

  final GetPlayerMatchesOverviewRequestValidator
      _getPlayerMatchesOverviewRequestValidator;

  @override
  Middleware call() {
    Future<Response> Function(Request) middleware(
      FutureOr<Response> Function(Request) innerHandler,
    ) {
      // define the validatedRequestHandler
      Future<Response> validatedRequestHandler(Request validatedRequest) async {
        return Future.sync(() => innerHandler(validatedRequest))
            .then((Response response) {
          return response;
        });
      }

      // call validator and pass it the validatedRequestHandler
      return _getPlayerMatchesOverviewRequestValidator.validate(
        validatedRequestHandler: validatedRequestHandler,
      );
    }

    return middleware;
  }
}
