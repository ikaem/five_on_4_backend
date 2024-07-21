import 'dart:async';

import 'package:five_on_4_backend/src/features/matches/utils/validators/search_matches_request_validator.dart';
import 'package:five_on_4_backend/src/wrappers/local/custom_middleware/custom_middleware_wrapper.dart';
import 'package:shelf/shelf.dart';

class SearchMatchesRequestMiddlewareWrapper implements CustomMiddlewareWrapper {
  const SearchMatchesRequestMiddlewareWrapper({
    required SearchMatchesRequestValidator searchMatchesRequestValidator,
  }) : _searchMatchesRequestValidator = searchMatchesRequestValidator;

  final SearchMatchesRequestValidator _searchMatchesRequestValidator;

  @override
  Middleware call() {
    return _middleware;
  }

  // TODO this can maybe be extended - could live in the parent
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

    return _searchMatchesRequestValidator.validate(
      validatedRequestHandler: validatedRequestHandler,
    );
  }
}
