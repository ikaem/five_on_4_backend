// create interface or base class for all controllers

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../core/domain/use_cases/get_access_token_data_from_access_jwt/get_access_token_data_from_access_jwt_use_case.dart';
import '../../../core/domain/use_cases/get_cookie_by_name_in_string/get_cookie_by_name_in_string_use_case.dart';
import '../../../core/domain/values/access_token_data_value.dart';
import '../../../core/utils/extensions/request_extension.dart';
import '../../../players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../../domain/models/match_model.dart';
import '../../domain/use_cases/get_match/get_match_use_case.dart';

class GetMatchController {
  GetMatchController({
    required GetMatchUseCase getMatchUseCase,
    required GetPlayerByIdUseCase getPlayerByIdUseCase,
    required GetAuthByIdUseCase getAuthByIdUseCase,
    required GetCookieByNameInStringUseCase getCookieByNameInStringUseCase,
    required GetAccessTokenDataFromAccessJwtUseCase
        getAccessTokenDataFromAccessJwtUseCase,
  })  : _getMatchUseCase = getMatchUseCase,
        _getPlayerByIdUseCase = getPlayerByIdUseCase,
        _getAuthByIdUseCase = getAuthByIdUseCase,
        _getCookieByNameInStringUseCase = getCookieByNameInStringUseCase,
        _getAccessTokenDataFromAccessJwtUseCase =
            getAccessTokenDataFromAccessJwtUseCase;

  final GetMatchUseCase _getMatchUseCase;
  final GetPlayerByIdUseCase _getPlayerByIdUseCase;
  final GetAuthByIdUseCase _getAuthByIdUseCase;
  final GetCookieByNameInStringUseCase _getCookieByNameInStringUseCase;
  final GetAccessTokenDataFromAccessJwtUseCase
      _getAccessTokenDataFromAccessJwtUseCase;

  Future<Response> call(
    Request request,
    // String id,
  ) async {
    // TODO I guess this is always string
    final paramsMap =
        request.context["shelf_router/params"] as Map<String, String>;
    final idParam = paramsMap["id"];
    if (idParam is! String) {
      return _generateBadRequestResponse(
        logMessage: "No id provided.",
        responseMessage: "No id provided.",
      );
    }

    final matchIdTest = int.tryParse(idParam);

    // TODO extract this
    final requestCookies = request.headers[HttpHeaders.cookieHeader];
    if (requestCookies == null) {
      return _generateBadRequestResponse(
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
      return _generateBadRequestResponse(
        logMessage: "No accessToken cookie found in request.",
        responseMessage: "No accessToken cookie found in request.",
      );
    }

    final accessToken = accessTokenCookie.value;
    // now we need to pass value to use case to decode jwt
    final accessTokenData =
        _getAccessTokenDataFromAccessJwtUseCase(jwt: accessToken);

    if (accessTokenData is AccessTokenDataValueInvalid) {
      return _generateBadRequestResponse(
        logMessage: "Invalid auth token in cookie.",
        responseMessage: "Invalid auth token in cookie.",
      );
    }

    if (accessTokenData is AccessTokenDataValueExpired) {
      return _generateBadRequestResponse(
        logMessage: "Expired auth token in cookie.",
        responseMessage: "Expired auth token in cookie.",
      );
    }

    final validAccessTokenData = accessTokenData as AccessTokenDataValueValid;

    // get auth id from access token
    final authId = validAccessTokenData.authId;
    final auth = await _getAuthByIdUseCase(id: authId);
    if (auth == null) {
      return _generateNonExistentResponse(
        logMessage: "Auth not found.",
        responseMessage: "Auth not found.",
      );
    }

    // get player id from access token
    final playerId = validAccessTokenData.playerId;
    final player = await _getPlayerByIdUseCase(id: playerId);
    if (player == null) {
      return _generateNonExistentResponse(
        logMessage: "Player not found.",
        responseMessage: "Player not found.",
      );
    }

    final doPlayerAndAuthMatch = player.authId == auth.id;
    if (!doPlayerAndAuthMatch) {
      return _generateBadRequestResponse(
        logMessage: "Found player does not match auth id.",
        responseMessage: "Found player does not match auth id.",
      );
    }

    // now we can go and retrieve the match
    // final matchId = int.tryParse(id);
    // TODO make this a separate function to handle this
    final pathSegments = request.url.pathSegments;
    // TODO make sure that path segments have lenght of two
    if (pathSegments.length != 2) {
      // TODO do this better
      // TODO possibly also make some parser to add this to the request
      return Response.internalServerError(
        body: jsonEncode(
          {
            "ok": false,
            "data": {},
            "message": "There was an issue on the server"
          },
        ),
      );
    }
    // TODO make this into a middleware of its own - and add to to the router as middleware as well
    final matchId = int.tryParse(pathSegments[1]);

    // final idParam = request.context["id"];

    if (matchId == null) {
      return _generateBadRequestResponse(
        logMessage: "Invalid match id provided.",
        responseMessage: "Invalid match id provided.",
      );
    }

    final match = await _getMatchUseCase(matchId: matchId);
    if (match == null) {
      return _generateNonExistentResponse(
        logMessage: "Match not found.",
        responseMessage: "Match not found.",
      );
    }

    final successResponse = _generateSuccessResponse(
      match: match,
    );
    return successResponse;
  }
}

Response _generateBadRequestResponse({
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

Response _generateNonExistentResponse({
  required String logMessage,
  required String responseMessage,
}) {
  log(
    logMessage,
    name: "GetMatchController",
  );

  final response = Response.notFound(
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

  return response;
}

Response _generateSuccessResponse({
  required MatchModel match,
}) {
  final payload = {
    "id": match.id,
    "title": match.title,
    "dateAndTime": match.dateAndTime,
    "location": match.location,
    "description": match.description,
  };
  final response = Response.ok(
    jsonEncode(
      {
        "ok": true,
        "data": payload,
        "message": "Match found.",
      },
    ),
  );
  return response;
}
