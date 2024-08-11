import 'package:five_on_4_backend/src/features/auth/utils/middlewares/authorize_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/players/presentation/controllers/get_player_controller.dart';
import 'package:five_on_4_backend/src/features/players/presentation/controllers/search_players_controller.dart';
import 'package:five_on_4_backend/src/features/players/utils/middlewares/get_player_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/players/utils/middlewares/search_players_request_middleware_wrapper.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class PlayersRouter {
  PlayersRouter({
    // controllers
    required SearchPlayersController searchPlayersController,
    required GetPlayerController getPlayerController,

    // middleware wrappers
    required SearchPlayersRequestMiddlewareWrapper
        searchPlayersRequestMiddlewareWrapper,
    required AuthorizeRequestMiddlewareWrapper requestAuthorizationMiddleware,
    required GetPlayerRequestMiddlewareWrapper
        getPlayerRequestMiddlewareWrapper,
  }) {
    final playersRouter = Router();

    playersRouter.get(
      "/search",
      // searchPlayersController.call,
      Pipeline()
          .addMiddleware(requestAuthorizationMiddleware())
          .addMiddleware(searchPlayersRequestMiddlewareWrapper())
          .addHandler(searchPlayersController.call),
    );
    playersRouter.get(
      "/<id>",
      // getPlayerController.call,
      Pipeline()
          .addMiddleware(requestAuthorizationMiddleware())
          .addMiddleware(getPlayerRequestMiddlewareWrapper())
          .addHandler(getPlayerController.call),
      // Pipeline().addHandler((request) =>
      //     getPlayerController.call(request, request.params["id"]!)),
    );
    // TODO test for now - no middlewares

    _router = playersRouter;
  }

  late final Router _router;
  Router get router => _router;
}
