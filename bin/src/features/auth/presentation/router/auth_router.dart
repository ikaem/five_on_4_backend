import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../utils/middlewares/authorize_request_middleware_wrapper.dart';
import '../../utils/middlewares/register_with_email_and_password_request_middleware_wrapper_.dart';
import '../../utils/validators/authorize_request_validator.dart';
import '../controllers/google_login/google_login_controller.dart';
import '../controllers/logout/logout_controller.dart';
import '../controllers/register_with_email_and_password/register_with_email_and_password_controller.dart';

class AuthRouter {
  AuthRouter({
    required GoogleLoginController googleLoginController,
    required RegisterWithEmailAndPasswordController
        registerWithEmailAndPasswordController,
    required LogoutController logoutController,
    required RegisterWithEmailAndPasswordRequestMiddlewareWrapper
        registerWithEmailAndPasswordRequestMiddlewareWrapper,
    required AuthorizeRequestMiddlewareWrapper
        authorizeRequestMiddlewareWrapper,
  }) {
    final authRouter = Router();

    authRouter.post(
      "/google-login",
      googleLoginController.call,
    );

    authRouter.post(
      "/register",
      Pipeline()
          .addMiddleware(
            registerWithEmailAndPasswordRequestMiddlewareWrapper(),
          )
          .addHandler(
            registerWithEmailAndPasswordController.call,
          ),
    );

    authRouter.post(
      "/logout",
      Pipeline()
          .addMiddleware(
            authorizeRequestMiddlewareWrapper(),
          )
          .addHandler(
            logoutController.call,
          ),
    );

    _router = authRouter;
  }

  late final Router _router;
  Router get router => _router;
}

// Future<Response> _googleLoginController(Request request) async {
//   // TODO this will be a controller one day
//   return Response.ok("Google login");
// }
