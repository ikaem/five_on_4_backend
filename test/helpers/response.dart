import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

Response generateTestBadRequestResponse({
  required String responseMessage,
  required List<Cookie>? cookies,
}) {
  return Response.badRequest(
    body: jsonEncode(
      {
        "ok": false,
        "message": responseMessage,
      },
    ),
    headers: {
      // "content-type": "application/json",
      HttpHeaders.contentTypeHeader: "application/json",
      // TODO cookies will need to come here
      if (cookies != null)
        HttpHeaders.setCookieHeader:
            cookies.map((cookie) => cookie.toString()).toList(),
    },
  );
}

Response generateTestNotFoundResponse({
  required String responseMessage,
  required List<Cookie>? cookies,
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
      if (cookies != null)
        HttpHeaders.setCookieHeader:
            cookies.map((cookie) => cookie.toString()).toList(),
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
  required List<Cookie>? cookies,
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
      if (cookies != null)
        HttpHeaders.setCookieHeader:
            cookies.map((cookie) => cookie.toString()).toList(),
    },
  );
}

Response generateTestInternalServerErrorResponse({
  required String responseMessage,
  required List<Cookie>? cookies,
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
      if (cookies != null)
        HttpHeaders.setCookieHeader:
            cookies.map((cookie) => cookie.toString()).toList(),
    },
  );
}
