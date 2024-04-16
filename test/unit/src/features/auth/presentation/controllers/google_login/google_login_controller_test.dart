import 'dart:convert';
import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../../bin/src/features/auth/domain/use_cases/google_login/google_login_use_case.dart';
import '../../../../../../../../bin/src/features/auth/presentation/controllers/google_login/google_login_controller.dart';
import '../../../../../../../../bin/src/features/core/domain/use_cases/create_jwt_access_token_cookie/create_jwt_access_token_cookie_use_case.dart';
import '../../../../../../../../bin/src/features/players/domain/models/player_model.dart';
import '../../../../../../../../bin/src/features/players/domain/use_cases/get_player_by_auth_id/get_player_by_auth_id_use_case.dart';

void main() {
  final googleLoginUseCase = _MockGoogleLoginUseCase();
  final getPlayerByAuthIdUseCase = _MockGetPlayerByAuthIdUseCase();
  final createJWTAccessTokenCookieUseCase =
      _MockCreateJWTAccessTokenCookieUseCase();
  final request = _MockRequest();

  // tested class
  final googleLoginController = GoogleLoginController(
    googleLoginUseCase: googleLoginUseCase,
    getPlayerByAuthIdUseCase: getPlayerByAuthIdUseCase,
    createJWTAccessTokenCookieUseCase: createJWTAccessTokenCookieUseCase,
  );

  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  tearDown(() {
    reset(googleLoginUseCase);
    reset(getPlayerByAuthIdUseCase);
    reset(request);
    reset(createJWTAccessTokenCookieUseCase);
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
          final responseString = await response.readAsString();
          final responseMap = jsonDecode(responseString);

          // then
          expect(response.statusCode, 404);
          expect(
              // jsonDecode(await response.readAsString()),
              responseMap,
              equals({
                "ok": false,
                "message": "Authenticated player not found",
              }));

          // cleanup
        },
      );

      test(
        "given provided idToken resolves to a valid player"
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
              .thenAnswer((i) async => testPlayerModel);
          when(
            () => createJWTAccessTokenCookieUseCase.call(
              payload: any(named: "payload"),
              expiresIn: any(named: "expiresIn"),
            ),
          ).thenReturn(testAuthCookie);

          // when
          final response = await googleLoginController(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponsePayload = {
            "ok": true,
            "data": {
              "id": testPlayerModel.id,
              "name": testPlayerModel.name,
              "nickname": testPlayerModel.nickname,
            },
            "message": "User authenticated successfully.",
          };

          expect(response.statusCode, 200);
          expect(
            jsonDecode(responseString),
            equals(expectedResponsePayload),
          );

          // cleanup
        },
      );

      test(
        "given user is signed in with google"
        "when return Response object "
        "then should contain expected auth cookie",
        () async {
          // setup
          final authId = 1;

          // given
          when(() => request.readAsString())
              .thenAnswer((i) async => validRequestBodyString);
          when(() => googleLoginUseCase(idToken: any(named: "idToken")))
              .thenAnswer((i) async => 1);
          when(() => getPlayerByAuthIdUseCase(authId: any(named: "authId")))
              .thenAnswer((i) async => testPlayerModel);
          when(
            () => createJWTAccessTokenCookieUseCase.call(
              payload: any(named: "payload"),
              expiresIn: any(named: "expiresIn"),
            ),
          ).thenReturn(testAuthCookie);

          // when
          final response = await googleLoginController(request);

          // then
          final responseHeaders = response.headers;
          final responseCookies = responseHeaders["Set-Cookie"];

          final cookieStrings = responseCookies?.split(",") ?? [];

          final cookies = cookieStrings.map((cookieString) {
            final cookie = Cookie.fromSetCookieValue(cookieString);
            return cookie;
          }).toList();

          expect(cookies, hasLength(1));
          expect(cookies.first.toString(), equals(testAuthCookie.toString()));

          verify(() => createJWTAccessTokenCookieUseCase.call(
                payload: {
                  "authId": authId,
                  "playerId": testPlayerModel.id,
                },
                expiresIn: Duration(days: 7),
              )).called(1);
        },
      );
    });
  });
}

class _MockGoogleLoginUseCase extends Mock implements GoogleLoginUseCase {}

class _MockGetPlayerByAuthIdUseCase extends Mock
    implements GetPlayerByAuthIdUseCase {}

class _MockRequest extends Mock implements Request {}

class _MockCreateJWTAccessTokenCookieUseCase extends Mock
    implements CreateJWTAccessTokenCookieUseCase {}

final testPlayerModel = PlayerModel(
  id: 1,
  name: "name",
  nickname: "nickname",
  authId: 1,
);

final testAuthCookie = Cookie.fromSetCookieValue(
  "accessToken=token; HttpOnly; Secure; Path=/",
);
