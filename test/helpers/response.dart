import 'dart:convert';

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
      "content-type": "application/json",
      // TODO cookies will need to come here
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
      "Content-Type": "application/json",
    },
  );
}

Response generateTestOkResponse({
  required Map<String, dynamic> responseData,
  required String responseMessage,
}) {
  final payload = {
    "ok": true,
    "data": responseData,
    "message": responseMessage,
  };

  return Response.ok(
    jsonEncode(payload),
    headers: {
      "Content-Type": "application/json",
    },
  );
}
