import 'package:five_on_4_backend/src/features/player_match_participations/presentation/router/player_match_participation_router.dart';
import 'package:five_on_4_backend/src/features/players/presentation/router/players_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../auth/presentation/router/auth_router.dart';
import '../../../matches/presentation/router/matches_router.dart';

// TODO this should be tested
class AppRouter {
  AppRouter({
    required AuthRouter authRouter,
    required MatchesRouter matchesRouter,
    required PlayersRouter playersRouter,
    required PlayerMatchParticipationRouter playerMatchParticipationRouter,
  }) : _router = Router() {
    _router.mount("/auth", authRouter.router.call);
    _router.mount("/matches", matchesRouter.router.call);
    _router.mount("/players", playersRouter.router.call);
    _router.mount("/player-match-participation",
        playerMatchParticipationRouter.router.call);

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
  Router get router => _router;
}

// issue to list all routes on app start
// https://github.com/dart-lang/shelf/issues/383
