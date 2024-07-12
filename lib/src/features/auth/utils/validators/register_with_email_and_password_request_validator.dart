import 'dart:io';

import 'package:five_on_4_backend/src/features/matches/utils/mixins/string_checker_mixin.dart';
import 'package:shelf/shelf.dart';

// import '../../../../../../test/unit/src/features/matches/utils/mixins/string_checker_mixin.dart';
import '../../../core/utils/helpers/response_generator.dart';
import '../../../core/utils/validators/request_validator.dart';
import '../constants/register_with_email_and_password_request_body_key_constants.dart';
import '../../../core/utils/extensions/request_extension.dart';

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
          final response = ResponseGenerator.failure(
            message: "Email is required.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        if (email is! String) {
          final response = ResponseGenerator.failure(
            message: "Invalid data type supplied for email.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        final isValidEmail = checkIsValidEmail(email);
        if (!isValidEmail) {
          final response = ResponseGenerator.failure(
            message: "Invalid email.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        // password
        final password = body[
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value];
        if (password == null) {
          final response = ResponseGenerator.failure(
            message: "Password is required.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        if (password is! String) {
          final response = ResponseGenerator.failure(
            message: "Invalid data type supplied for password.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        if (password.length < 6) {
          final response = ResponseGenerator.failure(
            message: "Password must be at least 6 characters long.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        if (password.length > 20) {
          final response = ResponseGenerator.failure(
            message: "Password cannot be longer than 20 characters.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        final isLettersAndNumbersPassword =
            checkIfContainsLettersAndNumbers(password);
        if (!isLettersAndNumbersPassword) {
          final response = ResponseGenerator.failure(
            message: "Password has to contain both letters and numbers.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        // first name
        final firstName = body[
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value];
        if (firstName == null) {
          final response = ResponseGenerator.failure(
            message: "First name is required.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        if (firstName is! String) {
          final response = ResponseGenerator.failure(
            message: "Invalid data type supplied for first name.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        // last name
        final lastName = body[
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .LAST_NAME.value];
        if (lastName == null) {
          final response = ResponseGenerator.failure(
            message: "Last name is required.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        if (lastName is! String) {
          final response = ResponseGenerator.failure(
            message: "Invalid data type supplied for last name.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        // nickname
        final nickname = body[
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value];
        if (nickname == null) {
          final response = ResponseGenerator.failure(
            message: "Nickname is required.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        if (nickname is! String) {
          final response = ResponseGenerator.failure(
            message: "Invalid data type supplied for nickname.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
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
