import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../../../../../bin/src/features/auth/utils/middlewares/authorization_middleware.dart';
import '../../../../../../../bin/src/features/core/domain/models/auth/auth_model.dart';
import '../../../../../../../bin/src/features/core/domain/use_cases/get_access_token_data_from_access_jwt/get_access_token_data_from_access_jwt_use_case.dart';
import '../../../../../../../bin/src/features/core/domain/use_cases/get_cookie_by_name_in_string/get_cookie_by_name_in_string_use_case.dart';
import '../../../../../../../bin/src/features/core/domain/values/access_token_data_value.dart';
import '../../../../../../../bin/src/features/players/domain/models/player_model.dart';
import '../../../../../../../bin/src/features/players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../../../../../../../bin/src/server.dart';

void main() {
  final request = _MockRequest();
  final getPlayerByIdUseCase = _MockGetPlayerByIdUseCase();
  final getAuthByIdUseCase = _MockGetAuthByIdUseCase();
  final getCookieByNameInStringUseCase = _MockGetCookieByNameInStringUseCase();
  final getAccessTokenDataFromAccessJwtUseCase =
      _MockGetAccessTokenDataFromAccessJwtUseCase();

// tested class
  final authorizationMiddleware = AuthorizationMiddleware(
    getAccessTokenDataFromAccessJwtUseCase:
        getAccessTokenDataFromAccessJwtUseCase,
    getAuthByIdUseCase: getAuthByIdUseCase,
    getCookieByNameInStringUseCase: getCookieByNameInStringUseCase,
    getPlayerByIdUseCase: getPlayerByIdUseCase,
  );

  tearDown(() {
    reset(request);
    reset(getPlayerByIdUseCase);
    reset(getAuthByIdUseCase);
    reset(getCookieByNameInStringUseCase);
    reset(getAccessTokenDataFromAccessJwtUseCase);
  });

  group("$AuthorizationMiddleware", () {
    group(".call()", () {
      final validResponse = Response.ok("ok");

      test(
        "given a request without cookies "
        "when .call() is called "
        "then should return expected response",
        () async {
          // setup

          // given
          when(() => request.headers).thenReturn({});

          // when
          final requestHandler = _createTestRequestHandlerWidthMiddleware(
            middleware: authorizationMiddleware.call(),
            validResponse: validResponse,
          );
          final response = await requestHandler(request);

          // then
          final expectedResponse = _generateTestBadRequestResponse(
            responseMessage: "No cookies found in request.",
          );
          final responseString = await response.readAsString();

          expect(
            responseString,
            equals(await expectedResponse.readAsString()),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));
        },
      );

      test(
        "given no accessToken cookie in request"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader: "some_cookie=some_cookie_value",
          });

          // given
          when(() => getCookieByNameInStringUseCase(
                cookieName: any(named: "cookieName"),
                cookiesString: any(named: "cookiesString"),
              )).thenReturn(null);

          // when
          final requestHandler = _createTestRequestHandlerWidthMiddleware(
            middleware: authorizationMiddleware.call(),
            validResponse: validResponse,
          );
          final response = await requestHandler(request);

          // then
          final expectedResponse = _generateTestBadRequestResponse(
            responseMessage: "No accessToken cookie found in request.",
          );
          final responseString = await response.readAsString();

          expect(
            responseString,
            equals(await expectedResponse.readAsString()),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given an invalid jwt token in accessToken cookie"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          final cookie = _generateTestCookie(
            name: "accessToken",
            value: "invalid_access_token",
          );
          final invalidAccessTokenDataResponse = AccessTokenDataValueInvalid(
            jwt: cookie.value,
          );

          // stub setup
          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader: cookie.toString(),
          });

          when(
            () => getCookieByNameInStringUseCase(
              cookieName: any(named: "cookieName"),
              cookiesString: any(named: "cookiesString"),
            ),
          ).thenReturn(cookie);

          // given
          when(() => getAccessTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(
            invalidAccessTokenDataResponse,
          );

          // when
          final requestHandler = _createTestRequestHandlerWidthMiddleware(
            middleware: authorizationMiddleware.call(),
            validResponse: validResponse,
          );
          final response = await requestHandler(request);

          // then
          final expectedResponse = _generateTestBadRequestResponse(
            responseMessage: "Invalid auth token in cookie.",
          );
          final responseString = await response.readAsString();

          expect(
            responseString,
            equals(await expectedResponse.readAsString()),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given an expired jwt token in accessToken cookie"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          final cookie = _generateTestCookie(
            name: "accessToken",
            value: "expired_access_token",
          );
          final expiredAccessTokenDataResponse = AccessTokenDataValueExpired(
            jwt: cookie.value,
          );

          // stub setup
          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader: cookie.toString(),
          });

          when(
            () => getCookieByNameInStringUseCase(
              cookieName: any(named: "cookieName"),
              cookiesString: any(named: "cookiesString"),
            ),
          ).thenReturn(cookie);

          // given
          when(() => getAccessTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(
            expiredAccessTokenDataResponse,
          );

          // when
          final requestHandler = _createTestRequestHandlerWidthMiddleware(
            middleware: authorizationMiddleware.call(),
            validResponse: validResponse,
          );
          final response = await requestHandler(request);

          // then
          final expectedResponse = _generateTestBadRequestResponse(
            responseMessage: "Expired auth token in cookie.",
          );
          final responseString = await response.readAsString();

          expect(
            responseString,
            equals(await expectedResponse.readAsString()),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given invalid authId in access token"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          final cookie = _generateTestCookie(
            name: "accessToken",
            value: "valid_access_token",
          );
          final validAccessTokenDataResponse = AccessTokenDataValueValid(
            authId: 1,
            playerId: 1,
          );

          // stub setup
          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader: cookie.toString(),
          });

          when(
            () => getCookieByNameInStringUseCase(
              cookieName: any(named: "cookieName"),
              cookiesString: any(named: "cookiesString"),
            ),
          ).thenReturn(cookie);

          when(() => getAccessTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(
            validAccessTokenDataResponse,
          );
          // given
          when(() => getAuthByIdUseCase(id: any(named: "id")))
              .thenAnswer((_) async => null);

          // when
          final requestHandler = _createTestRequestHandlerWidthMiddleware(
            middleware: authorizationMiddleware.call(),
            validResponse: validResponse,
          );
          final response = await requestHandler(request);

          // then
          final expectedResponse = _generateTestNonExistentResponse(
            responseMessage: "Auth not found.",
          );
          final responseString = await response.readAsString();

          expect(
            responseString,
            equals(await expectedResponse.readAsString()),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given invalid playerId in access token"
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          final cookie = _generateTestCookie(
            name: "accessToken",
            value: "valid_access_token",
          );
          final validAccessTokenDataResponse = AccessTokenDataValueValid(
            authId: 1,
            playerId: 1,
          );

          // stub setup
          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader: cookie.toString(),
          });

          when(
            () => getCookieByNameInStringUseCase(
              cookieName: any(named: "cookieName"),
              cookiesString: any(named: "cookiesString"),
            ),
          ).thenReturn(cookie);

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
          final requestHandler = _createTestRequestHandlerWidthMiddleware(
            middleware: authorizationMiddleware.call(),
            validResponse: validResponse,
          );
          final response = await requestHandler(request);

          // then
          final expectedResponse = _generateTestNonExistentResponse(
            responseMessage: "Player not found.",
          );
          final responseString = await response.readAsString();

          expect(
            responseString,
            equals(await expectedResponse.readAsString()),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

          // cleanup
        },
      );

      test(
        "given found player does not match found auth id "
        "when .call() is called"
        "then should return expected response",
        () async {
          // setup
          final cookie = _generateTestCookie(
            name: "accessToken",
            value: "valid_access_token",
          );
          final validAccessTokenDataResponse = AccessTokenDataValueValid(
            authId: 1,
            playerId: 1,
          );

          // stup setup
          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader: cookie.toString(),
          });

          when(
            () => getCookieByNameInStringUseCase(
              cookieName: any(named: "cookieName"),
              cookiesString: any(named: "cookiesString"),
            ),
          ).thenReturn(cookie);

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
          final requestHandler = _createTestRequestHandlerWidthMiddleware(
            middleware: authorizationMiddleware.call(),
            validResponse: validResponse,
          );
          final response = await requestHandler(request);

          // then
          final expectedResponse = _generateTestBadRequestResponse(
            responseMessage: "Found player does not match auth id.",
          );
          final responseString = await response.readAsString();

          expect(
            responseString,
            equals(await expectedResponse.readAsString()),
          );
          expect(response.statusCode, equals(expectedResponse.statusCode));

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

class _MockGetCookieByNameInStringUseCase extends Mock
    implements GetCookieByNameInStringUseCase {}

class _MockRequest extends Mock implements Request {}

// helpers
Response _generateTestBadRequestResponse({
  required String responseMessage,
}) {
  return Response.badRequest(
    body: jsonEncode(
      {
        "ok": false,
        "message": "Invalid request - $responseMessage.",
      },
    ),
    headers: {
      "Content-Type": "application/json",
    },
  );
}

Response _generateTestNonExistentResponse({
  required String responseMessage,
}) {
  return Response.notFound(
    jsonEncode(
      {
        "ok": false,
        "message": "Resource not found - $responseMessage.",
      },
    ),
    headers: {
      "Content-Type": "application/json",
    },
  );
}

FutureOr<Response> Function(Request) _createTestRequestHandlerWidthMiddleware({
  required Middleware middleware,
  required Response validResponse,
}) {
  final handler = Pipeline().addMiddleware(middleware).addHandler(
    (request) {
      return validResponse;
    },
  );

  return handler;
}

Cookie _generateTestCookie({required String name, required String value}) {
  return Cookie(name, value);
}

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
