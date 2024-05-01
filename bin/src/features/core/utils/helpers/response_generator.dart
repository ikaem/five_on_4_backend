// TODO this should be tested too?
// TODO not sure if this should be a class

import 'dart:convert';

import 'package:shelf/shelf.dart';

Response generateResponse({
  required int statusCode,
  required bool isOk,
  required String message,
  Map<String, Object>? data,
  // TODO probably not needed
  // TODO will need to pass cookies
  // required Map<String, String> headers,
}) {
  final body = {
    "ok": isOk,
    "message": message,
    if (data != null) "data": data,
  };

  final response = Response(
    statusCode,
    body: jsonEncode(body),
    headers: {
      "Content-Type": "application/json",
    },
  );

  return response;
}
