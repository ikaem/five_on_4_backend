import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../core/domain/values/response_body_value.dart';
import '../../../core/utils/extensions/request_extension.dart';
import '../../../core/utils/helpers/response_generator.dart';
import '../constants/login_request_body_key_constants.dart';

class LoginRequestValidator {
  FutureOr<Response?> validate(Request request) async {
    final body = await request.parseBody();

    // email
    final email = body[LoginRequestBodyKeyConstants.EMAIL.value];
    if (email == null) {
      final responseBody = ResponseBodyValue(
        message: "Email is required.",
        ok: false,
      );
      return generateResponse(
        statusCode: HttpStatus.badRequest,
        body: responseBody,
        cookies: [],
      );
    }

    if (email is! String) {
      final responseBody = ResponseBodyValue(
        message: "Invalid data type supplied for email.",
        ok: false,
      );
      return generateResponse(
        statusCode: HttpStatus.badRequest,
        body: responseBody,
        cookies: [],
      );
    }

    return null;
  }
}
