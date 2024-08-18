import 'dart:io';

import 'package:five_on_4_backend/src/features/core/utils/extensions/request_extension.dart';
import 'package:five_on_4_backend/src/features/core/utils/helpers/response_generator.dart';
import 'package:five_on_4_backend/src/features/core/utils/validators/request_validator.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/data/entities/player_match_participation_entity.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/utils/constants/player_match_participate_request_query_params_key_constants.dart';
import 'package:shelf/shelf.dart';

class PlayerMatchParticipateRequestValidator implements RequestValidator {
  const PlayerMatchParticipateRequestValidator();

  @override
  ValidationHandler validate({
    required ValidatedRequestHandler validatedRequestHandler,
  }) {
    Future<Response> validationHandler(Request request) async {
      final requestQueryParams = request.url.queryParameters;

      final status = requestQueryParams[
          PlayerMatchParticipateRequestQueryParamsKeyConstants
              .PARTICIPATION_STATUS.value];
      final matchId = requestQueryParams[
          PlayerMatchParticipateRequestQueryParamsKeyConstants.MATCH_ID.value];
      final playerId = requestQueryParams[
          PlayerMatchParticipateRequestQueryParamsKeyConstants.PLAYER_ID.value];

      if (status == null) {
        final response = ResponseGenerator.failure(
          message: "No participation status provided.",
          statusCode: HttpStatus.badRequest,
        );

        return response;
      }
      if (matchId == null) {
        final response = ResponseGenerator.failure(
          message: "No match id provided.",
          statusCode: HttpStatus.badRequest,
        );

        return response;
      }
      if (playerId == null) {
        final response = ResponseGenerator.failure(
          message: "No player id provided.",
          statusCode: HttpStatus.badRequest,
        );

        return response;
      }

      // now we need to make sure that the status is one of the valid ones
      final validStatus = PlayerMatchParticipationStatus.values.firstWhere(
        (element) => element.name == status,
        orElse: () => PlayerMatchParticipationStatus.unknown,
      );
      if (validStatus == PlayerMatchParticipationStatus.unknown) {
        final response = ResponseGenerator.failure(
          message: "Invalid participation status provided.",
          statusCode: HttpStatus.badRequest,
        );

        return response;
      }

      final validMatchId = int.tryParse(matchId);
      if (validMatchId == null) {
        final response = ResponseGenerator.failure(
          message: "Invalid match id provided.",
          statusCode: HttpStatus.badRequest,
        );

        return response;
      }

      final validPlayerId = int.tryParse(playerId);
      if (validPlayerId == null) {
        final response = ResponseGenerator.failure(
          message: "Invalid player id provided.",
          statusCode: HttpStatus.badRequest,
        );

        return response;
      }

      final validatedUrlQueryParamsData = {
        PlayerMatchParticipateRequestQueryParamsKeyConstants
            .PARTICIPATION_STATUS.value: validStatus.name,
        PlayerMatchParticipateRequestQueryParamsKeyConstants.MATCH_ID.value:
            validMatchId,
        PlayerMatchParticipateRequestQueryParamsKeyConstants.PLAYER_ID.value:
            validPlayerId,
      };

      final changedRequest =
          request.getChangedRequestWithValidatedUrlQueryParams(
        validatedUrlQueryParamsData,
      );

      return validatedRequestHandler(changedRequest);
    }

    return validationHandler;
  }

  // TODO maybe this could be in the base class? or probably not?
}
