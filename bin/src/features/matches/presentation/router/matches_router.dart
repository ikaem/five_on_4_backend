import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../../wrappers/local/custom_middleware/custom_middleware_wrapper.dart';
import '../controllers/create_match_controller.dart';
import '../controllers/get_match_controller.dart';
import '../controllers/get_player_matches_overview_controller.dart';

class MatchesRouter {
  MatchesRouter({
    required GetMatchController getMatchController,
    required CreateMatchController createMatchController,
    required GetPlayerMatchesOverviewController
        getPlayerMatchesOverviewController,
    // TODO this should be called requestAuthorizationRequestMiddleware
    required CustomMiddlewareWrapper requestAuthorizationMiddleware,
    required CustomMiddlewareWrapper matchCreateRequestMiddleware,
    required CustomMiddlewareWrapper getPlayerMatchesOverviewRequestMiddleware,
  }) {
    final matchesRouter = Router();

    matchesRouter.get(
      "/player-matches-overview",
      Pipeline()
          .addMiddleware(requestAuthorizationMiddleware())
          .addMiddleware(getPlayerMatchesOverviewRequestMiddleware())
          .addHandler(getPlayerMatchesOverviewController.call),
    );

    matchesRouter.post(
      "/",
      Pipeline()
          .addMiddleware(requestAuthorizationMiddleware())
          .addMiddleware(matchCreateRequestMiddleware())
          .addHandler(createMatchController.call),
    );

    matchesRouter.get(
      "/<id>",
      Pipeline()
          .addMiddleware(requestAuthorizationMiddleware())
          .addHandler(getMatchController.call),
    );

    _router = matchesRouter;
  }

  late final Router _router;
  Router get router => _router;
}

Middleware someRandomMiddleware() => (innerHandler) {
      return (request) {
        // TODO here we can validate? and return responses
        return Future.sync(() {
          return innerHandler(request);
        }).then((response) {
          print("request here: $request");
          print("inner handler here: $innerHandler");
          return response;
        });
      };
    };
