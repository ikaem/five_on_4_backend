// create interface or base class for all controllers

import 'dart:convert';
import 'dart:developer';

import 'package:shelf/shelf.dart';

import '../../../core/utils/extensions/request_extension.dart';
import '../../domain/models/match_model.dart';
import '../../domain/use_cases/get_match/get_match_use_case.dart';

class GetMatchController {
  GetMatchController({
    required GetMatchUseCase getMatchUseCase,
  }) : _getMatchUseCase = getMatchUseCase;

  final GetMatchUseCase _getMatchUseCase;

  Future<Response> call(
    Request request,
    // String id,
  ) async {
    final matchId = request.getUrlParam<int>(
      paramName: "id",
      parser: (value) => int.tryParse(value),
    );

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
