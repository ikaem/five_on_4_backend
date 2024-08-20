import 'dart:io';

import 'package:five_on_4_backend/src/features/core/utils/extensions/request_extension.dart';
import 'package:five_on_4_backend/src/features/core/utils/helpers/response_generator.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/data/entities/player_match_participation_entity.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/use_cases/dont_join_match/dont_join_match_use_case.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/use_cases/invite_to_match/invite_to_match_use_case.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/use_cases/join_match/join_match_use_case.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/utils/constants/store_player_match_participation_request_query_params_key_constants.dart';
import 'package:shelf/shelf.dart';

class StorePlayerMatchParticipationController {
  const StorePlayerMatchParticipationController({
    required JoinMatchUseCase joinMatchUseCase,
    required DontJoinMatchUseCase dontJoinMatchUseCase,
    required InviteToMatchUseCase inviteToMatchUseCase,
  })  : _joinMatchUseCase = joinMatchUseCase,
        _dontJoinMatchUseCase = dontJoinMatchUseCase,
        _inviteToMatchUseCase = inviteToMatchUseCase;

  final JoinMatchUseCase _joinMatchUseCase;
  final DontJoinMatchUseCase _dontJoinMatchUseCase;
  final InviteToMatchUseCase _inviteToMatchUseCase;

  Future<Response> call(Request request) async {
    final validatedUrlQueryParams = request.getValidatedUrlQueryParams();
    if (validatedUrlQueryParams == null) {
      final response = ResponseGenerator.failure(
        message: "Request url query params not validated.",
        statusCode: 500,
      );
      return response;
    }

    final matchId = validatedUrlQueryParams[
        StorePlayerMatchParticipationRequestQueryParamsKeyConstants
            .MATCH_ID.value] as int;
    final playerId = validatedUrlQueryParams[
        StorePlayerMatchParticipationRequestQueryParamsKeyConstants
            .PLAYER_ID.value] as int;
    // TODO this could be solved if we actually pass enum here? lets do this in future - in short, just in validator, when valikdated status, pass enum here, and not string
    final status = validatedUrlQueryParams[
        StorePlayerMatchParticipationRequestQueryParamsKeyConstants
            .PARTICIPATION_STATUS.value] as String;

    final validStatus = PlayerMatchParticipationStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => PlayerMatchParticipationStatus.unknown,
    );

    final int? participationId = switch (validStatus) {
      PlayerMatchParticipationStatus.arriving => await _joinMatchUseCase(
          matchId: matchId,
          playerId: playerId,
        ),
      PlayerMatchParticipationStatus.notArriving => await _dontJoinMatchUseCase(
          matchId: matchId,
          playerId: playerId,
        ),
      PlayerMatchParticipationStatus.pendingDecision =>
        await _inviteToMatchUseCase(
          matchId: matchId,
          playerId: playerId,
        ),
      _ => null,
    };

    if (participationId == null) {
      final response = ResponseGenerator.failure(
        message:
            "Unable to store player match participation due to invalid participation status: ${validStatus.name}.",
        statusCode: HttpStatus.internalServerError,
      );
      return response;
    }

    final response = ResponseGenerator.success(
      message: "Player match participation stored successfully.",
      data: _generateOkResponseData(
        participationId: participationId,
      ),
    );

    return response;
  }
}

Map<String, dynamic> _generateOkResponseData({
  required int participationId,
}) {
  return {
    "id": participationId,
  };
}
