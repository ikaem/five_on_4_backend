import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/utils/constants/register_with_email_and_password_request_body_key_constants.dart';
import '../../../../../../../bin/src/features/matches/utils/validators/register_with_email_and_password_request_validator.dart';
import '../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();

  // tested class
  final validator = RegisterWithEmailAndPasswordRequestValidator();

  tearDown(() {
    reset(request);
  });

  group("$RegisterWithEmailAndPasswordRequestValidator", () {
    group(".validate()", () {
      // should return expected response if email is not provided
      test(
        "given a request with no email"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final requestMap = {
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value:
                "PASSWORD",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value:
                "LAST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value:
                "NICKNAME",
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
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value: 1,
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value:
                "PASSWORD",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value:
                "LAST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value:
                "NICKNAME",
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
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "not_an_email",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value:
                "PASSWORD",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value:
                "LAST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value:
                "NICKNAME",
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
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value:
                "LAST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value:
                "NICKNAME",
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
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value:
                1,
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value:
                "LAST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value:
                "NICKNAME",
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
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value:
                "12345",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value:
                "LAST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value:
                "NICKNAME",
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
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value:
                "123456789101112131415",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value:
                "LAST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value:
                "NICKNAME",
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
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value:
                "12345678910111213",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value:
                "LAST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value:
                "NICKNAME",
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
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value:
                "12345678910111asd",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value:
                "LAST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value:
                "NICKNAME",
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
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value:
                "12345678910111asd",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: 1,
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value:
                "LAST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value:
                "NICKNAME",
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
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value:
                "12345678910111asd",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value:
                "NICKNAME",
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
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value:
                "12345678910111asd",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value:
                1,
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value:
                "NICKNAME",
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
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value:
                "12345678910111asd",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value:
                "LAST_NAME",
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
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value:
                "12345678910111asd",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value:
                "LAST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value:
                1,
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
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value:
                "email@valid.com",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value:
                "12345678910111asd",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants
                .FIRST_NAME.value: "FIRST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value:
                "LAST_NAME",
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value:
                "NICKNAME",
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
