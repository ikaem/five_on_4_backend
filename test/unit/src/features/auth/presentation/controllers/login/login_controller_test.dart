import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../../bin/src/features/auth/domain/use_cases/create_access_jwt/create_access_jwt_use_case.dart';
import '../../../../../../../../bin/src/features/auth/domain/use_cases/create_refresh_jwt_cookie/create_refresh_jwt_cookie_use_case.dart';
import '../../../../../../../../bin/src/features/auth/domain/use_cases/get_auth_by_email_and_hashed_password/get_auth_by_email_and_hashed_password_use_case.dart';
import '../../../../../../../../bin/src/features/auth/presentation/controllers/login/login_controller.dart';
import '../../../../../../../../bin/src/features/auth/utils/constants/auth_response_constants.dart';
import '../../../../../../../../bin/src/features/auth/utils/constants/login_request_body_key_constants.dart';
import '../../../../../../../../bin/src/features/core/domain/models/auth/auth_model.dart';
import '../../../../../../../../bin/src/features/core/domain/use_cases/get_hashed_value/get_hashed_value_use_case.dart';
import '../../../../../../../../bin/src/features/core/utils/constants/request_constants.dart';
import '../../../../../../../../bin/src/features/players/domain/models/player_model.dart';
import '../../../../../../../../bin/src/features/players/domain/use_cases/get_player_by_auth_id/get_player_by_auth_id_use_case.dart';
import '../../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();

  final getAuthByEmailAndHashedPasswordUseCase =
      _MockGetAuthByEmailAndHashedPasswordUseCase();
  final getPlayerByAuthIdUseCase = _MockGetPlayerByAuthIdUseCase();
  final getHashedValueUseCase = _MockGetHashedValueUseCase();
  final createAccessJwtUseCase = _MockCreateAccessJwtUseCase();
  final createRefreshJwtCookieUseCase = _MockCreateRefreshJwtCookieUseCase();

  // tested controller
  final loginController = LoginController(
    getAuthByEmailAndHashedPasswordUseCase:
        getAuthByEmailAndHashedPasswordUseCase,
    getPlayerByAuthIdUseCase: getPlayerByAuthIdUseCase,
    getHashedValueUseCase: getHashedValueUseCase,
    createAccessJwtUseCase: createAccessJwtUseCase,
    createRefreshJwtCookieUseCase: createRefreshJwtCookieUseCase,
  );

  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  tearDown(() {
    reset(request);
    reset(getAuthByEmailAndHashedPasswordUseCase);
    reset(getPlayerByAuthIdUseCase);
    reset(getHashedValueUseCase);
    reset(createRefreshJwtCookieUseCase);
    reset(createAccessJwtUseCase);
  });

  group(
    "$LoginController",
    () {
      group(".call()", () {
        final email = "email";
        final password = "password";
        final hashedPassword = "hashedPassword";

        final validatedBodyMap = {
          LoginRequestBodyKeyConstants.EMAIL.value: email,
          LoginRequestBodyKeyConstants.PASSWORD.value: password,
        };

        test(
          "given request validation has not been done"
          "when .call() is called"
          "then should return expeted response",
          () async {
            // setup

            // given
            when(() => request.context).thenReturn({});

            // when
            final response = await loginController(request);
            final responseString = await response.readAsString();

            // then
            final expectedResponse = generateTestInternalServerErrorResponse(
              responseMessage: "Request body not validated.",
            );
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, equals(expectedResponseString));
            expect(response.statusCode, equals(expectedResponse.statusCode));

            // cleanup
          },
        );

        test(
          "given request with email and password not associated with an auth in db"
          "when .call() is called"
          "then should return expected response",
          () async {
            // setup
            when(() => request.context).thenReturn(
                {RequestConstants.VALIDATED_BODY_DATA.value: validatedBodyMap});
            when(() => getHashedValueUseCase.call(value: any(named: "value")))
                .thenReturn(hashedPassword);

            // given
            when(() => getAuthByEmailAndHashedPasswordUseCase.call(
                  email: any(named: "email"),
                  hashedPassword: any(named: "hashedPassword"),
                )).thenAnswer((invocation) async => null);

            // when
            final response = await loginController(request);
            final responseString = await response.readAsString();

            // then
            final expectedResponse = generateTestUnauthorizedResponse(
              responseMessage: "Invalid credentials",
            );
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, equals(expectedResponseString));
            expect(response.statusCode, equals(expectedResponse.statusCode));

            // cleanup
          },
        );

        test(
          "given retrieved authId from db is not associated with a player in db"
          "when .call() is called"
          "then should return expected response",
          () async {
            // setup
            when(() => request.context).thenReturn(
                {RequestConstants.VALIDATED_BODY_DATA.value: validatedBodyMap});
            when(() => getHashedValueUseCase.call(value: any(named: "value")))
                .thenReturn(hashedPassword);
            when(() => getAuthByEmailAndHashedPasswordUseCase.call(
                  email: any(named: "email"),
                  hashedPassword: any(named: "hashedPassword"),
                )).thenAnswer((invocation) async => _testAuthModel);

            // given
            when(() =>
                    getPlayerByAuthIdUseCase.call(authId: any(named: "authId")))
                .thenAnswer((invocation) async => null);

            // when
            final response = await loginController(request);
            final responseString = await response.readAsString();

            // then
            final expectedResponse = generateTestNotFoundResponse(
              responseMessage: "Authenticated player not found.",
            );
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, equals(expectedResponseString));
            expect(response.statusCode, equals(expectedResponse.statusCode));

            // cleanup
          },
        );

        test(
          "given retrieved authId from db is associated with a player in db"
          "when .call() is called"
          "then should return expected response",
          () async {
            // setup
            when(() => request.context).thenReturn(
                {RequestConstants.VALIDATED_BODY_DATA.value: validatedBodyMap});
            when(() => getHashedValueUseCase.call(value: any(named: "value")))
                .thenReturn(hashedPassword);
            when(() => getAuthByEmailAndHashedPasswordUseCase.call(
                  email: any(named: "email"),
                  hashedPassword: any(named: "hashedPassword"),
                )).thenAnswer((invocation) async => _testAuthModel);
            when(() => createAccessJwtUseCase.call(
                  authId: any(named: "authId"),
                  playerId: any(named: "playerId"),
                )).thenReturn("jwt");
            when(() => createRefreshJwtCookieUseCase.call(
                  authId: any(named: "authId"),
                  playerId: any(named: "playerId"),
                )).thenReturn(testRefreshCookie);

            // given
            when(() =>
                    getPlayerByAuthIdUseCase.call(authId: any(named: "authId")))
                .thenAnswer((invocation) async => _testPlayerModel);

            // when
            final response = await loginController(request);
            final responseString = await response.readAsString();

            // then
            final expectedResponse = generateTestOkResponse(
              responseData: {
                "id": _testPlayerModel.id,
                "name": _testPlayerModel.name,
                "nickname": _testPlayerModel.nickname,
              },
              responseMessage: "User logged in successfully",
            );
            final expectedResponseString =
                await expectedResponse.readAsString();

            expect(responseString, equals(expectedResponseString));
            expect(response.statusCode, equals(expectedResponse.statusCode));

            // cleanup
          },
        );

        test(
          "given retrieved authId from db is associated with a player in db"
          "when .call() is called"
          "then should return response with expected access jwt in headers",
          () async {
            // setup
            when(() => request.context).thenReturn(
                {RequestConstants.VALIDATED_BODY_DATA.value: validatedBodyMap});
            when(() => getHashedValueUseCase.call(value: any(named: "value")))
                .thenReturn(hashedPassword);
            when(() => getAuthByEmailAndHashedPasswordUseCase.call(
                  email: any(named: "email"),
                  hashedPassword: any(named: "hashedPassword"),
                )).thenAnswer((invocation) async => _testAuthModel);
            when(() => createAccessJwtUseCase.call(
                  authId: any(named: "authId"),
                  playerId: any(named: "playerId"),
                )).thenReturn("jwt");
            when(() => createRefreshJwtCookieUseCase.call(
                  authId: any(named: "authId"),
                  playerId: any(named: "playerId"),
                )).thenReturn(testRefreshCookie);

            // given
            when(() =>
                    getPlayerByAuthIdUseCase.call(authId: any(named: "authId")))
                .thenAnswer((invocation) async => _testPlayerModel);

            // when
            final response = await loginController(request);

            final accessToken = response
                .headers[AuthResponseConstants.ACCESS_JWT_HEADER_KEY.value];
            expect(accessToken, equals("jwt"));

            // cleanup
          },
        );

        test(
          "given retrieved authId from db is associated with a player in db"
          "when .call() is called"
          "then should return response with expected refresh jwt in cookie",
          () async {
            // setup
            when(() => request.context).thenReturn(
                {RequestConstants.VALIDATED_BODY_DATA.value: validatedBodyMap});
            when(() => getHashedValueUseCase.call(value: any(named: "value")))
                .thenReturn(hashedPassword);
            when(() => getAuthByEmailAndHashedPasswordUseCase.call(
                  email: any(named: "email"),
                  hashedPassword: any(named: "hashedPassword"),
                )).thenAnswer((invocation) async => _testAuthModel);
            when(() => createAccessJwtUseCase.call(
                  authId: any(named: "authId"),
                  playerId: any(named: "playerId"),
                )).thenReturn("jwt");
            when(() => createRefreshJwtCookieUseCase.call(
                  authId: any(named: "authId"),
                  playerId: any(named: "playerId"),
                )).thenReturn(testRefreshCookie);

            // given
            when(() =>
                    getPlayerByAuthIdUseCase.call(authId: any(named: "authId")))
                .thenAnswer((invocation) async => _testPlayerModel);

            // when
            final response = await loginController(request);

            final responsCookies =
                response.headers[HttpHeaders.setCookieHeader];

            final cookieStrings = responsCookies!.split(",");
            final cookies = cookieStrings.map((cookieString) {
              return Cookie.fromSetCookieValue(cookieString);
            }).toList();

            expect(cookies, hasLength(1));
            expect(
                cookies.first.toString(), equals(testRefreshCookie.toString()));
          },
        );
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

class _MockCreateAccessJwtUseCase extends Mock
    implements CreateAccessJwtUseCase {}

class _MockCreateRefreshJwtCookieUseCase extends Mock
    implements CreateRefreshJwtCookieUseCase {}

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

final testRefreshCookie = Cookie.fromSetCookieValue(
  "refreshToken=token; HttpOnly; Secure; Path=/",
);
