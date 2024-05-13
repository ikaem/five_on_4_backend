import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../../../../test/unit/src/features/matches/utils/mixins/string_checker_mixin.dart';
import '../../../core/domain/values/response_body_value.dart';
import '../../../core/utils/extensions/request_extension.dart';
import '../../../core/utils/helpers/response_generator.dart';
import '../../../core/utils/validators/request_validator.dart';
import '../constants/login_request_body_key_constants.dart';

// TODO make interface for these

class LoginRequestValidator
    with StringCheckerMixin
    implements RequestValidator {
  const LoginRequestValidator();

  @override
  ValidationHandler validate({
    required ValidatedRequestHandler validatedRequestHandler,
  }) =>
      (Request request) async {
        final requestBody = await request.parseBody();

        // email
        final email = requestBody[LoginRequestBodyKeyConstants.EMAIL.value];
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

        final isValidEmail = checkIsValidEmail(email);
        if (!isValidEmail) {
          final responseBody = ResponseBodyValue(
            message: "Invalid email.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            cookies: [],
          );
        }

        // password
        final password =
            requestBody[LoginRequestBodyKeyConstants.PASSWORD.value];
        if (password == null) {
          final responseBody = ResponseBodyValue(
            message: "Password is required.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            cookies: [],
          );
        }

        if (password is! String) {
          final responseBody = ResponseBodyValue(
            message: "Invalid data type supplied for password.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            cookies: [],
          );
        }

        // TODO there could be a function or a class to do this
        final validatedBodyData = {
          LoginRequestBodyKeyConstants.EMAIL.value: email,
          LoginRequestBodyKeyConstants.PASSWORD.value: password,
        };

        final changedRequest = request.getChangedRequestWithValidatedBodyData(
          validatedBodyData,
        );

        return validatedRequestHandler(changedRequest);
      };
}
