import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

abstract class ResponseGenerator {
  static Response failure({
    required String message,
    required int statusCode,
  }) {
    final response = _generateResponse(
      message: message,
      data: null,
      statusCode: statusCode,
      ok: false,
    );

    return response;
  }

  static Response success({
    required String message,
    required Map<String, Object?>? data,
    int statusCode = HttpStatus.ok,
  }) {
    final response = _generateResponse(
      message: message,
      data: data,
      statusCode: statusCode,
      ok: true,
    );

    return response;
  }

  static Response _generateResponse({
    required String message,
    required Map<String, Object?>? data,
    required int statusCode,
    required bool ok,
  }) {
    final response = Response(
      statusCode,
      body: jsonEncode(
        {
          "ok": ok,
          "message": message,
          if (data != null) "data": data,
        },
      ),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );

    return response;
  }
}
