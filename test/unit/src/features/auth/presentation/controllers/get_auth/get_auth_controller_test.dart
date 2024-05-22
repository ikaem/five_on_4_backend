import 'package:test/test.dart';

import '../../../../../../../../bin/src/features/auth/presentation/controllers/get_auth/get_auth_controller.dart';

void main() {
  // tested class
  final controller = GetAuthController();

  group("$GetAuthController", () {
    group(".call()", () {
      // should return expected response if no access token in headers
      test(
        "given request with no access token in headers"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup

          // given

          // when

          // then

          // cleanup
        },
      );

      // should return expected response if access token is invalid

      // should return expected response if access token is expored

      // should return expected response if auth does not exist

      // should return expected response if player does not exist

      // should return expected repsonse if player and auth do not match

      // should return expected response if everything is correct

      // should return expected response with access token included

      // should return expected response with refresh token cookie included
    });
  });
}
