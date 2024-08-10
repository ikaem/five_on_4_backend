import 'dart:io';

import 'package:five_on_4_backend/src/features/core/utils/extensions/request_extension.dart';
import 'package:five_on_4_backend/src/features/core/utils/helpers/response_generator.dart';
import 'package:five_on_4_backend/src/features/players/domain/models/player_model.dart';
import 'package:five_on_4_backend/src/features/players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import 'package:five_on_4_backend/src/features/players/utils/constants/get_player_request_url_params_key_constants.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class GetPlayerController {
  const GetPlayerController({
    required GetPlayerByIdUseCase getPlayerByIdUseCase,
  }) : _getPlayerByIdUseCase = getPlayerByIdUseCase;

  final GetPlayerByIdUseCase _getPlayerByIdUseCase;

// TODO temp only this
  // Future<Response> call(Request request, String id) async {
  Future<Response> call(Request request) async {
    final validatedUrlParametersData = request.getValidatedUrlParametersData();
    if (validatedUrlParametersData == null) {
      final response = ResponseGenerator.failure(
        message: "Request url parameters not validated.",
        statusCode: HttpStatus.internalServerError,
      );
      return response;
    }

    final playerId =
        validatedUrlParametersData[GetPlayerRequestUrlParamsKeyConstants.ID]
            as int;

    final player = await _getPlayerByIdUseCase(id: playerId);
    if (player == null) {
      final response = ResponseGenerator.failure(
        message: "Player not found.",
        statusCode: HttpStatus.notFound,
      );
      return response;
    }

    final response = ResponseGenerator.success(
      message: "Player retrieved successfully.",
      data: _generateOkResponseData(
        player: player,
      ),
    );

    return response;

    // return Response(200);
  }
}

Map<String, dynamic> _generateOkResponseData({
  required PlayerModel player,
}) {
  final payloadPlayer = {
    "id": player.id,
    "firstName": player.firstName,
    "lastName": player.lastName,
    "nickname": player.nickname,
    "authId": player.authId,
  };

  return {
    "player": payloadPlayer,
  };
}
