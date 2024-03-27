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
    final requestHandler = Pipeline().addMiddleware(logRequests()).addHandler(
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
