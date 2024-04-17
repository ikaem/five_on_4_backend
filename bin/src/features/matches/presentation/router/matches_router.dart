import 'package:shelf_router/shelf_router.dart';
import '../controllers/get_match_controller.dart';

class MatchesRouter {
  MatchesRouter({
    required GetMatchController getMatchController,
  }) {
    final matchesRouter = Router();

    matchesRouter.get("/<id>", getMatchController.call);

    _router = matchesRouter;
  }

  late final Router _router;
  Router get router => _router;
}
