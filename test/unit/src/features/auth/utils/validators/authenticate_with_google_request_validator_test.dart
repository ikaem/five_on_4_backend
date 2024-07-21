import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/auth/utils/constants/authenticate_with_google_request_body_key_constants.dart';
import 'package:five_on_4_backend/src/features/auth/utils/validators/authenticate_with_google_request_validator.dart';
import 'package:five_on_4_backend/src/features/core/utils/constants/request_constants.dart';
import '../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();
  final validatedRequestHandler = _MockValidatedRequestHandlderWrapper();

  // tested class
  final authenticateWithGoogleRequestValidator =
      AuthenticateWithGoogleRequestValidator();

  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });

  tearDown(() {
    reset(request);
    reset(validatedRequestHandler);
  });

  group("$AuthenticateWithGoogleRequestValidator", () {
    // given a request with no idToken
    test(
      "given a request with no idToken"
      "when .validate() is called"
      "then should return expected response",
      () async {
        // setup
        final requestBody = {
          // AuthenticateWithGoogleRequestBodyKeyConstants.TOKEN_ID.value: null,
        };

        // given
        when(() => request.readAsString())
            .thenAnswer((_) async => jsonEncode(requestBody));

        // when
        final response = await authenticateWithGoogleRequestValidator.validate(
          validatedRequestHandler: validatedRequestHandler.call,
        )(request);
        final responseString = await response.readAsString();

        // then
        final expectedResponse = generateTestBadRequestResponse(
          responseMessage: "Google idToken is required.",
        );
        final expectedResponseString = await expectedResponse.readAsString();

        expect(responseString, expectedResponseString);
        expect(response.statusCode, expectedResponse.statusCode);

        // cleanup
      },
    );

    test(
      "given a request with idToken of invalid type"
      "when .validate() is called"
      "then should return expected response",
      () async {
        // setup
        final requestBody = {
          AuthenticateWithGoogleRequestBodyKeyConstants.ID_TOKEN.value: 1,
        };

        // given
        when(() => request.readAsString())
            .thenAnswer((_) async => jsonEncode(requestBody));

        // when
        final response = await authenticateWithGoogleRequestValidator.validate(
          validatedRequestHandler: validatedRequestHandler.call,
        )(request);
        final responseString = await response.readAsString();

        // then
        final expectedResponse = generateTestBadRequestResponse(
          responseMessage: "Invalid data type supplied for idToken.",
        );
        final expectedResponseString = await expectedResponse.readAsString();

        expect(responseString, expectedResponseString);
        expect(response.statusCode, expectedResponse.statusCode);

        // cleanup
      },
    );

    // given valid request
    test(
      "given valid request"
      "when .validate() is called"
      "then should return result of call to validatedRequestHandler",
      () async {
        // setup
        final changedRequest = _FakeRequest();

        final requestBody = {
          AuthenticateWithGoogleRequestBodyKeyConstants.ID_TOKEN.value:
              "idToken",
        };

        final validatedRequestHandlerResponse = Response.ok("ok");
        when(() => validatedRequestHandler(any()))
            .thenAnswer((_) async => validatedRequestHandlerResponse);

        when(() => request.change(context: any(named: "context")))
            .thenReturn(changedRequest);

        // given
        when(() => request.readAsString())
            .thenAnswer((_) async => jsonEncode(requestBody));

        // when
        final response = await authenticateWithGoogleRequestValidator.validate(
          validatedRequestHandler: validatedRequestHandler.call,
        )(request);

        // then
        verify(() => validatedRequestHandler(changedRequest)).called(1);
        expect(response, equals(validatedRequestHandlerResponse));

        // cleanup
      },
    );

    // should call the validatedRequestHandler with the expected changed request
    test(
      "given valid request"
      "when .validate() is called"
      "then should have expected changedRequest passed to validatedRequestHandler",
      () async {
        // setup
        final requestBody = {
          AuthenticateWithGoogleRequestBodyKeyConstants.ID_TOKEN.value:
              "idToken",
        };

        final validatedRequestHandlerResponse = Response.ok("ok");
        when(() => validatedRequestHandler(any()))
            .thenAnswer((_) async => validatedRequestHandlerResponse);

        // given
        final originalRequest = Request(
          "post",
          Uri.parse("http://www.test.com/"),
          body: jsonEncode(requestBody),
        );

        // when
        await authenticateWithGoogleRequestValidator.validate(
          validatedRequestHandler: validatedRequestHandler.call,
        )(originalRequest);

        // then
        final expectedValidatedBodyData = {
          AuthenticateWithGoogleRequestBodyKeyConstants.ID_TOKEN.value:
              "idToken",
        };

        final captured =
            verify(() => validatedRequestHandler(captureAny())).captured;
        final changedRequest = captured.first as Request;
        final validatedBodyData =
            changedRequest.context[RequestConstants.VALIDATED_BODY_DATA.value];

        expect(validatedBodyData, equals(expectedValidatedBodyData));

        // cleanup
      },
    );
  });
}

class _MockRequest extends Mock implements Request {}

class _MockValidatedRequestHandlderWrapper extends Mock {
  Future<Response> call(Request request);
}

class _FakeRequest extends Fake implements Request {}
