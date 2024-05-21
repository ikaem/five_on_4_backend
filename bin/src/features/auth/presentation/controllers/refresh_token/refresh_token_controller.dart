import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../../core/utils/helpers/response_generator.dart';

class RefreshTokenController {
  Future<Response> call(Request request) async {
    final response = ResponseGenerator.failure(
      message: "No cookie found in the request.",
      statusCode: HttpStatus.badRequest,
    );

    return response;
  }
}
