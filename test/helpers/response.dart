import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

Response generateTestBadRequestResponse({
  required String responseMessage,
}) {
  return Response.badRequest(
    body: jsonEncode(
      {
        "ok": false,
        "message": responseMessage,
      },
    ),
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
    },
  );
}

Response generateTestNotFoundResponse({
  required String responseMessage,
}) {
  return Response.notFound(
    jsonEncode(
      {
        "ok": false,
        "message": responseMessage,
      },
    ),
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
    },
  );
}

Response generateTestOkResponse({
  required Map<String, dynamic>? responseData,
  required String responseMessage,
}) {
  final payload = {
    "ok": true,
    "message": responseMessage,
    if (responseData != null) "data": responseData,
  };

  return Response.ok(
    jsonEncode(payload),
    headers: {
      "Content-Type": "application/json",
    },
  );
}

Response generateTestUnauthorizedResponse({
  required String responseMessage,
}) {
  return Response.unauthorized(
    jsonEncode(
      {
        "ok": false,
        "message": responseMessage,
      },
    ),
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
    },
  );
}

Response generateTestInternalServerErrorResponse({
  required String responseMessage,
}) {
  return Response.internalServerError(
    body: jsonEncode(
      {
        "ok": false,
        "message": responseMessage,
      },
    ),
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
    },
  );
}
