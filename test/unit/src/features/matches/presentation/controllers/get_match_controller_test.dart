import 'dart:convert';
import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../../../../../bin/src/features/core/domain/use_cases/get_cookie_by_name_in_string/get_cookie_by_name_in_string_use_case.dart';
import '../../../../../../../bin/src/features/matches/domain/use_cases/get_match/get_match_use_case.dart';
import '../../../../../../../bin/src/features/matches/presentation/controllers/get_match_controller.dart';
import '../../../../../../../bin/src/features/players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';

void main() {
  final getMatchUseCase = _MockGetMatchUseCase();
  final getPlayerByIdUseCase = _MockGetPlayerByIdUseCase();
  final getAuthByIdUseCase = _MockGetAuthByIdUseCase();
  final getCookieByNameInStringUseCase = _MockGetCookieByNameInStringUseCase();

  final request = _MockRequest();

  // tested class
  final getMatchController = GetMatchController(
    getMatchUseCase: getMatchUseCase,
    getPlayerByIdUseCase: getPlayerByIdUseCase,
    getAuthByIdUseCase: getAuthByIdUseCase,
    getCookieByNameInStringUseCase: getCookieByNameInStringUseCase,
  );

  setUp(() {
    reset(getMatchUseCase);
    reset(getPlayerByIdUseCase);
    reset(getAuthByIdUseCase);
    reset(request);
    reset(getCookieByNameInStringUseCase);
  });

  group("$GetMatchController", () {
    group(".call()", () {
      test(
        "given a request without cookies "
        "when .call() is called "
        "then should return expected response",
        () async {
          // setup

          // given

          when(() => request.headers).thenReturn({});

          // when
          final response = await getMatchController.call(request);

          // then
          final expectedResponse = _generateExpectedResponse(
            ok: false,
            responseMessage: "No cookies found in request.",
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
          final response = await getMatchController.call(request);

          // then
          final expectedResponse = _generateExpectedResponse(
            ok: false,
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

          // given

          when(() => request.headers).thenReturn({
            HttpHeaders.cookieHeader: cookie.toString(),
          });

          // when
          final response = await getMatchController.call(request);

          // then
          final expectedResponse = _generateExpectedResponse(
            ok: false,
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

      // test(
      //   "given given a request with invalid accessToken cookie"
      //   "when .call() is called"
      //   "then should return expected response",
      //   () async {
      //     // setup

      //     // given
      //     when(() => request.headers).thenReturn({
      //       HttpHeaders.cookieHeader: "accessToken=invalid_access_token",
      //     });

      //     // when
      //     final response = await getMatchController.call(request);

      //     // then
      //     final expectedResponse = _generateExpectedResponse(
      //       ok: false,
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
    });
  });
}

class _MockGetMatchUseCase extends Mock implements GetMatchUseCase {}

class _MockGetPlayerByIdUseCase extends Mock implements GetPlayerByIdUseCase {}

class _MockGetAuthByIdUseCase extends Mock implements GetAuthByIdUseCase {}

class _MockRequest extends Mock implements Request {}

class _MockGetCookieByNameInStringUseCase extends Mock
    implements GetCookieByNameInStringUseCase {}

Response _generateExpectedResponse({
  required bool ok,
  required String responseMessage,
}) {
  return Response.badRequest(
    body: jsonEncode(
      {
        "ok": ok,
        "message": "Invalid request - $responseMessage.",
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
