import 'dart:async';
import 'dart:mirrors';

import 'package:five_on_4_backend/src/features/core/presentation/router/router_wrapper.dart';
import 'package:five_on_4_backend/src/features/matches/presentation/controllers/search_matches_controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../../wrappers/local/custom_middleware/custom_middleware_wrapper.dart';
import '../controllers/create_match_controller.dart';
import '../controllers/get_match_controller.dart';
import '../controllers/get_player_matches_overview_controller.dart';

class MatchesRouter implements RouterWrapper {
  MatchesRouter({
    required GetMatchController getMatchController,
    required CreateMatchController createMatchController,
    required GetPlayerMatchesOverviewController
        getPlayerMatchesOverviewController,
    required SearchMatchesController searchMatchesController,
    // TODO this should be called requestAuthorizationRequestMiddleware
    // TODO why not use actual type here - why this interface? or
    // TODO make a ticket to use actual types
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
    // TODO as per this
    final mirror = reflect(matchesRouter);
    final routes = mirror.invoke(#post, [
      "/ja",
      (Request request) {
        return Response.ok("ja");
      }
    ]);

    matchesRouter.post(
      "/",
      Pipeline()
          .addMiddleware(requestAuthorizationMiddleware())
          .addMiddleware(matchCreateRequestMiddleware())
          .addHandler(createMatchController.call),
    );
    // _routes.add("/");
    // matchesRouter

// dynamic routes have to be last, so as not to catch other routes requests
    matchesRouter.get(
      "/<id>",
      Pipeline()
          .addMiddleware(requestAuthorizationMiddleware())
          .addHandler(getMatchController.call),
    );

    _router = matchesRouter;
  }

  late final Router _router;

  // TODO test only
  // final List<String> _routes = [];
  // List<String> get routes => _routes;

  @override
  final String prefix = "/matches";
  @override
  Router get router => _router;

  dynamic get mirror => reflect(router);

  dynamic get routes => mirror.getField(#hashCode).reflectee;
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
