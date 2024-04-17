import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../controllers/google_login/google_login_controller.dart';

class AuthRouter {
  AuthRouter({
    required GoogleLoginController googleLoginController,
  }) {
    final authRouter = Router();

    authRouter.post(
      "/google-login",
      googleLoginController.call,
      // _googleLoginController,
    );

    _router = authRouter;
  }
  // : _router = Router()
  //     ..post(
  //       "/google-login",
  //       _googleLoginController,
  //     );

  late final Router _router;
  Router get router => _router;
}

// Future<Response> _googleLoginController(Request request) async {
//   // TODO this will be a controller one day
//   return Response.ok("Google login");
// }
