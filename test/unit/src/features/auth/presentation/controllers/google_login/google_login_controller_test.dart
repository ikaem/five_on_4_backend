import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/auth/domain/use_cases/create_access_jwt/create_access_jwt_use_case.dart';
import 'package:five_on_4_backend/src/features/auth/domain/use_cases/create_refresh_jwt_cookie/create_refresh_jwt_cookie_use_case.dart';
import 'package:five_on_4_backend/src/features/auth/domain/use_cases/google_login/google_login_use_case.dart';
import 'package:five_on_4_backend/src/features/auth/presentation/controllers/google_login/google_login_controller.dart';
import 'package:five_on_4_backend/src/features/auth/utils/constants/auth_response_constants.dart';
import 'package:five_on_4_backend/src/features/auth/utils/constants/authenticate_with_google_request_body_key_constants.dart';
import 'package:five_on_4_backend/src/features/core/domain/models/auth/auth_model.dart';
import 'package:five_on_4_backend/src/features/core/utils/constants/request_constants.dart';
import 'package:five_on_4_backend/src/features/players/domain/models/player_model.dart';
import 'package:five_on_4_backend/src/features/players/domain/use_cases/get_player_by_auth_id/get_player_by_auth_id_use_case.dart';
import '../../../../../../../helpers/response.dart';

void main() {
  final googleLoginUseCase = _MockGoogleLoginUseCase();
  final getPlayerByAuthIdUseCase = _MockGetPlayerByAuthIdUseCase();
  final createAccessJwtUseCase = _MockCreateAccessJwtUseCase();
  final createRefreshJwtCookieUseCase = _MockCreateRefreshJwtCookieUseCase();
  final request = _MockRequest();

  // tested class
  final googleLoginController = GoogleLoginController(
    googleLoginUseCase: googleLoginUseCase,
    getPlayerByAuthIdUseCase: getPlayerByAuthIdUseCase,
    createAccessJwtUseCase: createAccessJwtUseCase,
    createRefreshJwtCookieUseCase: createRefreshJwtCookieUseCase,
  );

  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  tearDown(() {
    reset(googleLoginUseCase);
    reset(getPlayerByAuthIdUseCase);
    reset(request);
    reset(createAccessJwtUseCase);
    reset(createRefreshJwtCookieUseCase);
  });

  group("$GoogleLoginController", () {
    group(".call()", () {
      test(
        "given request validation has not been done"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup

          // given
          when(() => request.context).thenReturn({});

          // when
          final response = await googleLoginController(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestInternalServerErrorResponse(
              responseMessage: "Request body not validated.");
          final expectedResponseString = await expectedResponse.readAsString();

          expect(response.statusCode, equals(expectedResponse.statusCode));
          expect(responseString, equals(expectedResponseString));

          // cleanup
        },
      );

      test(
        "given request with invalid idToken"
        "when .call() is called"
        "then should retrun expected response",
        () async {
          // setup
          final validatedBodyMap = {
            AuthenticateWithGoogleRequestBodyKeyConstants.ID_TOKEN.value:
                "invalid_token",
          };

          // given
          when(() => request.context).thenReturn({
            RequestConstants.VALIDATED_BODY_DATA.value: validatedBodyMap,
          });
          when(() => googleLoginUseCase(idToken: any(named: "idToken")))
              .thenAnswer((i) async => null);

          // when
          final response = await googleLoginController(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestUnauthorizedResponse(
            responseMessage: "Invalid Google idToken provided.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(response.statusCode, equals(expectedResponse.statusCode));
          expect(responseString, equals(expectedResponseString));

          // cleanup
        },
      );

      test(
        "given retrieved authId from db is not associated with a player in db"
        "when .call() is called"
        "then should return expected response",
        () async {
          final validatedBodyMap = {
            AuthenticateWithGoogleRequestBodyKeyConstants.ID_TOKEN.value:
                "invalid_token",
          };
          when(() => request.context).thenReturn({
            RequestConstants.VALIDATED_BODY_DATA.value: validatedBodyMap,
          });
          when(() => googleLoginUseCase(idToken: any(named: "idToken")))
              .thenAnswer((i) async => _testAuthModel.id);

          // given
          when(() => getPlayerByAuthIdUseCase(authId: 1))
              .thenAnswer((i) async => null);

          // when
          final response = await googleLoginController(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestNotFoundResponse(
            responseMessage: "Authenticated player not found.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(response.statusCode, equals(expectedResponse.statusCode));
          expect(responseString, equals(expectedResponseString));

          // cleanup
        },
      );

      test(
        "given valid request"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          final validatedBodyMap = {
            AuthenticateWithGoogleRequestBodyKeyConstants.ID_TOKEN.value:
                "invalid_token",
          };
          when(() => googleLoginUseCase(idToken: any(named: "idToken")))
              .thenAnswer((i) async => _testAuthModel.id);
          when(() => getPlayerByAuthIdUseCase(authId: 1))
              .thenAnswer((i) async => _testPlayerModel);
          when(() => createAccessJwtUseCase.call(
                authId: any(named: "authId"),
                playerId: any(named: "playerId"),
              )).thenReturn("jwt");
          when(() => createRefreshJwtCookieUseCase.call(
                authId: any(named: "authId"),
                playerId: any(named: "playerId"),
              )).thenReturn(_testRefreshCookie);

          // given
          when(() => request.context).thenReturn({
            RequestConstants.VALIDATED_BODY_DATA.value: validatedBodyMap,
          });

          // when
          final response = await googleLoginController(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestOkResponse(
            responseData: {
              "id": _testPlayerModel.id,
              // "name": _testPlayerModel.name,
              "name":
                  "${_testPlayerModel.firstName} ${_testPlayerModel.lastName}",
              "nickname": _testPlayerModel.nickname,
            },
            responseMessage: "User authenticated successfully.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(response.statusCode, equals(expectedResponse.statusCode));
          expect(responseString, equals(expectedResponseString));

          // cleanup
        },
      );

      test(
        "given valid request"
        "when .call() is called"
        "then should should return expected response",
        () async {
          final validatedBodyMap = {
            AuthenticateWithGoogleRequestBodyKeyConstants.ID_TOKEN.value:
                "invalid_token",
          };
          when(() => googleLoginUseCase(idToken: any(named: "idToken")))
              .thenAnswer((i) async => _testAuthModel.id);
          when(() => getPlayerByAuthIdUseCase(authId: 1))
              .thenAnswer((i) async => _testPlayerModel);
          when(() => createAccessJwtUseCase.call(
                authId: any(named: "authId"),
                playerId: any(named: "playerId"),
              )).thenReturn("jwt");
          when(() => createRefreshJwtCookieUseCase.call(
                authId: any(named: "authId"),
                playerId: any(named: "playerId"),
              )).thenReturn(_testRefreshCookie);

          // given
          when(() => request.context).thenReturn({
            RequestConstants.VALIDATED_BODY_DATA.value: validatedBodyMap,
          });

          // when
          final response = await googleLoginController(request);

          // then
          final accessToken = response
              .headers[AuthResponseConstants.ACCESS_JWT_HEADER_KEY.value];
          expect(accessToken, equals("jwt"));

          // cleanup
        },
      );

      test(
        "given valid request"
        "when .call() is called"
        "then should should return expected response",
        () async {
          final validatedBodyMap = {
            AuthenticateWithGoogleRequestBodyKeyConstants.ID_TOKEN.value:
                "invalid_token",
          };
          when(() => googleLoginUseCase(idToken: any(named: "idToken")))
              .thenAnswer((i) async => _testAuthModel.id);
          when(() => getPlayerByAuthIdUseCase(authId: 1))
              .thenAnswer((i) async => _testPlayerModel);
          when(() => createAccessJwtUseCase.call(
                authId: any(named: "authId"),
                playerId: any(named: "playerId"),
              )).thenReturn("jwt");
          when(() => createRefreshJwtCookieUseCase.call(
                authId: any(named: "authId"),
                playerId: any(named: "playerId"),
              )).thenReturn(_testRefreshCookie);

          // given
          when(() => request.context).thenReturn({
            RequestConstants.VALIDATED_BODY_DATA.value: validatedBodyMap,
          });

          // when
          final response = await googleLoginController(request);

          // then
          final responsCookies = response.headers[HttpHeaders.setCookieHeader];

          final cookieStrings = responsCookies!.split(",");
          final cookies = cookieStrings.map((cookieString) {
            return Cookie.fromSetCookieValue(cookieString);
          }).toList();

          expect(cookies, hasLength(1));
          expect(
              cookies.first.toString(), equals(_testRefreshCookie.toString()));

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
  // name: "name",
  firstName: "firstName",
  lastName: "lastName",
);

final _testRefreshCookie = Cookie.fromSetCookieValue(
  "refresh_token=token; HttpOnly; Secure; Path=/",
);
