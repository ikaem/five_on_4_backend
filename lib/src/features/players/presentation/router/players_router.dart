import 'package:five_on_4_backend/src/features/auth/utils/middlewares/authorize_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/matches/presentation/controllers/search_matches_controller.dart';
import 'package:five_on_4_backend/src/features/players/utils/middlewares/search_players_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/wrappers/local/custom_middleware/custom_middleware_wrapper.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class PlayersRouter {
  PlayersRouter({
    // controllers
    required SearchMatchesController searchMatchesController,

    // middleware wrappers
    required SearchPlayersRequestMiddlewareWrapper
        searchPlayersRequestMiddlewareWrapper,
    required AuthorizeRequestMiddlewareWrapper requestAuthorizationMiddleware,
  }) {
    final playersRouter = Router();

    playersRouter.get(
      "/search",
      Pipeline()
          .addMiddleware(requestAuthorizationMiddleware())
          .addMiddleware(searchPlayersRequestMiddlewareWrapper())
          .addHandler(searchMatchesController.call),
    );

    _router = playersRouter;
  }

  late final Router _router;
  Router get router => _router;
}
