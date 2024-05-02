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

Response generateTestNonExistentResponse({
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
