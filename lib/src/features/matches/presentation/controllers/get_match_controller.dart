// create interface or base class for all controllers
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../core/utils/extensions/request_extension.dart';
import '../../../core/utils/helpers/response_generator.dart';
import '../../domain/models/match_model.dart';
import '../../domain/use_cases/get_match/get_match_use_case.dart';

class GetMatchController {
  const GetMatchController({
    required GetMatchUseCase getMatchUseCase,
  }) : _getMatchUseCase = getMatchUseCase;

  final GetMatchUseCase _getMatchUseCase;

  Future<Response> call(
    Request request,
  ) async {
    // TODO move this to some validator - that will generate validatedParams
    final matchId = request.getUrlParam<int>(
      paramName: "id",
      parser: (value) => int.tryParse(value),
    );

    if (matchId == null) {
      final response = ResponseGenerator.failure(
        message: "Invalid match id provided.",
        statusCode: HttpStatus.badRequest,
      );
      return response;
    }

    final match = await _getMatchUseCase(matchId: matchId);
    if (match == null) {
      final response = ResponseGenerator.failure(
        message: "Match not found",
        statusCode: HttpStatus.notFound,
      );
      return response;
    }

    final response = ResponseGenerator.success(
      data: _generateOkResponseData(
        match: match,
      ),
      message: "Match found",
    );
    return response;
  }
}

Map<String, Object> _generateOkResponseData({
  required MatchModel match,
}) {
  // TODO this should be fixed - tghis should be a map that holds "match", which has payload
  final matchPayload = {
    "id": match.id,
    "title": match.title,
    "dateAndTime": match.dateAndTime,
    "location": match.location,
    "description": match.description,
  };

  final participationsPayload = match.participations.map((participation) {
    return {
      "id": participation.id,
      "status": participation.status,
      "playerId": participation.playerId,
      "matchId": participation.matchId,
      "playerNickname": participation.playerNickname,
    };
  }).toList();

  return {
    "match": matchPayload,
    // TODO in future, this mnight be a map - lets see
    // and isnide map, we might have some metadata - pagination related stuff, and so on...
    "participations": participationsPayload,
  };
}
