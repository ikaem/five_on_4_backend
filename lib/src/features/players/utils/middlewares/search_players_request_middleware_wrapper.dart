import 'dart:async';

import 'package:five_on_4_backend/src/features/players/utils/validators/search_players_request_validator.dart';
import 'package:five_on_4_backend/src/wrappers/local/custom_middleware/custom_middleware_wrapper.dart';
import 'package:shelf/shelf.dart';

class SearchPlayersRequestMiddlewareWrapper implements CustomMiddlewareWrapper {
  const SearchPlayersRequestMiddlewareWrapper({
    required SearchPlayersRequestValidator searchPlayersRequestValidator,
  }) : _searchPlayersRequestValidator = searchPlayersRequestValidator;

  final SearchPlayersRequestValidator _searchPlayersRequestValidator;

  @override
  Middleware call() {
    return _middleware;
  }

  // TODO this can maybe be extended - could live in the parent, or maybe a mixin - we will see
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

    return _searchPlayersRequestValidator.validate(
      validatedRequestHandler: validatedRequestHandler,
    );
  }
}
