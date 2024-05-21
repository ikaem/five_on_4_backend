import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../../bin/src/features/auth/presentation/controllers/refresh_token/refresh_token_controller.dart';
import '../../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();

  // tested class
  final controller = RefreshTokenController();

  tearDown(() {
    reset(request);
  });

  group("$RefreshTokenController", () {
    group(".call()", () {
      // should return bard request if there is no cookie in the request
      // TODO not needed - we dont care if there are not cookies in general
      // test(
      //   "given request without cookies"
      //   "when .call() is called"
      //   "then should return expected response",
      //   () async {
      //     // setup

      //     // given
      //     when(() => request.headers).thenReturn({});

      //     // when
      //     final response = await controller(request);
      //     final responseString = await response.readAsString();

      //     // then
      //     final expectedResponse = generateTestBadRequestResponse(
      //         responseMessage: "No cookie found in the request.");
      //     final expectedResponseString = await expectedResponse.readAsString();

      //     expect(responseString, equals(expectedResponseString));
      //     expect(response.statusCode, equals(expectedResponse.statusCode));

      //     // cleanup
      //   },
      // );

      // should return bad request if there is no not a refresh token cookie in cookies
      test(
        "given <pre-condition to the test>"
        "when <behavior we are specifying>"
        "then should <state we expect to happen>",
        () async {
          // setup

          // given

          // when

          // then

          // cleanup
        },
      );

      // should return bad request if the token is not valid

      // should return bad request if the token is expired

      // should return bad request if the token does not have expected payload

      // should return not found if the auth does not exist

      // should return not found if the player does not exist

      // should return bad request if the player and auth dont match

      // should return ok if everything is correct

      // should include access token in headers if all good

      // should include refresh token in http only cookie if all good
    });
  });
}

class _MockRequest extends Mock implements Request {}