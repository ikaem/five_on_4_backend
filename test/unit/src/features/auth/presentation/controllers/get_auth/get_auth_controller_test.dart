import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import 'package:five_on_4_backend/src/features/auth/presentation/controllers/get_auth/get_auth_controller.dart';
import 'package:five_on_4_backend/src/features/core/domain/models/auth/auth_model.dart';
import 'package:five_on_4_backend/src/features/core/domain/use_cases/get_authorization_bearer_token_from_request/get_authorization_bearer_token_from_request_use_case.dart';
import 'package:five_on_4_backend/src/features/core/domain/use_cases/get_refresh_token_data_from_access_jwt/get_refresh_token_data_from_access_jwt_use_case.dart';
import 'package:five_on_4_backend/src/features/core/domain/values/access_token_data_value.dart';
import 'package:five_on_4_backend/src/features/players/domain/models/player_model.dart';
import 'package:five_on_4_backend/src/features/players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();
  final getAuthorizationBearerTokenFromRequestHeadersUseCase =
      _MockGetAuthorizationBearerTokenFromRequestHeadersUseCase();
  final getAccessTokenDataFromAccessJwtUseCase =
      _MockGetAccessTokenDataFromAccessJwtUseCase();
  final getAuthByIdUseCase = _MockGetAuthByIdUseCase();
  final getPlayerByIdUseCase = _MockGetPlayerByIdUseCase();

  // tested class
  final controller = GetAuthController(
    getAuthorizationBearerTokenFromRequestHeadersUseCase:
        getAuthorizationBearerTokenFromRequestHeadersUseCase,
    getAccessTokenDataFromAccessJwtUseCase:
        getAccessTokenDataFromAccessJwtUseCase,
    getAuthByIdUseCase: getAuthByIdUseCase,
    getPlayerByIdUseCase: getPlayerByIdUseCase,
  );

  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });

  tearDown(() {
    reset(request);
    reset(getAuthorizationBearerTokenFromRequestHeadersUseCase);
    reset(getAccessTokenDataFromAccessJwtUseCase);
    reset(getAuthByIdUseCase);
    reset(getPlayerByIdUseCase);
  });

  group("$GetAuthController", () {
    group(".call()", () {
      // should return expected response if no access token in headers
      test(
        "given request with no access token"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup

          // given
          when(() => request.headers).thenReturn({});
          when(
            () => getAuthorizationBearerTokenFromRequestHeadersUseCase(
              request: any(named: "request"),
            ),
          ).thenReturn(null);

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestUnauthorizedResponse(
            responseMessage: "No access token found in request.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(response.statusCode, equals(expectedResponse.statusCode));
          expect(responseString, equals(expectedResponseString));

          // cleanup
        },
      );

      // should return expected response if access token is invalid
      test(
        "given request with invalid access token"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(
            () => getAuthorizationBearerTokenFromRequestHeadersUseCase(
              request: any(named: "request"),
            ),
          ).thenReturn("invalid_access_token");

          // given
          when(() => request.headers).thenReturn({
            HttpHeaders.authorizationHeader: "Bearer invalid_access_token",
          });
          when(
            () => getAccessTokenDataFromAccessJwtUseCase(
              jwt: "invalid_access_token",
            ),
          ).thenReturn(
              AccessTokenDataValueInvalid(jwt: "invalid_access_token"));

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestUnauthorizedResponse(
            responseMessage: "Invalid access token.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(response.statusCode, equals(expectedResponse.statusCode));
          expect(responseString, equals(expectedResponseString));

          // cleanup
        },
      );

      // should return expected response if access token is expored
      test(
        "given request with expired access token"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(
            () => getAuthorizationBearerTokenFromRequestHeadersUseCase(
              request: any(named: "request"),
            ),
          ).thenReturn("expired_access_token");

          // given
          when(() => request.headers).thenReturn({
            HttpHeaders.authorizationHeader: "Bearer expired_access_token",
          });
          when(
            () => getAccessTokenDataFromAccessJwtUseCase(
              jwt: "expired_access_token",
            ),
          ).thenReturn(
              AccessTokenDataValueExpired(jwt: "expired_access_token"));

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestUnauthorizedResponse(
            responseMessage: "Expired access token.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(response.statusCode, equals(expectedResponse.statusCode));
          expect(responseString, equals(expectedResponseString));

          // cleanup
        },
      );

      // should return expected response if auth does not exist
      test(
        "given auth does not exist"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(
            () => getAuthorizationBearerTokenFromRequestHeadersUseCase(
              request: any(named: "request"),
            ),
          ).thenReturn("valid_access_token");
          when(() => request.headers).thenReturn({
            HttpHeaders.authorizationHeader: "Bearer valid_access_token",
          });
          when(
            () => getAccessTokenDataFromAccessJwtUseCase(
              jwt: "valid_access_token",
            ),
          ).thenReturn(AccessTokenDataValueValid(authId: 1, playerId: 1));

          // given
          when(() => getAuthByIdUseCase(id: 1)).thenAnswer((_) async => null);

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestUnauthorizedResponse(
            responseMessage: "Auth not found.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(response.statusCode, equals(expectedResponse.statusCode));
          expect(responseString, equals(expectedResponseString));

          // cleanup
        },
      );

      // should return expected response if player does not exist
      test(
        "given player does not exist"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(
            () => getAuthorizationBearerTokenFromRequestHeadersUseCase(
              request: any(named: "request"),
            ),
          ).thenReturn("valid_access_token");
          when(() => request.headers).thenReturn({
            HttpHeaders.authorizationHeader: "Bearer valid_access_token",
          });
          when(
            () => getAccessTokenDataFromAccessJwtUseCase(
              jwt: "valid_access_token",
            ),
          ).thenReturn(AccessTokenDataValueValid(authId: 1, playerId: 1));
          when(() => getAuthByIdUseCase(id: 1)).thenAnswer(
            (_) async => _testAuthModel,
          );

          // given
          when(() => getPlayerByIdUseCase(id: 1)).thenAnswer((_) async => null);

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestUnauthorizedResponse(
            responseMessage: "Player not found.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(response.statusCode, equals(expectedResponse.statusCode));
          expect(responseString, equals(expectedResponseString));

          // cleanup
        },
      );

      // should return expected repsonse if player and auth do not match
      test(
        "given player and auth do not match"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(
            () => getAuthorizationBearerTokenFromRequestHeadersUseCase(
              request: any(named: "request"),
            ),
          ).thenReturn("valid_access_token");
          when(() => request.headers).thenReturn({
            HttpHeaders.authorizationHeader: "Bearer valid_access_token",
          });
          when(
            () => getAccessTokenDataFromAccessJwtUseCase(
              jwt: "valid_access_token",
            ),
          ).thenReturn(AccessTokenDataValueValid(authId: 1, playerId: 1));
          when(() => getAuthByIdUseCase(id: 1)).thenAnswer(
            (_) async => _testAuthModel,
          );

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
            responseMessage: "Player and auth do not match.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(response.statusCode, equals(expectedResponse.statusCode));
          expect(responseString, equals(expectedResponseString));

          // cleanup
        },
      );

      // should return expected response if everything is correct
      test(
        "given valid request"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(
            () => getAuthorizationBearerTokenFromRequestHeadersUseCase(
              request: any(named: "request"),
            ),
          ).thenReturn("valid_access_token");
          when(
            () => getAccessTokenDataFromAccessJwtUseCase(
              jwt: "valid_access_token",
            ),
          ).thenReturn(AccessTokenDataValueValid(authId: 1, playerId: 1));
          when(() => getAuthByIdUseCase(id: 1)).thenAnswer(
            (_) async => _testAuthModel,
          );
          when(() => getPlayerByIdUseCase(id: 1)).thenAnswer(
            (_) async => _testPlayerModel,
          );

          // given
          when(() => request.headers).thenReturn({
            HttpHeaders.authorizationHeader: "Bearer valid_access_token",
          });

          // when
          final response = await controller(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestOkResponse(
            responseData: {
              "id": _testPlayerModel.id,
              "name": _testPlayerModel.name,
              "nickname": _testPlayerModel.nickname,
            },
            responseMessage: "User authentication retrieved successfully.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(response.statusCode, equals(expectedResponse.statusCode));
          expect(responseString, equals(expectedResponseString));

          // cleanup
        },
      );
    });
  });
}

class _MockRequest extends Mock implements Request {}

class _MockGetAuthorizationBearerTokenFromRequestHeadersUseCase extends Mock
    implements GetAuthorizationBearerTokenFromRequestHeadersUseCase {}

class _MockGetAccessTokenDataFromAccessJwtUseCase extends Mock
    implements GetAccessTokenDataFromAccessJwtUseCase {}

class _MockGetAuthByIdUseCase extends Mock implements GetAuthByIdUseCase {}

class _MockGetPlayerByIdUseCase extends Mock implements GetPlayerByIdUseCase {}

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
