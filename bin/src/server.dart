import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'features/core/presentation/router/app_router.dart';

class Server {
  Server({
    required AppRouter appRouter,
  }) : _appRouter = appRouter;

  final AppRouter _appRouter;

  Future<HttpServer> start({
    required int port,
    required InternetAddress ip,
  }) async {
    final requestHandler = Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware((innerHandler) {
          return (request) {
            return Future.sync(() => innerHandler(request)).then((response) {
              // response = response.change(headers: {
              //   'Access-Control-Allow-Origin': '*',
              //   'Access-Control-Allow-Methods': 'GET, POST, DELETE, PUT, PATCH',
              //   'Access-Control-Allow-Headers': 'Content-Type, Authorization',
              // });
              return response;
            });
          };
        })
        .addMiddleware(someRandomMiddleware())
        .addMiddleware(someOtherRandomMiddleware)
        .addHandler(
          _appRouter.router.call,
        );

    final server = await serve(
      requestHandler,
      ip,
      port,
    );
    // TODO not sure about this
    server.autoCompress = true;

    print("Serving at http://${ip.host}:${server.port}");

    return server;
  }
}

Middleware someRandomMiddleware() => (innerHandler) {
      return (request) {
        // TODO here we can validate? and return responses
        return Future.sync(() => innerHandler(request)).then((response) {
          print("request here: $request");
          print("inner handler here: $innerHandler");
          return response;
        });
      };
    };

final someOtherRandomMiddleware = createMiddleware(
  errorHandler: (
    Object error,
    StackTrace stackTrace,
  ) {
    // this will return
    return Response.internalServerError(
      body: jsonEncode(
        {
          "ok": false,
          "data": {},
          "message": "There was an issue on the server"
        },
      ),
    );
  },
  requestHandler: (Request request) {
    // if return null, request will pass the middleware
    print("request: ${request.url}");
    return null;
  },
  responseHandler: (Response response) {
    print("this is from response: ${response.statusCode}");

    // TODO in case we want to modify response - make all application json for instance, or add cookie for instance, if this was protected route
    return response;
  },
);

/* 


Middleware authorize(UsersService usersService, JwtService jwtService,
        List<String> routesRequiringAuthorization) =>
    (innerHandler) {
      return (request) async {
        var isAuthorizationRequired =
            routesRequiringAuthorization.contains(request.url.path);

        if (isAuthorizationRequired) {
          final authorizationHeader = request.headers['Authorization'] ??
              request.headers['authorization'];

          if (authorizationHeader == null) {
            return Response(401);
          }

          if (!authorizationHeader.startsWith('Token ')) {
            return Response(401);
          }

          final token = authorizationHeader.replaceFirst('Token', '').trim();

          if (token.isEmpty) {
            return Response(401);
          }

          final userTokenClaim = jwtService.getUserTokenClaim(token);

          if (userTokenClaim == null) {
            return Response(401);
          }

          final user = await usersService.getUserByEmail(userTokenClaim.email);

          if (user == null) {
            return Response(401);
          }

          request = request.change(context: {'user': user});
        }

        return Future.sync(() => innerHandler(request)).then((response) {
          return response;
        });
      };
    };

 */

// with individual routes
/* Handler get router {
    final router = Router();

    router.post('/users', _registerUserHandler);

    router.post('/users/login', _loginUserHandler);

    router.get(
        '/user',
        Pipeline()
            .addMiddleware(authorize(usersService, jwtService))
            .addHandler(_getCurrentUserHandler));

    router.put(
        '/user',
        Pipeline()
            .addMiddleware(authorize(usersService, jwtService))
            .addHandler(_updateUserHandler));

    return router;
  } */
