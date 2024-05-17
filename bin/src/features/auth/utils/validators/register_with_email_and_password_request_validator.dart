import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../../../../test/unit/src/features/matches/utils/mixins/string_checker_mixin.dart';
import '../../../core/utils/validators/request_validator.dart';
import '../constants/register_with_email_and_password_request_body_key_constants.dart';
import '../../../core/domain/values/response_body_value.dart';
import '../../../core/utils/extensions/request_extension.dart';
import '../../../core/utils/helpers/generate_response.dart';

class RegisterWithEmailAndPasswordRequestValidator
    with StringCheckerMixin
    implements RequestValidator {
  @override
  ValidationHandler validate({
    required ValidatedRequestHandler validatedRequestHandler,
  }) =>
      (Request request) async {
        final body = await request.parseBody();

        // email
        final email = body[
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value];
        if (email == null) {
          final responseBody = ResponseBodyValue(
            message: "Email is required.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            // TODO no need for cookies if we haven't registered
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
        final password = body[
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value];
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

        if (password.length < 6) {
          final responseBody = ResponseBodyValue(
            message: "Password must be at least 6 characters long.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            cookies: [],
          );
        }

        if (password.length > 20) {
          final responseBody = ResponseBodyValue(
            message: "Password cannot be longer than 20 characters.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            cookies: [],
          );
        }

        final isLettersAndNumbersPassword =
            checkIfContainsLettersAndNumbers(password);
        if (!isLettersAndNumbersPassword) {
          final responseBody = ResponseBodyValue(
            message: "Password has to contain both letters and numbers.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            cookies: [],
          );
        }

        // first name
        final firstName = body[
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value];
        if (firstName == null) {
          final responseBody = ResponseBodyValue(
            message: "First name is required.",
            ok: false,
          );

          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            cookies: [],
          );
        }

        if (firstName is! String) {
          final responseBody = ResponseBodyValue(
            message: "Invalid data type supplied for first name.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            cookies: [],
          );
        }

        // last name
        final lastName = body[
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .LAST_NAME.value];
        if (lastName == null) {
          final responseBody = ResponseBodyValue(
            message: "Last name is required.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            cookies: [],
          );
        }

        if (lastName is! String) {
          final responseBody = ResponseBodyValue(
            message: "Invalid data type supplied for last name.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            cookies: [],
          );
        }

        // nickname
        final nickname = body[
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value];
        if (nickname == null) {
          final responseBody = ResponseBodyValue(
            message: "Nickname is required.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            cookies: [],
          );
        }

        if (nickname is! String) {
          final responseBody = ResponseBodyValue(
            message: "Invalid data type supplied for nickname.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            cookies: [],
          );
        }

        final validatedBodyData = {
          RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value:
              email,
          RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value:
              password,
          RegisterWithEmailAndPasswordRequestBodyKeyConstants.FIRST_NAME.value:
              firstName,
          RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value:
              lastName,
          RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value:
              nickname,
        };
        final changedRequest = request.getChangedRequestWithValidatedBodyData(
          validatedBodyData,
        );

        return validatedRequestHandler(changedRequest);
      };
}
