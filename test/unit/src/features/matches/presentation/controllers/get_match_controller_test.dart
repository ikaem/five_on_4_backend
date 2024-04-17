import 'dart:convert';
import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../../../../../bin/src/features/core/domain/models/auth/auth_model.dart';
import '../../../../../../../bin/src/features/core/domain/use_cases/get_access_token_data_from_access_jwt/get_access_token_data_from_access_jwt_use_case.dart';
import '../../../../../../../bin/src/features/core/domain/use_cases/get_cookie_by_name_in_string/get_cookie_by_name_in_string_use_case.dart';
import '../../../../../../../bin/src/features/core/domain/values/access_token_data_value.dart';
import '../../../../../../../bin/src/features/matches/domain/models/match_model.dart';
import '../../../../../../../bin/src/features/matches/domain/use_cases/get_match/get_match_use_case.dart';
import '../../../../../../../bin/src/features/matches/presentation/controllers/get_match_controller.dart';
import '../../../../../../../bin/src/features/players/domain/models/player_model.dart';
import '../../../../../../../bin/src/features/players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';

void main() {
  final getMatchUseCase = _MockGetMatchUseCase();
  final getPlayerByIdUseCase = _MockGetPlayerByIdUseCase();
  final getAuthByIdUseCase = _MockGetAuthByIdUseCase();
  final getCookieByNameInStringUseCase = _MockGetCookieByNameInStringUseCase();
  final getAccessTokenDataFromAccessJwtUseCase =
      _MockGetAccessTokenDataFromAccessJwtUseCase();

  final request = _MockRequest();

  // tested class
  final getMatchController = GetMatchController(
    getMatchUseCase: getMatchUseCase,
    getPlayerByIdUseCase: getPlayerByIdUseCase,
    getAuthByIdUseCase: getAuthByIdUseCase,
    getCookieByNameInStringUseCase: getCookieByNameInStringUseCase,
    getAccessTokenDataFromAccessJwtUseCase:
        getAccessTokenDataFromAccessJwtUseCase,
  );

  tearDown(() {
    reset(getMatchUseCase);
    reset(getPlayerByIdUseCase);
    reset(getAuthByIdUseCase);
    reset(request);
    reset(getCookieByNameInStringUseCase);
    reset(getAccessTokenDataFromAccessJwtUseCase);
  });

  group("$GetMatchController", () {
    group(".call()", () {
      final matchId = 1;
      // test(
      //   "given a request without cookies "
      //   "when .call() is called "
      //   "then should return expected response",
      //   () async {
      //     // setup

      //     // given

      //     when(() => request.headers).thenReturn({});

      //     // when
      //     final response = await getMatchController.call(
      //       request,
      //       matchId.toString(),
      //     );

      //     // then
      //     final expectedResponse = _generateTestBadRequestResponse(
      //       // ok: false,
      //       responseMessage: "No cookies found in request.",
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
      //   "given no accessToken cookie in request"
      //   "when .call() is called"
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
      //     final response = await getMatchController.call(
      //       request,
      //       matchId.toString(),
      //     );

      //     // then
      //     final expectedResponse = _generateTestBadRequestResponse(
      //       // ok: false,
      //       responseMessage: "No accessToken cookie found in request.",
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
      //     when(() => request.headers).thenReturn({
      //       HttpHeaders.cookieHeader: cookie.toString(),
      //     });

      //     when(() => getCookieByNameInStringUseCase(
      //           cookieName: any(named: "cookieName"),
      //           cookiesString: any(named: "cookiesString"),
      //         )).thenReturn(cookie);

      //     // given
      //     when(() => getAccessTokenDataFromAccessJwtUseCase(
      //           jwt: any(named: "jwt"),
      //         )).thenReturn(invalidAccessTokenDataResponse);

      //     // when
      //     final response =
      //         await getMatchController.call(request, matchId.toString());

      //     // then
      //     final expectedResponse = _generateTestBadRequestResponse(
      //       // ok: false,
      //       responseMessage: "Invalid auth token in cookie.",
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
      //     when(() => request.headers).thenReturn({
      //       HttpHeaders.cookieHeader: cookie.toString(),
      //     });

      //     when(() => getCookieByNameInStringUseCase(
      //           cookieName: any(named: "cookieName"),
      //           cookiesString: any(named: "cookiesString"),
      //         )).thenReturn(cookie);

      //     // given
      //     when(() => getAccessTokenDataFromAccessJwtUseCase(
      //           jwt: any(named: "jwt"),
      //         )).thenReturn(expiredAccessTokenDataResponse);

      //     // when
      //     final response =
      //         await getMatchController.call(request, matchId.toString());

      //     // then
      //     final expectedResponse = _generateTestBadRequestResponse(
      //       // ok: false,
      //       responseMessage: "Expired auth token in cookie.",
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

      //     when(() => request.headers).thenReturn({
      //       HttpHeaders.cookieHeader: cookie.toString(),
      //     });

      //     when(() => getCookieByNameInStringUseCase(
      //           cookieName: any(named: "cookieName"),
      //           cookiesString: any(named: "cookiesString"),
      //         )).thenReturn(cookie);

      //     when(() => getAccessTokenDataFromAccessJwtUseCase(
      //           jwt: any(named: "jwt"),
      //         )).thenReturn(validAccessTokenDataResponse);

      //     // given
      //     when(() => getAuthByIdUseCase(id: any(named: "id")))
      //         .thenAnswer((_) async => null);

      //     // when
      //     final response =
      //         await getMatchController.call(request, matchId.toString());

      //     // then
      //     final expectedResponse = _generateTestNonExistentResponse(
      //       // ok: false,
      //       responseMessage: "Auth not found.",
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

      //     when(() => request.headers).thenReturn({
      //       HttpHeaders.cookieHeader: cookie.toString(),
      //     });

      //     when(() => getCookieByNameInStringUseCase(
      //           cookieName: any(named: "cookieName"),
      //           cookiesString: any(named: "cookiesString"),
      //         )).thenReturn(cookie);

      //     when(() => getAccessTokenDataFromAccessJwtUseCase(
      //           jwt: any(named: "jwt"),
      //         )).thenReturn(validAccessTokenDataResponse);

      //     when(() => getAuthByIdUseCase(id: any(named: "id")))
      //         .thenAnswer((_) async => _testAuthModel);

      //     // given
      //     when(() => getPlayerByIdUseCase(id: any(named: "id")))
      //         .thenAnswer((_) async => null);

      //     // when
      //     final response =
      //         await getMatchController.call(request, matchId.toString());

      //     // then
      //     final expectedResponse = _generateTestNonExistentResponse(
      //       // ok: false,
      //       responseMessage: "Player not found.",
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

      //     when(() => request.headers).thenReturn({
      //       HttpHeaders.cookieHeader: cookie.toString(),
      //     });

      //     when(() => getCookieByNameInStringUseCase(
      //           cookieName: any(named: "cookieName"),
      //           cookiesString: any(named: "cookiesString"),
      //         )).thenReturn(cookie);

      //     when(() => getAccessTokenDataFromAccessJwtUseCase(
      //           jwt: any(named: "jwt"),
      //         )).thenReturn(validAccessTokenDataResponse);

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
      //     final response =
      //         await getMatchController.call(request, matchId.toString());

      //     // then
      //     final expectedResponse = _generateTestBadRequestResponse(
      //       // ok: false,
      //       responseMessage: "Found player does not match auth id.",
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

      test(
        "given invalid match id"
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

          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader: cookie.toString(),
          });

          // TODO test
          // when(() => request.url.pathSegments).thenReturn({

          // });

          when(() => getCookieByNameInStringUseCase(
                cookieName: any(named: "cookieName"),
                cookiesString: any(named: "cookiesString"),
              )).thenReturn(cookie);

          when(() => getAccessTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(validAccessTokenDataResponse);

          when(() => getAuthByIdUseCase(id: any(named: "id")))
              .thenAnswer((_) async => _testAuthModel);

          when(() => getPlayerByIdUseCase(id: any(named: "id")))
              .thenAnswer((_) async => _testPlayerModel);

          // given
          final invalidMatchId = "not_an_int_parsable_string";

          // when
          final response =
              // await getMatchController.call(request, invalidMatchId);
              await getMatchController.call(request);

          // then
          final expectedResponse = _generateTestBadRequestResponse(
            // ok: false,
            responseMessage: "Invalid match id provided.",
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
        "given match with provided id does not exist"
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

          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader: cookie.toString(),
          });

          when(() => getCookieByNameInStringUseCase(
                cookieName: any(named: "cookieName"),
                cookiesString: any(named: "cookiesString"),
              )).thenReturn(cookie);

          when(() => getAccessTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(validAccessTokenDataResponse);

          when(() => getAuthByIdUseCase(id: any(named: "id")))
              .thenAnswer((_) async => _testAuthModel);

          when(() => getPlayerByIdUseCase(id: any(named: "id")))
              .thenAnswer((_) async => _testPlayerModel);

          // given
          when(() => getMatchUseCase(matchId: any(named: "matchId")))
              .thenAnswer((_) async => null);

          // when
          final response =
              // await getMatchController.call(request, matchId.toString());
              await getMatchController.call(request);

          // then
          final expectedResponse = _generateTestNonExistentResponse(
            // ok: false,
            responseMessage: "Match not found.",
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
        "given match with provided id does exist"
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

          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader: cookie.toString(),
          });

          when(() => getCookieByNameInStringUseCase(
                cookieName: any(named: "cookieName"),
                cookiesString: any(named: "cookiesString"),
              )).thenReturn(cookie);

          when(() => getAccessTokenDataFromAccessJwtUseCase(
                jwt: any(named: "jwt"),
              )).thenReturn(validAccessTokenDataResponse);

          when(() => getAuthByIdUseCase(id: any(named: "id")))
              .thenAnswer((_) async => _testAuthModel);

          when(() => getPlayerByIdUseCase(id: any(named: "id")))
              .thenAnswer((_) async => _testPlayerModel);

          // given
          when(() => getMatchUseCase(matchId: any(named: "matchId")))
              .thenAnswer((_) async => _testMatchModel);

          // when
          final response =
              // await getMatchController.call(request, matchId.toString());
              await getMatchController.call(
            request,
          );

          // then
          final expectedResponse = Response.ok(
            jsonEncode({
              "ok": true,
              "data": {
                // TODO crete to map converters or something like that - to response data maybe?
                "id": _testAuthModel.id,
                "title": _testMatchModel.title,
                "dateAndTime": _testMatchModel.dateAndTime,
                "location": _testMatchModel.location,
                "description": _testMatchModel.description,
              },
              "message": "Match found.",
            }),
            headers: {
              "Content-Type": "application/json",
            },
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

class _MockGetMatchUseCase extends Mock implements GetMatchUseCase {}

class _MockGetPlayerByIdUseCase extends Mock implements GetPlayerByIdUseCase {}

class _MockGetAuthByIdUseCase extends Mock implements GetAuthByIdUseCase {}

class _MockGetAccessTokenDataFromAccessJwtUseCase extends Mock
    implements GetAccessTokenDataFromAccessJwtUseCase {}

class _MockRequest extends Mock implements Request {}

class _MockGetCookieByNameInStringUseCase extends Mock
    implements GetCookieByNameInStringUseCase {}

Response _generateTestBadRequestResponse({
  // required bool ok,
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
  // required String logMessage,
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

final _testMatchModel = MatchModel(
  id: 1,
  title: "title",
  dateAndTime: DateTime.now().millisecondsSinceEpoch,
  location: "location",
  description: "description",
);
