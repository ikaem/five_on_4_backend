import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/utils/validators/logout_request_validator.dart';
import '../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();

// tested class
  final validator = LogoutRequestValidator();

  tearDown(() {
    reset(request);
  });

  group(
    "$LogoutRequestValidator",
    () {
      group(".validate()", () {
        // should return expected response if no required cookie is in request
        test(
          "given a request without accessToken cookie"
          "when .validate() is called"
          "then should return expected response",
          () async {
            // setup

            // given
            when(() => request.headers).thenReturn({});

            // when
            final response = await validator.validate(request);
            final responseString = await response!.readAsString();

            // then
            final expectedResponse = generateTestBadRequestResponse(
              responseMessage: "No cookies found in request.",
              cookies: [],
            );
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, expectedResponseString);
            expect(response.statusCode, expectedResponse.statusCode);
            expect(response.headers[HttpHeaders.setCookieHeader],
                expectedResponse.headers[HttpHeaders.setCookieHeader]);

            // cleanup
          },
        );

        // should return expected response if invalid auth token in cookie

        // should return expected response if expired auth token in cookie

        // should return null if all good
      });
    },
  );
}

class _MockRequest extends Mock implements Request {}
