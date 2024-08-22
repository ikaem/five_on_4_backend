import 'package:shelf_router/shelf_router.dart';

abstract interface class RouterWrapper {
  abstract final String prefix;
  Router get router;
}
