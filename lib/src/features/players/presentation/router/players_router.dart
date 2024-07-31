import 'package:five_on_4_backend/src/features/matches/presentation/controllers/search_matches_controller.dart';

class PlayersRouter {
  PlayersRouter({
// controllers
    required SearchMatchesController searchMatchesController,

// middleware wrappers
    required Requestau requestAuthorizationMiddleware,
  });
}
