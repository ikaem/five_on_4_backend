import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AuthRouter {
  AuthRouter()
      : _router = Router()
          ..post(
            "/google-login",
            _googleLoginController,
          );

  final Router _router;
  Router get router => _router;
}

Future<Response> _googleLoginController(Request request) async {
  // TODO this will be a controller one day
  return Response.ok("Google login");
}
