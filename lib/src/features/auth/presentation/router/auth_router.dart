import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../utils/middlewares/authenticate_with_google_request_middleware_wrapper.dart';
import '../../utils/middlewares/authorize_request_middleware_wrapper.dart';
import '../../utils/middlewares/login_request_middleware_wrapper.dart';
import '../../utils/middlewares/register_with_email_and_password_request_middleware_wrapper.dart';
import '../controllers/get_auth/get_auth_controller.dart';
import '../controllers/google_login/google_login_controller.dart';
import '../controllers/login/login_controller.dart';
import '../controllers/logout/logout_controller.dart';
import '../controllers/refresh_token/refresh_token_controller.dart';
import '../controllers/register_with_email_and_password/register_with_email_and_password_controller.dart';

class AuthRouter {
  AuthRouter({
    // controllers
    required GoogleLoginController googleLoginController,
    required RegisterWithEmailAndPasswordController
        registerWithEmailAndPasswordController,
    required LogoutController logoutController,
    required LoginController loginController,
    // middlewares
    required RegisterWithEmailAndPasswordRequestMiddlewareWrapper
        registerWithEmailAndPasswordRequestMiddlewareWrapper,
    required AuthorizeRequestMiddlewareWrapper
        authorizeRequestMiddlewareWrapper,
    required LoginRequestMiddlewareWrapper loginRequestMiddlewareWrapper,
    required AuthenticateWithGoogleRequestMiddlewareWrapper
        authenticateWithGoogleRequestMiddlewareWrapper,
    required GetAuthController getAuthController,
    required RefreshTokenController refreshTokenController,
  }) {
    final authRouter = Router();

    authRouter.post(
      "/refresh-token",
      Pipeline().addHandler(
        refreshTokenController.call,
      ),
    );

    authRouter.post(
        "/get-auth",
        Pipeline().addHandler(
          getAuthController.call,
        ));

    authRouter.post(
      "/login",
      Pipeline()
          .addMiddleware(
            loginRequestMiddlewareWrapper(),
          )
          .addHandler(
            loginController.call,
          ),
    );

    authRouter.post(
      "/auth-google",
      Pipeline()
          .addMiddleware(
            authenticateWithGoogleRequestMiddlewareWrapper(),
          )
          .addHandler(
            googleLoginController.call,
          ),
      // googleLoginController.call,
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
