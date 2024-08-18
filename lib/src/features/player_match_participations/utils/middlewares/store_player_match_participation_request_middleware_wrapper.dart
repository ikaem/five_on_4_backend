import 'dart:async';

import 'package:five_on_4_backend/src/features/player_match_participations/utils/validators/store_player_match_participate_request_validator.dart';
import 'package:five_on_4_backend/src/wrappers/local/custom_middleware/custom_middleware_wrapper.dart';
import 'package:shelf/shelf.dart';

// TODO this whole family of controllers and  should be called StorePlayerMatchParticipationRequestMiddlewareWrapper and so on - and route should be called
// player-match-participation/store - TODO change this eventually

// TODO all middleware wrappers are actually same - so we could possibly have just one?
class StorePlayerMatchParticipationRequestMiddlewareWrapper
    implements CustomMiddlewareWrapper {
  const StorePlayerMatchParticipationRequestMiddlewareWrapper({
    required StorePlayerMatchParticipateRequestValidator
        storePlayerMatchParticipateRequestValidator,
  }) : _storePlayerMatchParticipateRequestValidator =
            storePlayerMatchParticipateRequestValidator;

  final StorePlayerMatchParticipateRequestValidator
      _storePlayerMatchParticipateRequestValidator;

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
      return _storePlayerMatchParticipateRequestValidator.validate(
        validatedRequestHandler: validatedRequestHandler,
      );
    }

    return middleware;
  }
}
