import 'package:five_on_4_backend/src/features/players/presentation/router/players_router.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../auth/presentation/router/auth_router.dart';
import '../../../matches/presentation/router/matches_router.dart';

// TODO this should be tested
class AppRouter {
  AppRouter({
    required AuthRouter authRouter,
    required MatchesRouter matchesRouter,
    required PlayersRouter playersRouter,
  }) : _router = Router() {
    _router.mount("/auth", authRouter.router.call);
    _router.mount("/matches", matchesRouter.router.call);
    _router.mount("/players", playersRouter.router.call);
  }

  final Router _router;
  Router get router => _router;
}
