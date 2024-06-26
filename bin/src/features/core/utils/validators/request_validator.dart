import 'dart:async';

import 'package:shelf/shelf.dart';

typedef ValidatedRequestHandler = FutureOr<Response> Function(
  Request validatedRequest,
);
typedef ValidationHandler = Future<Response> Function(Request request);

abstract interface class RequestValidator {
  ValidationHandler validate({
    required ValidatedRequestHandler validatedRequestHandler,
  });
}
