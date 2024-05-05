import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../../../../test/unit/src/features/matches/utils/mixins/string_checker_mixin.dart';
import '../constants/register_with_email_and_password_request_body_key_constants.dart';
import '../../../core/domain/values/response_body_value.dart';
import '../../../core/utils/extensions/request_extension.dart';
import '../../../core/utils/helpers/response_generator.dart';

class RegisterWithEmailAndPasswordRequestValidator with StringCheckerMixin {
  FutureOr<Response?> validate(Request request) async {
    final body = await request.parseBody();

    // email
    final email =
        body[RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value];
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
        RegisterWithEmailAndPasswordRequestBodyKeyConstants.FIRST_NAME.value];
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
        RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value];
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

    return null;
  }

  // bool _checkIsValidEmail(String email) {
  //   final emailRegExp = RegExp(
  //     RegExpConstants.EMAIL.value,
  //   );

  //   final isValid = emailRegExp.hasMatch(email);
  //   return isValid;
  // }

  // bool _checkIfContainsLettersAndNumbers(String value) {
  //   final alphaNumericRegExp = RegExp(
  //     RegExpConstants.LETTERS_AND_NUMBERS.value,
  //   );

  //   final isValid = alphaNumericRegExp.hasMatch(value);
  //   return isValid;
  // }
}
