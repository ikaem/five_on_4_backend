import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../../bin/src/features/auth/domain/use_cases/create_access_jwt/create_access_jwt_use_case.dart';
import '../../../../../../../../bin/src/features/auth/domain/use_cases/create_refresh_jwt_cookie/create_refresh_jwt_cookie_use_case.dart';
import '../../../../../../../../bin/src/features/auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../../../../../../bin/src/features/auth/presentation/controllers/refresh_token/refresh_token_controller.dart';
import '../../../../../../../../bin/src/features/auth/utils/constants/auth_response_constants.dart';
import '../../../../../../../../bin/src/features/core/domain/models/auth/auth_model.dart';
import '../../../../../../../../bin/src/features/core/domain/use_cases/get_access_token_data_from_access_jwt/get_access_token_data_from_access_jwt_use_case.dart';
import '../../../../../../../../bin/src/features/core/domain/use_cases/get_cookie_by_name_in_request/get_cookie_by_name_in_request_use_case.dart';
import '../../../../../../../../bin/src/features/core/domain/values/refresh_token_data_value.dart';
import '../../../../../../../../bin/src/features/players/domain/models/player_model.dart';
import '../../../../../../../../bin/src/features/players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();
  final getCookieByNameInRequestUseCase =
      _MockGetCookieByNameInRequestUseCase();
  final getRefreshTokenDataFromAccessJwtUseCase =
      _MockGetRefreshTokenDataFromAccessJwtUseCase();
  final getAuthByIdUseCase = _MockGetAuthByIdUseCase();
  final getPlayerByIdUseCase = _MockGetPlayerByIdUseCase();
  final createAccessJwtUseCase = _MockCreateAccessJwtUseCase();
  final createRefreshJwtCookieUseCase = _MockCreateRefreshJwtCookieUseCase();

  // tested class
  final controller = RefreshTokenController(
    getCookieByNameInRequestUseCase: getCookieByNameInRequestUseCase,
    getRefreshTokenDataFromAccessJwtUseCase:
        getRefreshTokenDataFromAccessJwtUseCase,
    getAuthByIdUseCase: getAuthByIdUseCase,
    getPlayerByIdUseCase: getPlayerByIdUseCase,
    createAccessJwtUseCase: createAccessJwtUseCase,
    createRefreshJwtCookieUseCase: createRefreshJwtCookieUseCase,
  );

  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });

  tearDown(() {
    reset(request);
    reset(getCookieByNameInRequestUseCase);
    reset(getRefreshTokenDataFromAccessJwtUseCase);
    reset(getAuthByIdUseCase);
    reset(getPlayerByIdUseCase);
    reset(createAccessJwtUseCase);
    reset(createRefreshJwtCookieUseCase);
  });

  group("$RefreshTokenController", () {
    group(".call()", () {
      // should return bad request if there is no not a refresh token cookie in cookies
      test(
        "given request with no refresh token cookie"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup

          // given
          when(() => request.headers).thenReturn({});
          when(() => getCookieByNameInRequestUseCase(
                request: any(named: "request"),
                cookieName: any(named: "cookieName"),
              )).thenReturn(null);

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestBadRequestResponse(
              responseMessage: "No cookie found in the request.");
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should return bad request if the token is not valid
      test(
        "given request with invalid token in refresh token cookie"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader:
                Cookie.fromSetCookieValue("refresh_token=invalid_token")
                    .toString(),
          });
          when(() => getCookieByNameInRequestUseCase(
                request: any(named: "request"),
                cookieName: any(named: "cookieName"),
              )).thenReturn(Cookie("refresh_token", "invalid_token"));

          // given
          when(() => getRefreshTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(RefreshTokenDataValueInvalid(
            jwt: "invalid_token",
          ));

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestUnauthorizedResponse(
              responseMessage: "Refresh token invalid.");
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should return bad request if the token is expired
      test(
        "given request with expired token in refresh token cookie"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader:
                Cookie.fromSetCookieValue("refresh_token=expired_token")
                    .toString(),
          });
          when(() => getCookieByNameInRequestUseCase(
                request: any(named: "request"),
                cookieName: any(named: "cookieName"),
              )).thenReturn(Cookie("refresh_token", "expired_token"));

          // given
          when(() => getRefreshTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(RefreshTokenDataValueExpired(
            jwt: "expired_token",
          ));

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestUnauthorizedResponse(
              responseMessage: "Refresh token expired.");
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should return not found if the auth does not exist
      test(
        "given auth does not exist"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader:
                Cookie.fromSetCookieValue("refresh_token=valid_token")
                    .toString(),
          });
          when(() => getCookieByNameInRequestUseCase(
                request: any(named: "request"),
                cookieName: any(named: "cookieName"),
              )).thenReturn(Cookie("refresh_token", "valid_token"));
          when(() => getRefreshTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(RefreshTokenDataValueValid(
            authId: 1,
            playerId: 1,
          ));

          // given
          when(() => getAuthByIdUseCase(id: 1)).thenAnswer((_) async => null);

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestUnauthorizedResponse(
              responseMessage: "Auth not found.");
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should return not found if the player does not exist
      test(
        "given player does not exist"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader:
                Cookie.fromSetCookieValue("refresh_token=valid_token")
                    .toString(),
          });
          when(() => getCookieByNameInRequestUseCase(
                request: any(named: "request"),
                cookieName: any(named: "cookieName"),
              )).thenReturn(Cookie("refresh_token", "valid_token"));
          when(() => getRefreshTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(RefreshTokenDataValueValid(
            authId: 1,
            playerId: 1,
          ));
          when(() => getAuthByIdUseCase(id: 1))
              .thenAnswer((_) async => _testAuthModel);

          // given
          when(() => getPlayerByIdUseCase(id: 1)).thenAnswer((_) async => null);

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestUnauthorizedResponse(
              responseMessage: "Player not found.");
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should return bad request if the player and auth dont match
      test(
        "given player and auth do not match"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader:
                Cookie.fromSetCookieValue("refresh_token=valid_token")
                    .toString(),
          });
          when(() => getCookieByNameInRequestUseCase(
                request: any(named: "request"),
                cookieName: any(named: "cookieName"),
              )).thenReturn(Cookie("refresh_token", "valid_token"));
          when(() => getRefreshTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(RefreshTokenDataValueValid(
            authId: 1,
            playerId: 1,
          ));
          when(() => getAuthByIdUseCase(id: 1))
              .thenAnswer((_) async => _testAuthModel);

          // given
          when(() => getPlayerByIdUseCase(id: 1)).thenAnswer((_) async {
            final player = PlayerModel(
              id: _testPlayerModel.id,
              nickname: _testPlayerModel.nickname,
              name: _testPlayerModel.name,
              authId: 2,
            );
            return player;
          });

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestUnauthorizedResponse(
              responseMessage: "Player and auth do not match.");
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should return ok if everything is correct
      test(
        "given valid request"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(() => getCookieByNameInRequestUseCase(
                request: any(named: "request"),
                cookieName: any(named: "cookieName"),
              )).thenReturn(Cookie("refresh_token", "valid_token"));
          when(() => getRefreshTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(RefreshTokenDataValueValid(
            authId: 1,
            playerId: 1,
          ));
          when(() => getAuthByIdUseCase(id: 1))
              .thenAnswer((_) async => _testAuthModel);
          when(() => getPlayerByIdUseCase(id: 1))
              .thenAnswer((_) async => _testPlayerModel);
          when(() => createAccessJwtUseCase(
                authId: 1,
                playerId: 1,
              )).thenReturn("access_token");

          // given
          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader:
                Cookie.fromSetCookieValue("refresh_token=valid_token")
                    .toString(),
          });

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestOkResponse(
            responseMessage: "Token refreshed successfully.",
            // TODO this is clumsy
            responseData: {},
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      // should include access token in headers if all good
      test(
        "given valid request"
        "when .call() is called"
        "then should return response with expected access token included in headers",
        () async {
          // setup
          final accessToken = "access_token";

          when(() => getCookieByNameInRequestUseCase(
                request: any(named: "request"),
                cookieName: any(named: "cookieName"),
              )).thenReturn(Cookie("refresh_token", "valid_token"));
          when(() => getRefreshTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(RefreshTokenDataValueValid(
            authId: 1,
            playerId: 1,
          ));
          when(() => getAuthByIdUseCase(id: 1))
              .thenAnswer((_) async => _testAuthModel);
          when(() => getPlayerByIdUseCase(id: 1))
              .thenAnswer((_) async => _testPlayerModel);

          // given
          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader:
                Cookie.fromSetCookieValue("refresh_token=valid_token")
                    .toString(),
          });
          when(() => createAccessJwtUseCase(
                authId: 1,
                playerId: 1,
              )).thenReturn(accessToken);

          // when
          final response = await controller(request);

          // then
          final responseAccessToken = response
              .headers[AuthResponseConstants.ACCESS_JWT_HEADER_KEY.value];
          expect(responseAccessToken, equals(accessToken));

          // cleanup
        },
      );

      // should include refresh token in http only cookie if all good
      test(
        "given valid request"
        "when .call() is called"
        "then should return response with expected refresh token included in http only cookie",
        () async {
          // setup
          final refreshTokenCookie = Cookie.fromSetCookieValue(
            "refresh_token=token; HttpOnly; Secure; Path=/",
          );

          when(() => getCookieByNameInRequestUseCase(
                request: any(named: "request"),
                cookieName: any(named: "cookieName"),
              )).thenReturn(Cookie("refresh_token", "valid_token"));
          when(() => getRefreshTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(RefreshTokenDataValueValid(
            authId: 1,
            playerId: 1,
          ));
          when(() => getAuthByIdUseCase(id: 1))
              .thenAnswer((_) async => _testAuthModel);
          when(() => getPlayerByIdUseCase(id: 1))
              .thenAnswer((_) async => _testPlayerModel);
          when(() => createAccessJwtUseCase(
                authId: 1,
                playerId: 1,
              )).thenReturn("accessToken");

          // given
          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader:
                Cookie.fromSetCookieValue("refresh_token=valid_token")
                    .toString(),
          });
          when(() => createRefreshJwtCookieUseCase(
                authId: 1,
                playerId: 1,
              )).thenReturn(refreshTokenCookie);

          // when
          final response = await controller(request);

          // then
          final responseCookies = response.headers[HttpHeaders.setCookieHeader];
          // split by comma
          final cookieStrings = responseCookies!.split(",");
          final cookies = cookieStrings.map((cookieString) {
            return Cookie.fromSetCookieValue(cookieString);
          }).toList();

          expect(cookies, hasLength(1));
          expect(
              cookies.first.toString(), equals(refreshTokenCookie.toString()));

          // cleanup
        },
      );
    });
  });
}

class _MockRequest extends Mock implements Request {}

class _MockGetCookieByNameInRequestUseCase extends Mock
    implements GetCookieByNameInRequestUseCase {}

class _MockGetRefreshTokenDataFromAccessJwtUseCase extends Mock
    implements GetRefreshTokenDataFromAccessJwtUseCase {}

class _MockGetAuthByIdUseCase extends Mock implements GetAuthByIdUseCase {}

class _MockGetPlayerByIdUseCase extends Mock implements GetPlayerByIdUseCase {}

class _MockCreateAccessJwtUseCase extends Mock
    implements CreateAccessJwtUseCase {}

class _MockCreateRefreshJwtCookieUseCase extends Mock
    implements CreateRefreshJwtCookieUseCase {}

class _FakeRequest extends Fake implements Request {}

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
final _testRefreshCookie = Cookie.fromSetCookieValue(
  "refresh_token=token; HttpOnly; Secure; Path=/",
);
