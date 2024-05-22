import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../../../../../bin/src/features/auth/utils/validators/authorize_request_validator.dart';
import '../../../../../../../bin/src/features/core/domain/models/auth/auth_model.dart';
import '../../../../../../../bin/src/features/core/domain/use_cases/get_authorization_bearer_token_from_request/get_authorization_bearer_token_from_request_use_case.dart';
import '../../../../../../../bin/src/features/core/domain/use_cases/get_refresh_token_data_from_access_jwt/get_refresh_token_data_from_access_jwt_use_case.dart';
import '../../../../../../../bin/src/features/core/domain/values/access_token_data_value.dart';
import '../../../../../../../bin/src/features/players/domain/models/player_model.dart';
import '../../../../../../../bin/src/features/players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();
  final getAccessTokenDataFromAccessJwtUseCase =
      _MockGetAccessTokenDataFromAccessJwtUseCase();
  final getPlayerByIdUseCase = _MockGetPlayerByIdUseCase();
  final getAuthByIdUseCase = _MockGetAuthByIdUseCase();
  final getAuthorizationBearerTokenFromRequestHeadersUseCase =
      _MockGetAuthorizationBearerTokenFromRequestHeadersUseCase();
  final validatedRequestHandler = _MockValidatedRequestHandlderWrapper();

  // tested class
  final requestAuthorizationValidator = AuthorizeRequestValidator(
    getAuthorizationBearerTokenFromRequestHeadersUseCase:
        getAuthorizationBearerTokenFromRequestHeadersUseCase,
    getAccessTokenDataFromAccessJwtUseCase:
        getAccessTokenDataFromAccessJwtUseCase,
    getPlayerByIdUseCase: getPlayerByIdUseCase,
    getAuthByIdUseCase: getAuthByIdUseCase,
  );

  setUp(() {
    registerFallbackValue(_FakeRequest());
  });

  tearDown(() {
    reset(getAccessTokenDataFromAccessJwtUseCase);
    reset(getPlayerByIdUseCase);
    reset(getAuthByIdUseCase);
    reset(validatedRequestHandler);
    reset(request);
    reset(getAuthorizationBearerTokenFromRequestHeadersUseCase);
  });

  group("$AuthorizeRequestValidator", () {
    group(".validate()", () {
      test(
        "given a request without access token in header"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          when(() => getAuthorizationBearerTokenFromRequestHeadersUseCase(
                // headers: any(named: "headers"),
                request: any(named: "request"),
              )).thenReturn(null);

          // given
          when(() => request.headers).thenReturn({});

          // when
          final response = await requestAuthorizationValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestUnauthorizedResponse(
            responseMessage: "No access token found in request.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given invalid jwt token in authorization header"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final invalidAccessToken = "invalid_access_token";
          when(() => getAuthorizationBearerTokenFromRequestHeadersUseCase(
                // headers: any(named: "headers"),
                request: any(named: "request"),
              )).thenReturn(invalidAccessToken);
          when(() => request.headers).thenReturn({
            HttpHeaders.authorizationHeader: invalidAccessToken,
          });

          // given
          final invalidAccessTokenDataResponse = AccessTokenDataValueInvalid(
            jwt: invalidAccessToken,
          );
          when(() => getAccessTokenDataFromAccessJwtUseCase(
              jwt: any(named: "jwt"))).thenReturn(
            invalidAccessTokenDataResponse,
          );

          // when
          final response = await requestAuthorizationValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestUnauthorizedResponse(
            responseMessage: "Invalid auth token in header.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given expired jwt token in authorization header"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final expiredAccessToken = "expired_access_token";
          when(() => getAuthorizationBearerTokenFromRequestHeadersUseCase(
                // headers: any(named: "headers"),
                request: any(named: "request"),
              )).thenReturn(expiredAccessToken);
          when(() => request.headers).thenReturn({
            HttpHeaders.authorizationHeader: expiredAccessToken,
          });

          // given
          final expiredAccessTokenDataResponse = AccessTokenDataValueExpired(
            jwt: expiredAccessToken,
          );
          when(() => getAccessTokenDataFromAccessJwtUseCase(
              jwt: any(named: "jwt"))).thenReturn(
            expiredAccessTokenDataResponse,
          );

          // when
          final response = await requestAuthorizationValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestUnauthorizedResponse(
            responseMessage: "Expired auth token in header.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given invalid authId in access token payload"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final validAccessToken = "valid_access_token";
          final validAccessTokenDataResponse = AccessTokenDataValueValid(
            authId: 1,
            playerId: 1,
          );

          when(() => getAuthorizationBearerTokenFromRequestHeadersUseCase(
                // headers: any(named: "headers"),
                request: any(named: "request"),
              )).thenReturn(validAccessToken);
          when(() => request.headers).thenReturn({
            HttpHeaders.authorizationHeader: validAccessToken,
          });
          when(() => getAccessTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(
            validAccessTokenDataResponse,
          );

          // given
          when(() => getAuthByIdUseCase(id: any(named: "id")))
              .thenAnswer((_) async => null);

          // when
          final response = await requestAuthorizationValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestUnauthorizedResponse(
            responseMessage: "Auth not found.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));
          // cleanup
        },
      );

      test(
        "given invalid playerId in access token payload"
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final validAccessToken = "valid_access_token";
          final validAccessTokenDataResponse = AccessTokenDataValueValid(
            authId: 1,
            playerId: 1,
          );

          when(() => getAuthorizationBearerTokenFromRequestHeadersUseCase(
                // headers: any(named: "headers"),
                request: any(named: "request"),
              )).thenReturn(validAccessToken);
          when(() => request.headers).thenReturn({
            HttpHeaders.authorizationHeader: validAccessToken,
          });
          when(() => getAccessTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(
            validAccessTokenDataResponse,
          );
          when(() => getAuthByIdUseCase(id: any(named: "id")))
              .thenAnswer((_) async => _testAuthModel);

          // given
          when(() => getPlayerByIdUseCase(id: any(named: "id")))
              .thenAnswer((_) async => null);

          // when
          final response = await requestAuthorizationValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestUnauthorizedResponse(
            responseMessage: "Player not found.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given found player does not match found auth id "
        "when .validate() is called"
        "then should return expected response",
        () async {
          // setup
          final validAccessToken = "valid_access_token";
          final validAccessTokenDataResponse = AccessTokenDataValueValid(
            authId: 1,
            playerId: 1,
          );

          when(() => getAuthorizationBearerTokenFromRequestHeadersUseCase(
                // headers: any(named: "headers"),
                request: any(named: "request"),
              )).thenReturn(validAccessToken);
          when(() => request.headers).thenReturn({
            HttpHeaders.authorizationHeader: validAccessToken,
          });
          when(() => getAccessTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(
            validAccessTokenDataResponse,
          );
          when(() => getAuthByIdUseCase(id: any(named: "id")))
              .thenAnswer((_) async => _testAuthModel);

          // given
          when(() => getPlayerByIdUseCase(id: any(named: "id")))
              .thenAnswer((_) async {
            final foundPlayer = PlayerModel(
              id: _testPlayerModel.id,
              name: _testPlayerModel.name,
              nickname: _testPlayerModel.nickname,
              authId: 2,
            );
            return foundPlayer;
          });

          // when
          final response = await requestAuthorizationValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);
          final responseString = await response.readAsString();

          // then
          final expectedResponse = generateTestUnauthorizedResponse(
            responseMessage: "Found player does not match auth id.",
          );
          final expectedResponseString = await expectedResponse.readAsString();

          expect(responseString, equals(expectedResponseString));
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given a valid request"
        "when .validate() is called"
        "then should return result of call to validatedRequestHandler",
        () async {
          // setup
          final validAccessToken = "valid_access_token";
          final validAccessTokenDataResponse = AccessTokenDataValueValid(
            authId: 1,
            playerId: 1,
          );

          when(() => getAuthorizationBearerTokenFromRequestHeadersUseCase(
                // headers: any(named: "headers"),
                request: any(named: "request"),
              )).thenReturn(validAccessToken);
          when(() => getAccessTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(
            validAccessTokenDataResponse,
          );
          when(() => getAuthByIdUseCase(id: any(named: "id")))
              .thenAnswer((_) async => _testAuthModel);
          when(() => getPlayerByIdUseCase(id: any(named: "id")))
              .thenAnswer((_) async => _testPlayerModel);

          // given
          final validatedRequestHandlerResponse = Response.ok("ok");
          when(() => validatedRequestHandler.call(any()))
              .thenAnswer((_) async => validatedRequestHandlerResponse);
          when(() => request.headers).thenReturn({
            HttpHeaders.authorizationHeader: validAccessToken,
          });

          // when
          final response = await requestAuthorizationValidator.validate(
            validatedRequestHandler: validatedRequestHandler.call,
          )(request);

          // then
          verify(() => validatedRequestHandler.call(request));
          expect(response, equals(validatedRequestHandlerResponse));

          // cleanup
        },
      );
    });
  });
}

class _MockGetPlayerByIdUseCase extends Mock implements GetPlayerByIdUseCase {}

class _MockGetAuthByIdUseCase extends Mock implements GetAuthByIdUseCase {}

class _MockGetAccessTokenDataFromAccessJwtUseCase extends Mock
    implements GetAccessTokenDataFromAccessJwtUseCase {}

class _MockGetAuthorizationBearerTokenFromRequestHeadersUseCase extends Mock
    implements GetAuthorizationBearerTokenFromRequestHeadersUseCase {}

class _MockRequest extends Mock implements Request {}

class _MockValidatedRequestHandlderWrapper extends Mock {
  Future<Response> call(Request request);
}

class _FakeRequest extends Fake implements Request {}

// helpers
final _testAuthModel = AuthModel(
  id: 1,
  email: "email",
  createdAt: DateTime.now().millisecondsSinceEpoch,
  updatedAt: DateTime.now().millisecondsSinceEpoch,
);

final _testPlayerModel = PlayerModel(
  id: 1,
  name: "name",
  nickname: "nickname",
  authId: 1,
);
