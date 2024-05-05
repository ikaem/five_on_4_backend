import 'dart:convert';
import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../../bin/src/features/auth/domain/use_cases/get_auth_by_email_and_hashed_password/get_auth_by_email_and_hashed_password_use_case.dart';
import '../../../../../../../../bin/src/features/auth/presentation/controllers/login/login_controller.dart';
import '../../../../../../../../bin/src/features/auth/utils/constants/login_request_body_key_constants.dart';
import '../../../../../../../../bin/src/features/core/domain/models/auth/auth_model.dart';
import '../../../../../../../../bin/src/features/core/domain/use_cases/create_jwt_access_token_cookie/create_jwt_access_token_cookie_use_case.dart';
import '../../../../../../../../bin/src/features/core/domain/use_cases/get_hashed_value/get_hashed_value_use_case.dart';
import '../../../../../../../../bin/src/features/players/domain/models/player_model.dart';
import '../../../../../../../../bin/src/features/players/domain/use_cases/get_player_by_auth_id/get_player_by_auth_id_use_case.dart';
import '../../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();

  final getAuthByEmailAndHashedPasswordUseCase =
      _MockGetAuthByEmailAndHashedPasswordUseCase();
  final getPlayerByAuthIdUseCase = _MockGetPlayerByAuthIdUseCase();
  final getHashedValueUseCase = _MockGetHashedValueUseCase();
  final createJWTAccessTokenCookieUseCase =
      _MockCreateJWTAccessTokenCookieUseCase();

  // tested controller
  final loginController = LoginController(
    getAuthByEmailAndHashedPasswordUseCase:
        getAuthByEmailAndHashedPasswordUseCase,
    getPlayerByAuthIdUseCase: getPlayerByAuthIdUseCase,
    getHashedValueUseCase: getHashedValueUseCase,
    createJWTAccessTokenCookieUseCase: createJWTAccessTokenCookieUseCase,
  );

  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  tearDown(() {
    reset(request);
    reset(getAuthByEmailAndHashedPasswordUseCase);
    reset(getPlayerByAuthIdUseCase);
    reset(getHashedValueUseCase);
    reset(createJWTAccessTokenCookieUseCase);
  });

  group(
    "$LoginController",
    () {
      group(".call()", () {
        final email = "email";
        final password = "password";
        final hashedPassword = "hashedPassword";

        final requestMap = {
          LoginRequestBodyKeyConstants.EMAIL.value: email,
          LoginRequestBodyKeyConstants.PASSWORD.value: password,
        };
        // if no auth with this email and hashed password, return expected response
        test(
          "given request with email and password not associated with an auth in db"
          "when .call() is called"
          "then should return expected response",
          () async {
            // setup
            when(() => getHashedValueUseCase(value: password))
                .thenReturn(hashedPassword);

            when(() => getAuthByEmailAndHashedPasswordUseCase(
                  email: any(named: "email"),
                  hashedPassword: any(named: "hashedPassword"),
                )).thenAnswer((_) async => null);

            // given
            when(() => request.readAsString())
                .thenAnswer((_) async => jsonEncode(requestMap));

            // when
            final response = await loginController(request);
            final responseString = await response.readAsString();

            // then
            final expectedResponse = generateTestUnauthorizedResponse(
              responseMessage: "Invalid credentials",
              cookies: null,
            );
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, equals(expectedResponseString));
            expect(response.statusCode, equals(expectedResponse.statusCode));
            expect(response.headers[HttpHeaders.setCookieHeader],
                equals(expectedResponse.headers[HttpHeaders.setCookieHeader]));

            // cleanup
          },
        );

        // TODO this could be outdate
        // if no player with this auth id, return expected response
        test(
          "given retrieved authId from db is not associated with a player in db"
          "when .call() is called"
          "then should return expected response",
          () async {
            // setup
            when(() => getHashedValueUseCase(value: password))
                .thenReturn(hashedPassword);

            when(() => getAuthByEmailAndHashedPasswordUseCase(
                  email: any(named: "email"),
                  hashedPassword: any(named: "hashedPassword"),
                )).thenAnswer((_) async => _testAuthModel);

            when(() => getPlayerByAuthIdUseCase(authId: _testAuthModel.id))
                .thenAnswer((_) async => null);

            // given
            when(() => request.readAsString())
                .thenAnswer((_) async => jsonEncode(requestMap));

            // when
            final response = await loginController(request);
            final responseString = await response.readAsString();

            // then
            final expectedResponse = generateTestNotFoundResponse(
              responseMessage: "Authenticated player not found.",
              cookies: null,
            );
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, equals(expectedResponseString));
            expect(response.statusCode, equals(expectedResponse.statusCode));
            expect(response.headers[HttpHeaders.setCookieHeader],
                equals(expectedResponse.headers[HttpHeaders.setCookieHeader]));

            // cleanup
          },
        );

        // if player and auth found, return expected respionse
        test(
          "given retrieved authId from db is associated with a player in db"
          "when .call() is called"
          "then should return expected response",
          () async {
            // setup
            when(() => getHashedValueUseCase(value: password))
                .thenReturn(hashedPassword);

            when(() => getAuthByEmailAndHashedPasswordUseCase(
                  email: any(named: "email"),
                  hashedPassword: any(named: "hashedPassword"),
                )).thenAnswer((_) async => _testAuthModel);

            when(() => getPlayerByAuthIdUseCase(authId: _testAuthModel.id))
                .thenAnswer((_) async => _testPlayerModel);
            when(
              () => createJWTAccessTokenCookieUseCase.call(
                payload: any(named: "payload"),
                expiresIn: any(named: "expiresIn"),
              ),
            ).thenReturn(testAuthCookie);

            // given
            when(() => request.readAsString())
                .thenAnswer((_) async => jsonEncode(requestMap));

            // when
            final response = await loginController(request);
            final responseString = await response.readAsString();

            // then
            final expectedResponseData = {
              "id": _testPlayerModel.id,
              "name": _testPlayerModel.name,
              "nickname": _testPlayerModel.nickname,
            };
            final expectedResponse = generateTestOkResponse(
              responseData: expectedResponseData,
              responseMessage: "User logged in successfully",
            );
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, equals(expectedResponseString));
            expect(response.statusCode, equals(expectedResponse.statusCode));

            // cleanup
          },
        );

        // if success response returned, it should container expected access token cookie with expected values inside the jwt
        test(
          "given retrieved authId from db is associated with a player in db"
          "when .call() is called"
          "then should return response with expected cookie",
          () async {
            // setup
            when(() => getHashedValueUseCase(value: password))
                .thenReturn(hashedPassword);

            when(() => getAuthByEmailAndHashedPasswordUseCase(
                  email: any(named: "email"),
                  hashedPassword: any(named: "hashedPassword"),
                )).thenAnswer((_) async => _testAuthModel);

            when(() => getPlayerByAuthIdUseCase(authId: _testAuthModel.id))
                .thenAnswer((_) async => _testPlayerModel);
            when(
              () => createJWTAccessTokenCookieUseCase.call(
                payload: any(named: "payload"),
                expiresIn: any(named: "expiresIn"),
              ),
            ).thenReturn(testAuthCookie);

            // given
            when(() => request.readAsString())
                .thenAnswer((_) async => jsonEncode(requestMap));

            // when
            final response = await loginController(request);

            // then
            final responsCookies =
                response.headers[HttpHeaders.setCookieHeader];
            final cookieStrings = responsCookies!.split(",");
            final cookies = cookieStrings.map((cookieString) {
              return Cookie.fromSetCookieValue(cookieString);
            }).toList();

            expect(cookies, hasLength(1));
            expect(cookies.first.toString(), equals(testAuthCookie.toString()));
          },
        );

        // TODO should test calls to use cases - that proper arguments are passed
      });
    },
  );
}

class _MockRequest extends Mock implements Request {}

class _MockGetAuthByEmailAndHashedPasswordUseCase extends Mock
    implements GetAuthByEmailAndHashedPasswordUseCase {}

class _MockGetPlayerByAuthIdUseCase extends Mock
    implements GetPlayerByAuthIdUseCase {}

class _MockGetHashedValueUseCase extends Mock
    implements GetHashedValueUseCase {}

class _MockCreateJWTAccessTokenCookieUseCase extends Mock
    implements CreateJWTAccessTokenCookieUseCase {}

final _testAuthModel = AuthModel(
  id: 1,
  email: "email",
  createdAt: DateTime.now().millisecondsSinceEpoch,
  updatedAt: DateTime.now().millisecondsSinceEpoch,
);

final _testPlayerModel = PlayerModel(
  id: 1,
  authId: 1,
  nickname: "nickname",
  name: "name",
);

final testAuthCookie = Cookie.fromSetCookieValue(
  "accessToken=token; HttpOnly; Secure; Path=/",
);
