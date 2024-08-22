import 'package:five_on_4_backend/src/features/auth/utils/middlewares/authorize_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/core/presentation/router/router_wrapper.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/presentation/controllers/store_player_match_participation_controller.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/utils/middlewares/store_player_match_participation_request_middleware_wrapper.dart';
import 'package:five_on_4_backend/src/features/players/presentation/router/players_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

// TODO this should be called wwrapper
class PlayerMatchParticipationRouter implements RouterWrapper {
  PlayerMatchParticipationRouter({
    required StorePlayerMatchParticipationController
        storePlayerMatchParticipationController,
    required AuthorizeRequestMiddlewareWrapper requestAuthorizationMiddleware,
    required StorePlayerMatchParticipationRequestMiddlewareWrapper
        storePlayerMatchParticipationRequestMiddlewareWrapper,
  }) {
    final playerMatchParticipationRouter = Router();

    playerMatchParticipationRouter.post(
      "/store",
      Pipeline()
          .addMiddleware(requestAuthorizationMiddleware())
          .addMiddleware(
              storePlayerMatchParticipationRequestMiddlewareWrapper())
          .addHandler(storePlayerMatchParticipationController.call),
    );

    _router = playerMatchParticipationRouter;
  }
  late final Router _router;

  @override
  final String prefix = "/player-match-participation";
  @override
  Router get router => _router;
}
