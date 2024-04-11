// create interface or base class for all controllers

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../../domain/use_cases/get_match/get_match_use_case.dart';

class GetMatchController {
  GetMatchController({
    required GetMatchUseCase getMatchUseCase,
    required GetPlayerByIdUseCase getPlayerByIdUseCase,
    required GetAuthByIdUseCase getAuthByIdUseCase,
  })  : _getMatchUseCase = getMatchUseCase,
        _getPlayerByIdUseCase = getPlayerByIdUseCase,
        _getAuthByIdUseCase = getAuthByIdUseCase;

  final GetMatchUseCase _getMatchUseCase;
  final GetPlayerByIdUseCase _getPlayerByIdUseCase;
  final GetAuthByIdUseCase _getAuthByIdUseCase;

  Future<Response> call(Request request) async {
    // TODO extract this
    final requestCookies = request.headers[HttpHeaders.cookieHeader];
    if (requestCookies == null) {
      return _generateInvalidRequest(
        logMessage: "No cookies found in request.",
      );
    }

    // we have cookie now - we need to parse it and get the access token

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
}) {
  log(
    logMessage,
    name: "GetMatchController",
  );
  final response = Response.badRequest(
    body: jsonEncode(
      {
        "ok": false,
        "message": "Invalid request.",
      },
    ),
    headers: {
      "Content-Type": "application/json",
    },
  );

  return response;
}
