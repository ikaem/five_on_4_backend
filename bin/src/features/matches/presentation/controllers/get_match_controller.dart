// create interface or base class for all controllers

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../core/domain/use_cases/get_cookie_by_name_in_string/get_cookie_by_name_in_string_use_case.dart';
import '../../../players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../../domain/use_cases/get_match/get_match_use_case.dart';

class GetMatchController {
  GetMatchController({
    required GetMatchUseCase getMatchUseCase,
    required GetPlayerByIdUseCase getPlayerByIdUseCase,
    required GetAuthByIdUseCase getAuthByIdUseCase,
    required GetCookieByNameInStringUseCase getCookieByNameInStringUseCase,
  })  : _getMatchUseCase = getMatchUseCase,
        _getPlayerByIdUseCase = getPlayerByIdUseCase,
        _getAuthByIdUseCase = getAuthByIdUseCase,
        _getCookieByNameInStringUseCase = getCookieByNameInStringUseCase;

  final GetMatchUseCase _getMatchUseCase;
  final GetPlayerByIdUseCase _getPlayerByIdUseCase;
  final GetAuthByIdUseCase _getAuthByIdUseCase;
  final GetCookieByNameInStringUseCase _getCookieByNameInStringUseCase;

  Future<Response> call(Request request) async {
    // TODO extract this
    final requestCookies = request.headers[HttpHeaders.cookieHeader];
    if (requestCookies == null) {
      return _generateInvalidRequest(
        logMessage: "No cookies found in request.",
        responseMessage: "No cookies found in request.",
      );
    }

    // we have cookie now - we need to parse it and get the access token
    final accessTokenCookie = _getCookieByNameInStringUseCase(
      cookiesString: requestCookies,
      // TODO make constants out of this
      cookieName: "accessToken",
    );
    if (accessTokenCookie == null) {
      return _generateInvalidRequest(
        logMessage: "No accessToken cookie found in request.",
        responseMessage: "No accessToken cookie found in request.",
      );
    }

    final accessToken = accessTokenCookie.value;
    // now we need to pass value to use case to decode jwt

    // now we have access token cookie
    // check if access token inside is valid

    final successResponse = Response.ok(
      jsonEncode(
        {
          "ok": true,
          "data": {},
          "message": "Match found.",
        },
      ),
    );
    return successResponse;
  }
}

Response _generateInvalidRequest({
  required String logMessage,
  required String responseMessage,
}) {
  log(
    logMessage,
    name: "GetMatchController",
  );
  final response = Response.badRequest(
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

  return response;
}
