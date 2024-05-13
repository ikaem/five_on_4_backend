import 'dart:convert';
import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../../../../../bin/src/features/auth/utils/validators/authorize_request_validator.dart';
import '../../../../../../../bin/src/features/core/domain/models/auth/auth_model.dart';
import '../../../../../../../bin/src/features/core/domain/use_cases/get_access_token_data_from_access_jwt/get_access_token_data_from_access_jwt_use_case.dart';
import '../../../../../../../bin/src/features/core/domain/use_cases/get_cookie_by_name_in_string/get_cookie_by_name_in_string_use_case.dart';
import '../../../../../../../bin/src/features/core/domain/values/access_token_data_value.dart';
import '../../../../../../../bin/src/features/players/domain/models/player_model.dart';
import '../../../../../../../bin/src/features/players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../../../../../../helpers/response.dart';

void main() {
  final request = _MockRequest();
  final getCookieByNameInStringUseCase = _MockGetCookieByNameInStringUseCase();
  final getAccessTokenDataFromAccessJwtUseCase =
      _MockGetAccessTokenDataFromAccessJwtUseCase();
  final getPlayerByIdUseCase = _MockGetPlayerByIdUseCase();
  final getAuthByIdUseCase = _MockGetAuthByIdUseCase();
  final validatedRequestHandler = _MockValidatedRequestHandlderWrapper();

  // tested class
  final requestAuthorizationValidator = AuthorizeRequestValidator(
    getCookieByNameInStringUseCase: getCookieByNameInStringUseCase,
    getAccessTokenDataFromAccessJwtUseCase:
        getAccessTokenDataFromAccessJwtUseCase,
    getPlayerByIdUseCase: getPlayerByIdUseCase,
    getAuthByIdUseCase: getAuthByIdUseCase,
  );

  setUp(() {
    registerFallbackValue(_FakeRequest());
  });

  tearDown(() {
    reset(getCookieByNameInStringUseCase);
    reset(getAccessTokenDataFromAccessJwtUseCase);
    reset(getPlayerByIdUseCase);
    reset(getAuthByIdUseCase);
    reset(validatedRequestHandler);
  });

  group("$AuthorizeRequestValidator", () {
    group(".validate()", () {
      // final validResponse = Response.ok("ok");

      // test(
      //   "given a request without cookies "
      //   "when .validate() is called "
      //   "then should return expected response",
      //   () async {
      //     // setup

      //     // given
      //     when(() => request.headers).thenReturn({});

      //     // when
      //     final response = await requestAuthorizationValidator.validate(
      //       validatedRequestHandler: validatedRequestHandler.call,
      //     )(request);

      //     // then

      //     // final expectedResponse = _generateTestBadRequestResponse(
      //     //   responseMessage: "No cookies found in request.",
      //     // );
      //     final expectedResponse = generateTestBadRequestResponse(
      //       responseMessage: "No cookies found in request.",
      //       cookies: null,
      //     );
      //     final responseString = await response.readAsString();

      //     expect(
      //       responseString,
      //       equals(await expectedResponse.readAsString()),
      //     );
      //     expect(response.statusCode, equals(expectedResponse.statusCode));
      //     // TODO cookie should be tested - it should not always be null - or maybe it should - after all, we control it
      //   },
      // );

      // test(
      //   "given no accessToken cookie in request"
      //   "when .validate() is called"
      //   "then should return expected response",
      //   () async {
      //     // setup
      //     when(() => request.headers).thenReturn({
      //       HttpHeaders.cookieHeader: "some_cookie=some_cookie_value",
      //     });

      //     // given
      //     when(() => getCookieByNameInStringUseCase(
      //           cookieName: any(named: "cookieName"),
      //           cookiesString: any(named: "cookiesString"),
      //         )).thenReturn(null);

      //     // when
      //     final response = await requestAuthorizationValidator.validate(
      //       validatedRequestHandler: validatedRequestHandler.call,
      //     )(request);

      //     // then
      //     // final expectedResponse = _generateTestBadRequestResponse(
      //     //   responseMessage: "No accessToken cookie found in request.",
      //     // );
      //     final expectedResponse = generateTestBadRequestResponse(
      //       responseMessage: "No accessToken cookie found in request.",
      //       cookies: null,
      //     );
      //     final responseString = await response.readAsString();

      //     expect(
      //       responseString,
      //       equals(await expectedResponse.readAsString()),
      //     );
      //     expect(response.statusCode, equals(expectedResponse.statusCode));
      //   },
      // );

      // test(
      //   "given an invalid jwt token in accessToken cookie"
      //   "when .call() is called"
      //   "then should return expected response",
      //   () async {
      //     // setup
      //     final cookie = _generateTestCookie(
      //       name: "accessToken",
      //       value: "invalid_access_token",
      //     );
      //     final invalidAccessTokenDataResponse = AccessTokenDataValueInvalid(
      //       jwt: cookie.value,
      //     );

      //     // stub setup
      //     when(() => request.headers).thenReturn({
      //       HttpHeaders.cookieHeader: cookie.toString(),
      //     });

      //     when(
      //       () => getCookieByNameInStringUseCase(
      //         cookieName: any(named: "cookieName"),
      //         cookiesString: any(named: "cookiesString"),
      //       ),
      //     ).thenReturn(cookie);

      //     // given
      //     when(() => getAccessTokenDataFromAccessJwtUseCase(
      //           jwt: any(named: "jwt"),
      //         )).thenReturn(
      //       invalidAccessTokenDataResponse,
      //     );

      //     final response = await requestAuthorizationValidator.validate(
      //       validatedRequestHandler: validatedRequestHandler.call,
      //     )(request);

      //     // then
      //     // final expectedResponse = _generateTestBadRequestResponse(
      //     //   responseMessage: "Invalid auth token in cookie.",
      //     // );
      //     final expectedResponse = generateTestBadRequestResponse(
      //       responseMessage: "Invalid auth token in cookie.",
      //       cookies: null,
      //     );
      //     final responseString = await response.readAsString();

      //     expect(
      //       responseString,
      //       equals(await expectedResponse.readAsString()),
      //     );
      //     expect(response.statusCode, equals(expectedResponse.statusCode));
      //   },
      // );

      // test(
      //   "given an expired jwt token in accessToken cookie"
      //   "when .call() is called"
      //   "then should return expected response",
      //   () async {
      //     // setup
      //     final cookie = _generateTestCookie(
      //       name: "accessToken",
      //       value: "expired_access_token",
      //     );
      //     final expiredAccessTokenDataResponse = AccessTokenDataValueExpired(
      //       jwt: cookie.value,
      //     );

      //     // stub setup
      //     when(() => request.headers).thenReturn({
      //       HttpHeaders.cookieHeader: cookie.toString(),
      //     });

      //     when(
      //       () => getCookieByNameInStringUseCase(
      //         cookieName: any(named: "cookieName"),
      //         cookiesString: any(named: "cookiesString"),
      //       ),
      //     ).thenReturn(cookie);

      //     // given
      //     when(() => getAccessTokenDataFromAccessJwtUseCase(
      //           jwt: any(named: "jwt"),
      //         )).thenReturn(
      //       expiredAccessTokenDataResponse,
      //     );

      //     // when
      //     final response = await requestAuthorizationValidator.validate(
      //       validatedRequestHandler: validatedRequestHandler.call,
      //     )(request);

      //     // then
      //     // final expectedResponse = _generateTestBadRequestResponse(
      //     //   responseMessage: "Expired auth token in cookie.",
      //     // );
      //     final expectedResponse = generateTestBadRequestResponse(
      //       responseMessage: "Expired auth token in cookie.",
      //       cookies: null,
      //     );
      //     final responseString = await response.readAsString();

      //     expect(
      //       responseString,
      //       equals(await expectedResponse.readAsString()),
      //     );
      //     expect(response.statusCode, equals(expectedResponse.statusCode));

      //     // cleanup
      //   },
      // );

      // test(
      //   "given invalid authId in access token"
      //   "when .call() is called"
      //   "then should return expected response",
      //   () async {
      //     // setup
      //     final cookie = _generateTestCookie(
      //       name: "accessToken",
      //       value: "valid_access_token",
      //     );
      //     final validAccessTokenDataResponse = AccessTokenDataValueValid(
      //       authId: 1,
      //       playerId: 1,
      //     );

      //     // stub setup
      //     when(() => request.headers).thenReturn({
      //       HttpHeaders.cookieHeader: cookie.toString(),
      //     });

      //     when(
      //       () => getCookieByNameInStringUseCase(
      //         cookieName: any(named: "cookieName"),
      //         cookiesString: any(named: "cookiesString"),
      //       ),
      //     ).thenReturn(cookie);

      //     when(() => getAccessTokenDataFromAccessJwtUseCase(
      //           jwt: any(named: "jwt"),
      //         )).thenReturn(
      //       validAccessTokenDataResponse,
      //     );
      //     // given
      //     when(() => getAuthByIdUseCase(id: any(named: "id")))
      //         .thenAnswer((_) async => null);

      //     final response = await requestAuthorizationValidator.validate(
      //       validatedRequestHandler: validatedRequestHandler.call,
      //     )(request);

      //     // then
      //     // final expectedResponse = _generateTestNonExistentResponse(
      //     //   responseMessage: "Auth not found.",
      //     // );
      //     final expectedResponse = generateTestNotFoundResponse(
      //       responseMessage: "Auth not found.",
      //       cookies: null,
      //     );
      //     final responseString = await response.readAsString();

      //     expect(
      //       responseString,
      //       equals(await expectedResponse.readAsString()),
      //     );
      //     expect(response.statusCode, equals(expectedResponse.statusCode));

      //     // cleanup
      //   },
      // );

      // test(
      //   "given invalid playerId in access token"
      //   "when .call() is called"
      //   "then should return expected response",
      //   () async {
      //     // setup
      //     final cookie = _generateTestCookie(
      //       name: "accessToken",
      //       value: "valid_access_token",
      //     );
      //     final validAccessTokenDataResponse = AccessTokenDataValueValid(
      //       authId: 1,
      //       playerId: 1,
      //     );

      //     // stub setup
      //     when(() => request.headers).thenReturn({
      //       HttpHeaders.cookieHeader: cookie.toString(),
      //     });

      //     when(
      //       () => getCookieByNameInStringUseCase(
      //         cookieName: any(named: "cookieName"),
      //         cookiesString: any(named: "cookiesString"),
      //       ),
      //     ).thenReturn(cookie);

      //     when(() => getAccessTokenDataFromAccessJwtUseCase(
      //           jwt: any(named: "jwt"),
      //         )).thenReturn(
      //       validAccessTokenDataResponse,
      //     );

      //     when(() => getAuthByIdUseCase(id: any(named: "id")))
      //         .thenAnswer((_) async => _testAuthModel);

      //     // given
      //     when(() => getPlayerByIdUseCase(id: any(named: "id")))
      //         .thenAnswer((_) async => null);

      //     final response = await requestAuthorizationValidator.validate(
      //       validatedRequestHandler: validatedRequestHandler.call,
      //     )(request);

      //     // then
      //     // final expectedResponse = _generateTestNonExistentResponse(
      //     //   responseMessage: "Player not found.",
      //     // );
      //     final expectedResponse = generateTestNotFoundResponse(
      //       responseMessage: "Player not found.",
      //       cookies: null,
      //     );
      //     final responseString = await response.readAsString();

      //     expect(
      //       responseString,
      //       equals(await expectedResponse.readAsString()),
      //     );
      //     expect(response.statusCode, equals(expectedResponse.statusCode));

      //     // cleanup
      //   },
      // );

      // test(
      //   "given found player does not match found auth id "
      //   "when .call() is called"
      //   "then should return expected response",
      //   () async {
      //     // setup
      //     final cookie = _generateTestCookie(
      //       name: "accessToken",
      //       value: "valid_access_token",
      //     );
      //     final validAccessTokenDataResponse = AccessTokenDataValueValid(
      //       authId: 1,
      //       playerId: 1,
      //     );

      //     // stup setup
      //     when(() => request.headers).thenReturn({
      //       HttpHeaders.cookieHeader: cookie.toString(),
      //     });

      //     when(
      //       () => getCookieByNameInStringUseCase(
      //         cookieName: any(named: "cookieName"),
      //         cookiesString: any(named: "cookiesString"),
      //       ),
      //     ).thenReturn(cookie);

      //     when(() => getAccessTokenDataFromAccessJwtUseCase(
      //           jwt: any(named: "jwt"),
      //         )).thenReturn(
      //       validAccessTokenDataResponse,
      //     );

      //     when(() => getAuthByIdUseCase(id: any(named: "id")))
      //         .thenAnswer((_) async => _testAuthModel);

      //     // given
      //     when(() => getPlayerByIdUseCase(id: any(named: "id")))
      //         .thenAnswer((_) async {
      //       final foundPlayer = PlayerModel(
      //         id: _testPlayerModel.id,
      //         name: _testPlayerModel.name,
      //         nickname: _testPlayerModel.nickname,
      //         authId: 2,
      //       );
      //       return foundPlayer;
      //     });

      //     // when
      //     final response = await requestAuthorizationValidator.validate(
      //       validatedRequestHandler: validatedRequestHandler.call,
      //     )(request);

      //     // then
      //     // final expectedResponse = _generateTestBadRequestResponse(
      //     //   responseMessage: "Found player does not match auth id.",
      //     // );
      //     final expectedResponse = generateTestBadRequestResponse(
      //       responseMessage: "Found player does not match auth id.",
      //       cookies: null,
      //     );
      //     final responseString = await response.readAsString();

      //     expect(
      //       responseString,
      //       equals(await expectedResponse.readAsString()),
      //     );
      //     expect(response.statusCode, equals(expectedResponse.statusCode));

      //     // cleanup
      //   },
      // );

      // test(
      //   "given a valid request"
      //   "when .call() is called"
      //   "then should return result of call to validatedRequestHandler",
      //   () async {
      //     // setup
      //     final cookie = _generateTestCookie(
      //       name: "accessToken",
      //       value: "valid_access_token",
      //     );
      //     final validAccessTokenDataResponse = AccessTokenDataValueValid(
      //       authId: 1,
      //       playerId: 1,
      //     );

      //     final validatedRequestHandlerResponse = Response.ok("ok");

      //     // stup setup
      //     when(() => request.headers).thenReturn({
      //       HttpHeaders.cookieHeader: cookie.toString(),
      //     });

      //     when(
      //       () => getCookieByNameInStringUseCase(
      //         cookieName: any(named: "cookieName"),
      //         cookiesString: any(named: "cookiesString"),
      //       ),
      //     ).thenReturn(cookie);

      //     when(() => getAccessTokenDataFromAccessJwtUseCase(
      //           jwt: any(named: "jwt"),
      //         )).thenReturn(
      //       validAccessTokenDataResponse,
      //     );

      //     when(() => getAuthByIdUseCase(id: any(named: "id")))
      //         .thenAnswer((_) async => _testAuthModel);

      //     when(() => getPlayerByIdUseCase(id: any(named: "id")))
      //         .thenAnswer((_) async => _testPlayerModel);

      //     when(() => validatedRequestHandler.call(any()))
      //         .thenAnswer((_) async => validatedRequestHandlerResponse);

      //     // given

      //     // when
      //     final response = await requestAuthorizationValidator.validate(
      //       validatedRequestHandler: validatedRequestHandler.call,
      //     )(request);

      //     // then
      //     verify(() => validatedRequestHandler.call(request));
      //     expect(response, equals(validatedRequestHandlerResponse));

      //     // cleanup
      //   },
      // );
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

class _MockValidatedRequestHandlderWrapper extends Mock {
  // FutureOr<Response?> call(Request request);
  Future<Response> call(Request request);
}

class _FakeRequest extends Fake implements Request {}

// helpers
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
