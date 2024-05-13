import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

abstract class ResponseGenerator {
  static Response auth({
    required String message,
    required Map<String, Object?> data,
    required String accessToken,
    required Cookie refreshTokenCookie,
    int statusCode = HttpStatus.ok,
  }) {
    final response = _generateResponse(
      message: message,
      data: data,
      statusCode: statusCode,
      ok: true,
      accessToken: accessToken,
      refreshTokenCookie: refreshTokenCookie,
    );

    return response;
  }

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
    required int statusCode,
    required bool ok,
    Map<String, Object?>? data,
    String? accessToken,
    Cookie? refreshTokenCookie,
  }) {
    final cookies = [
      if (refreshTokenCookie != null) refreshTokenCookie,
      // TODO for test only this second
      // if (refreshTokenCookie != null) refreshTokenCookie,
    ];
    final cookiesStrings = cookies.map((cookie) => cookie.toString()).toList();

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
        if (cookiesStrings.isNotEmpty)
          HttpHeaders.setCookieHeader: cookiesStrings,
        if (accessToken != null) "five_on_4_access_token": accessToken,
      },
    );

    return response;
  }
}
