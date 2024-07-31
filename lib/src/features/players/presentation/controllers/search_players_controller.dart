import 'dart:io';

import 'package:five_on_4_backend/src/features/core/utils/extensions/request_extension.dart';
import 'package:five_on_4_backend/src/features/core/utils/helpers/response_generator.dart';
import 'package:five_on_4_backend/src/features/matches/domain/models/match_model.dart';
import 'package:five_on_4_backend/src/features/players/domain/models/player_model.dart';
import 'package:five_on_4_backend/src/features/players/domain/use_cases/search_players/search_players_use_case.dart';
import 'package:five_on_4_backend/src/features/players/domain/values/players_search_filter_value.dart';
import 'package:five_on_4_backend/src/features/players/utils/constants/search_players_request_body_key_constants.dart';
import 'package:shelf/shelf.dart';

class SearchPlayersController {
  const SearchPlayersController({
    required SearchPlayersUseCase searchPlayersUseCase,
  }) : _searchPlayersUseCase = searchPlayersUseCase;

  final SearchPlayersUseCase _searchPlayersUseCase;

  Future<Response> call(Request request) async {
    final validatedUrlQueryParams = request.getValidatedUrlQueryParams();
    if (validatedUrlQueryParams == null) {
      final response = ResponseGenerator.failure(
        message: "Request url query params not validated.",
        statusCode: HttpStatus.internalServerError,
      );
      return response;
    }

    final nameTerm = validatedUrlQueryParams[
        SearchPlayersRequestBodyKeyConstants.NAME_TERM.value] as String?;

    final playersSearchFilterValue = PlayersSearchFilterValue(
      nameTerm: nameTerm,
    );

    final players = await _searchPlayersUseCase(
      filter: playersSearchFilterValue,
    );

    final response = ResponseGenerator.success(
      message: "Players searched successfully.",
      data: _generateOkResponseData(
        players: players,
      ),
    );

    return response;
  }
}

Map<String, dynamic> _generateOkResponseData({
  required List<PlayerModel> players,
}) {
  final payloadPlayers = players
      .map((e) => ({
            "id": e.id,
            "name": e.name,
            "authId": e.authId,
            "nickname": e.nickname,
          }))
      .toList();

  return {
    "players": payloadPlayers,
  };
}
