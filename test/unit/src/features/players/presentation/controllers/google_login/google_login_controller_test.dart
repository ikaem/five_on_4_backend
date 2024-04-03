import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../../bin/src/features/auth/domain/use_cases/google_login/google_login_use_case.dart';
import '../../../../../../../../bin/src/features/auth/presentation/controllers/google_login/google_login_controller.dart';
import '../../../../../../../../bin/src/features/players/domain/use_cases/get_player_by_auth_id.dart';

void main() {
  final googleLoginUseCase = _MockGoogleLoginUseCase();
  final getPlayerByAuthIdUseCase = _MockGetPlayerByAuthIdUseCase();
  final request = _MockRequest();

  // tested class
  final googleLoginController = GoogleLoginController(
    googleLoginUseCase: googleLoginUseCase,
    getPlayerByAuthIdUseCase: getPlayerByAuthIdUseCase,
  );

  tearDown(() {
    reset(googleLoginUseCase);
    reset(getPlayerByAuthIdUseCase);
    reset(request);
  });

  group("$GoogleLoginController", () {
    group(".call()", () {
      const validRequestBodyString = '{"idToken": "valid_id_token"}';
      test(
        "given Request object with missing idToken"
        "when call() is called "
        "then should return expected response",
        () async {
          // setup

          // given
          when(() => request.readAsString()).thenAnswer((i) async => "");

          // when
          final response = await googleLoginController(request);
          final responsePayload = jsonDecode(await response.readAsString());

          // then
          expect(response.statusCode, 400);
          expect(
              responsePayload,
              equals({
                "ok": false,
                "message":
                    "Invalid payload provided. Google idToken is required.",
              }));

          // cleanup
        },
      );

      test(
        "given provided idToken is invalid"
        "when call() is called "
        "then should return expected response",
        () async {
          // setup

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => validRequestBodyString);
          when(() => googleLoginUseCase(idToken: any(named: "idToken")))
              .thenAnswer((i) async => null);

          // when
          final response = await googleLoginController(request);

          // then
          expect(response.statusCode, 400);
          expect(
              jsonDecode(await response.readAsString()),
              equals({
                "ok": false,
                "message": "Invalid Google idToken provided.",
              }));

          // cleanup
        },
      );

      test(
        "given provided idToken is valid and player is not found"
        "when call() is called "
        "then should return expected response",
        () async {
          // setup

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => validRequestBodyString);
          when(() => googleLoginUseCase(idToken: any(named: "idToken")))
              .thenAnswer((i) async => 1);
          when(() => getPlayerByAuthIdUseCase(authId: 1))
              .thenAnswer((i) async => null);

          // when
          final response = await googleLoginController(request);

          // then
          expect(response.statusCode, 404);
          expect(
              jsonDecode(await response.readAsString()),
              equals({
                "ok": false,
                "message": "Authenticated player not found",
              }));

          // cleanup
        },
      );
    });
  });
}

class _MockGoogleLoginUseCase extends Mock implements GoogleLoginUseCase {}

class _MockGetPlayerByAuthIdUseCase extends Mock
    implements GetPlayerByAuthIdUseCase {}

class _MockRequest extends Mock implements Request {}
