import 'dart:async';

import 'package:five_on_4_backend/src/features/matches/presentation/controllers/search_matches_controller.dart';
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
    required SearchMatchesController searchMatchesController,
    // TODO this should be called requestAuthorizationRequestMiddleware
    // TODO why not use actual type here - why this interface? or
    required CustomMiddlewareWrapper requestAuthorizationMiddleware,
    required CustomMiddlewareWrapper matchCreateRequestMiddleware,
    required CustomMiddlewareWrapper getPlayerMatchesOverviewRequestMiddleware,
    required CustomMiddlewareWrapper searchMatchesRequestMiddlewareWrapper,
  }) {
    final matchesRouter = Router();

    matchesRouter.post(
      "/search",
      Pipeline()
          .addMiddleware(requestAuthorizationMiddleware())
          .addMiddleware(searchMatchesRequestMiddlewareWrapper())
          .addHandler(searchMatchesController.call),
    );

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
