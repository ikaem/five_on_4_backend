import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/auth/presentation/controllers/logout/logout_controller.dart';
import '../../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();

  // tested class
  final logoutController = LogoutController();

  tearDown(() {
    reset(request);
  });
  group("$LogoutController", () {
    group(".call()", () {
      // should return expected response if request valid
      test(
        "given a request"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup

          // given

          // when
          final response = await logoutController(request);
          final responseString = await response.readAsString();

          // then

          final expectedResponse = generateTestOkResponse(
            responseData: null,
            responseMessage: "Logout successful.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, expectedResponseString);
          expect(response.statusCode, expectedResponse.statusCode);
          // expect(response.headers[HttpHeaders.setCookieHeader],
          //     equals(expectedResponse.headers[HttpHeaders.setCookieHeader]));

          // cleanup
        },
      );

      // TODO should invalidate refresh cookie

      // TODO not valid below - no need to test
      // should return expected response if auth not found

      // should return expected response if player not found

      // should return expected response if player and auth do not match
    });
  });
}

class _MockRequest extends Mock implements Request {}
