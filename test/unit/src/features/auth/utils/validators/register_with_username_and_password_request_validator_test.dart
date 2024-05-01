import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/utils/constants/register_with_username_and_password_request_body_key_constants.dart';
import '../../../../../../../bin/src/features/matches/utils/validators/register_with_username_and_password_request_validator.dart';
import '../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();

  // tested class
  final validator = RegisterWithUsernameAndPasswordRequestValidator();

  tearDown(() {
    reset(request);
  });

  group("$RegisterWithUsernameAndPasswordRequestValidator", () {
    group(".validate()", () {
      // should return expected response if email is not provided
      test(
        "given a request with no email"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .PASSWORD.value: "PASSWORD",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .LAST_NAME.value: "LAST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .NICKNAME.value: "NICKNAME",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await validator.validate(request);
          final responseString = await response!.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Email is required.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(
            responseString,
            equals(expectedResponseString),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );
      // should return expected response if email is not a string
      test(
        "given a request with email not being a string"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants.EMAIL.value:
                1,
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .PASSWORD.value: "PASSWORD",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .LAST_NAME.value: "LAST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .NICKNAME.value: "NICKNAME",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await validator.validate(request);
          final responseString = await response!.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Invalid data type supplied for email.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(
            responseString,
            equals(expectedResponseString),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should retrun expected response if email is not email
      test(
        "given a request with email not being an email"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "not_an_email",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .PASSWORD.value: "PASSWORD",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .LAST_NAME.value: "LAST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .NICKNAME.value: "NICKNAME",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await validator.validate(request);
          final responseString = await response!.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Invalid email.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(
            responseString,
            equals(expectedResponseString),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should return expected response if password is not provided
      test(
        "given a request with no password"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .LAST_NAME.value: "LAST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .NICKNAME.value: "NICKNAME",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await validator.validate(request);
          final responseString = await response!.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Password is required.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(
            responseString,
            equals(expectedResponseString),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );
      // should return expected response if password is not a string
      test(
        "given a request with password not being a string"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .PASSWORD.value: 1,
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .LAST_NAME.value: "LAST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .NICKNAME.value: "NICKNAME",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await validator.validate(request);
          final responseString = await response!.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Invalid data type supplied for password.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(
            responseString,
            equals(expectedResponseString),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should return expected response if password is less than 6 characters
      test(
        "given password is less than 6 characters"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .PASSWORD.value: "12345",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .LAST_NAME.value: "LAST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .NICKNAME.value: "NICKNAME",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await validator.validate(request);
          final responseString = await response!.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Password must be at least 6 characters long.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(
            responseString,
            equals(expectedResponseString),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should return expected response if password is more than 20 characters
      test(
        "given password is longer than 20 characters"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .PASSWORD.value: "123456789101112131415",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .LAST_NAME.value: "LAST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .NICKNAME.value: "NICKNAME",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await validator.validate(request);
          final responseString = await response!.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Password cannot be longer than 20 characters.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(
            responseString,
            equals(expectedResponseString),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should return expected response if password is not alphanumeric
      test(
        "given password does not contain both letters and numbers"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .PASSWORD.value: "12345678910111213",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .LAST_NAME.value: "LAST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .NICKNAME.value: "NICKNAME",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await validator.validate(request);
          final responseString = await response!.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage:
                "Password has to contain both letters and numbers.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(
            responseString,
            equals(expectedResponseString),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should return expected response if first name is not provided
      test(
        "given a request with no first name"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .PASSWORD.value: "12345678910111asd",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .LAST_NAME.value: "LAST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .NICKNAME.value: "NICKNAME",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await validator.validate(request);
          final responseString = await response!.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "First name is required.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(
            responseString,
            equals(expectedResponseString),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should return expected response if first name is not a string
      test(
        "given a request with first name not being a string"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .PASSWORD.value: "12345678910111asd",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: 1,
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .LAST_NAME.value: "LAST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .NICKNAME.value: "NICKNAME",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await validator.validate(request);
          final responseString = await response!.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Invalid data type supplied for first name.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(
            responseString,
            equals(expectedResponseString),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should return expected response if last name is not provided
      test(
        "given a request with no last name"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .PASSWORD.value: "12345678910111asd",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .NICKNAME.value: "NICKNAME",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await validator.validate(request);
          final responseString = await response!.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Last name is required.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(
            responseString,
            equals(expectedResponseString),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should return expected response if last name is not a string
      test(
        "given a request with last name not being a string"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .PASSWORD.value: "12345678910111asd",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .LAST_NAME.value: 1,
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .NICKNAME.value: "NICKNAME",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await validator.validate(request);
          final responseString = await response!.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Invalid data type supplied for last name.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(
            responseString,
            equals(expectedResponseString),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should return expected response if nickname is not provided
      test(
        "given a request with no nickname"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .PASSWORD.value: "12345678910111asd",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .LAST_NAME.value: "LAST_NAME",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await validator.validate(request);
          final responseString = await response!.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Nickname is required.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(
            responseString,
            equals(expectedResponseString),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should return expected response if nickname is not a string
      test(
        "given a request with nickname not being a string"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .PASSWORD.value: "12345678910111asd",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .LAST_NAME.value: "LAST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .NICKNAME.value: 1,
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await validator.validate(request);
          final responseString = await response!.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
            responseMessage: "Invalid data type supplied for nickname.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(
            responseString,
            equals(expectedResponseString),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given a valid request"
        "when .validate() is called"
        "then should return null",
        () async {
          // setup
          final requestMap = {
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .PASSWORD.value: "12345678910111asd",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .LAST_NAME.value: "LAST_NAME",
            RegisterWithUsernameAndPasswordRequestBodyKeyConstants
                .NICKNAME.value: "NICKNAME",
          };

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => jsonEncode(requestMap));

          // when
          final response = await validator.validate(request);

          // then
          expect(response, isNull);

          // cleanup
        },
      );
    });
  });
}

class _MockRequest extends Mock implements Request {}
