import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../core/utils/extensions/request_extension.dart';
import '../../../core/utils/helpers/response_generator.dart';
import '../../../players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../../domain/models/match_model.dart';
import '../../domain/use_cases/get_player_matches_overview/get_player_matches_overview_use_case.dart';
import '../../utils/constants/get_player_matches_overview_request_body_key_constants.dart';

class GetPlayerMatchesOverviewController {
  const GetPlayerMatchesOverviewController({
    required GetPlayerMatchesOverviewUseCase getPlayerMatchesOverviewUseCase,
    required GetPlayerByIdUseCase getPlayerByIdUseCase,
  })  : _getPlayerMatchesOverviewUseCase = getPlayerMatchesOverviewUseCase,
        _getPlayerByIdUseCase = getPlayerByIdUseCase;

  final GetPlayerMatchesOverviewUseCase _getPlayerMatchesOverviewUseCase;
  final GetPlayerByIdUseCase _getPlayerByIdUseCase;

  Future<Response> call(Request request) async {
    final validatedBodyData = request.getValidatedBodyData();
    if (validatedBodyData == null) {
      final response = ResponseGenerator.failure(
        // todo A CONSTRUCTOR should be created for this
        message: "Request body not validated.",
        statusCode: HttpStatus.internalServerError,
      );
      return response;
    }

    final playerId = validatedBodyData[
        GetPlayerMatchesOverviewRequestBodyKeyConstants.PLAYER_ID.value] as int;
    final player = await _getPlayerByIdUseCase(id: playerId);
    if (player == null) {
      final response = ResponseGenerator.failure(
        message: "Unable to find player for the provided playerId.",
        statusCode: HttpStatus.notFound,
      );
      return response;
    }

    // TODO move this away
    final response = ResponseGenerator.success(
      message: "Player matches overview retrieved successfully.",
      data: _generateOkResponseData(
        matches: await _getPlayerMatchesOverviewUseCase(playerId: playerId),
      ),
    );

    return response;
  }
}

Map<String, Object> _generateOkResponseData({
  required List<MatchModel> matches,
}) {
  final payloadMatches = matches
      .map((e) => ({
            "id": e.id,
            "title": e.title,
            "dateAndTime": e.dateAndTime,
            "location": e.location,
            "description": e.description,
          }))
      .toList();

  return {
    "matches": payloadMatches,
  };
}
