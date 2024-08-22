import 'dart:developer';

import 'package:five_on_4_backend/src/features/core/presentation/router/router_wrapper.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/presentation/router/player_match_participation_router.dart';
import 'package:five_on_4_backend/src/features/players/presentation/router/players_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../auth/presentation/router/auth_router.dart';
import '../../../matches/presentation/router/matches_router.dart';

// TODO this should be tested
class AppRouter implements RouterWrapper {
  AppRouter({
    required AuthRouter authRouter,
    required MatchesRouter matchesRouter,
    required PlayersRouter playersRouter,
    required PlayerMatchParticipationRouter playerMatchParticipationRouter,
  }) : _router = Router() {
    final List<RouterWrapper> routerWrappers = [
      authRouter,
      matchesRouter,
      playersRouter,
      playerMatchParticipationRouter,
    ];

    for (final routerWrapper in routerWrappers) {
      _router.mount(routerWrapper.prefix, routerWrapper.router.call);
    }

    // for (final routerWrapper in routerWrappers) {
    //   // TODO should be done only in dev
    //   log(
    //     '-- server routes at path: ${routerWrapper.prefix}:\n',
    //   );
    //   for (final route in routerWrapper.router.routes) {
    //     log(
    //       '  ${route.method} ${router.prefix}${route.route}\n',
    //     );
    //   }
    // }

    // _router.mount(authRouter.prefix, authRouter.router.call);
    // _router.mount(matchesRouter.prefix, matchesRouter.router.call);
    // _router.mount(playersRouter.prefix, playersRouter.router.call);
    // _router.mount(playerMatchParticipationRouter.prefix,
    //     playerMatchParticipationRouter.router.call);

    // _router.mount("/auth", authRouter.router.call);
    // _router.mount("/matches", matchesRouter.router.call);
    // _router.mount("/players", playersRouter.router.call);
    // _router.mount("/player-match-participation",
    // playerMatchParticipationRouter.router.call);

    // NOTE: print all routes
    // for
    // THIS IS COOL
    final matchesRoutes = matchesRouter.routes;

    print("AppRouter routes:");

    // _router.get("/search", (request) {
    //   return Response.ok("Hello, World!");
    // });

    // _router.get("/", (request) {
    //   return Response.ok("Hello, World!");
    // });

    // // TODO catch all need to be below all other routes
    // // TODO test only
    // _router.get("/<id>", (request) {
    //   return Response.ok("Hello, World!");
    // });
  }

  final Router _router;

  @override
  String get prefix => "";

  @override
  Router get router => _router;
}

// issue to list all routes on app start
// https://github.com/dart-lang/shelf/issues/383
