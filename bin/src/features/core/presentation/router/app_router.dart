import 'package:shelf_router/shelf_router.dart';

import '../../../auth/presentation/router/auth_router.dart';
import '../../../matches/presentation/router/matches_router.dart';

class AppRouter {
  AppRouter({
    required AuthRouter authRouter,
    required MatchesRouter matchesRouter,
  }) : _router = Router() {
    _router.mount("/auth", authRouter.router.call);
    _router.mount("/matches", matchesRouter.router.call);
  }

  final Router _router;
  Router get router => _router;
}
