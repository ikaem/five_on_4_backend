import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../auth/utils/constants/register_with_email_and_password_request_body_key_constants.dart';
import '../../../core/utils/constants/reg_exp_constants.dart';
import '../../../core/utils/extensions/request_extension.dart';
import '../../../core/utils/helpers/response_generator.dart';

class RegisterWithEmailAndPasswordRequestValidator {
  FutureOr<Response?> validate(Request request) async {
    final body = await request.parseBody();

    // email
    final email =
        body[RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value];
    if (email == null) {
      return generateResponse(
        statusCode: HttpStatus.badRequest,
        isOk: false,
        message: "Email is required.",
      );
    }

    if (email is! String) {
      return generateResponse(
        statusCode: HttpStatus.badRequest,
        isOk: false,
        message: "Invalid data type supplied for email.",
      );
    }

    final isValidEmail = _checkIsValidEmail(email);
    if (!isValidEmail) {
      return generateResponse(
        statusCode: HttpStatus.badRequest,
        isOk: false,
        message: "Invalid email.",
      );
    }

    // password
    final password = body[
        RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value];
    if (password == null) {
      return generateResponse(
        statusCode: HttpStatus.badRequest,
        isOk: false,
        message: "Password is required.",
      );
    }
    if (password is! String) {
      return generateResponse(
        statusCode: HttpStatus.badRequest,
        isOk: false,
        message: "Invalid data type supplied for password.",
      );
    }
    if (password.length < 6) {
      return generateResponse(
        statusCode: HttpStatus.badRequest,
        isOk: false,
        message: "Password must be at least 6 characters long.",
      );
    }
    if (password.length > 20) {
      return generateResponse(
        statusCode: HttpStatus.badRequest,
        isOk: false,
        message: "Password cannot be longer than 20 characters.",
      );
    }

    final isLettersAndNumbersPassword =
        _checkIfContainsLettersAndNumbers(password);
    if (!isLettersAndNumbersPassword) {
      return generateResponse(
        statusCode: HttpStatus.badRequest,
        isOk: false,
        message: "Password has to contain both letters and numbers.",
      );
    }

    // first name
    final firstName = body[
        RegisterWithEmailAndPasswordRequestBodyKeyConstants.FIRST_NAME.value];
    if (firstName == null) {
      return generateResponse(
        statusCode: HttpStatus.badRequest,
        isOk: false,
        message: "First name is required.",
      );
    }
    if (firstName is! String) {
      return generateResponse(
        statusCode: HttpStatus.badRequest,
        isOk: false,
        message: "Invalid data type supplied for first name.",
      );
    }

    // last name
    final lastName = body[
        RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value];
    if (lastName == null) {
      return generateResponse(
        statusCode: HttpStatus.badRequest,
        isOk: false,
        message: "Last name is required.",
      );
    }
    if (lastName is! String) {
      return generateResponse(
        statusCode: HttpStatus.badRequest,
        isOk: false,
        message: "Invalid data type supplied for last name.",
      );
    }

    // nickname
    final nickname = body[
        RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value];
    if (nickname == null) {
      return generateResponse(
        statusCode: HttpStatus.badRequest,
        isOk: false,
        message: "Nickname is required.",
      );
    }
    if (nickname is! String) {
      return generateResponse(
        statusCode: HttpStatus.badRequest,
        isOk: false,
        message: "Invalid data type supplied for nickname.",
      );
    }

    return null;
  }

  bool _checkIsValidEmail(String email) {
    final emailRegExp = RegExp(
      RegExpConstants.EMAIL.value,
    );

    final isValid = emailRegExp.hasMatch(email);
    return isValid;
  }

  bool _checkIfContainsLettersAndNumbers(String value) {
    final alphaNumericRegExp = RegExp(
      RegExpConstants.LETTERS_AND_NUMBERS.value,
    );

    final isValid = alphaNumericRegExp.hasMatch(value);
    return isValid;
  }
}
