import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../../core/domain/values/response_body_value.dart';
import '../../../../core/utils/helpers/response_generator.dart';

class LogoutController {
  Future<Response> call(Request request) async {
    final responseBody = ResponseBodyValue(
      message: "Logut successful.",
      ok: true,
    );
    final response = generateResponse(
      statusCode: HttpStatus.ok,
      body: responseBody,
      cookies: [],
    );

    return response;
  }
}
