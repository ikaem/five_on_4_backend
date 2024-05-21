import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../../core/utils/helpers/response_generator.dart';

class LogoutController {
  Future<Response> call(Request request) async {
    // TODO this should invalidate refresh token cookie, and also somehow invalidate maybe the access token
    // final responseBody = ResponseBodyValue(
    //   message: "Logut successful.",
    //   ok: true,
    // );
    // final response = generateResponse(
    //   statusCode: HttpStatus.ok,
    //   body: responseBody,
    //   cookies: [],
    // );

    final response = ResponseGenerator.success(
      message: "Logout successful.",
      data: null,
    );

    return response;
  }
}
