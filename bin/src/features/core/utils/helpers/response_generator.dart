// TODO this should be tested too?
// TODO not sure if this should be a class

import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../domain/values/response_body_value.dart';

Response generateResponse({
  required int statusCode,
  required ResponseBodyValue body,
  required List<Cookie> cookies,
  // required bool isOk,
  // required String message,
  // Map<String, Object>? data,
  // TODO probably not needed
  // TODO will need to pass cookies
  // required Map<String, String> headers,
}) {
  // final body = {
  //   "ok": isOk,
  //   "message": message,
  //   if (data != null) "data": data,
  // };

  final response = Response(
    statusCode,
    body: jsonEncode(body.toJson()),
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      // "Set-Cookie": cookies.map((cookie) => cookie.toString()).toList(),
      HttpHeaders.setCookieHeader:
          cookies.map((cookie) => cookie.toString()).toList(),
    },
  );

  return response;
}
