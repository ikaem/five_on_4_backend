import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../core/utils/extensions/request_extension.dart';
import '../../../core/utils/helpers/response_generator.dart';
import '../../../core/utils/validators/request_validator.dart';
import '../constants/get_player_matches_overview_request_body_key_constants.dart';

class GetPlayerMatchesOverviewRequestValidator implements RequestValidator {
  const GetPlayerMatchesOverviewRequestValidator();

  @override
  ValidationHandler validate({
    required ValidatedRequestHandler validatedRequestHandler,
  }) =>
      (Request request) async {
        final requestBody = await request.parseBody();

        final playerId = requestBody[
            GetPlayerMatchesOverviewRequestBodyKeyConstants.PLAYER_ID.value];

        if (playerId is! int) {
          final response = ResponseGenerator.failure(
            message: "playerId is required.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        final validatedBodyData = {
          GetPlayerMatchesOverviewRequestBodyKeyConstants.PLAYER_ID.value:
              playerId,
        };
        final changedRequest =
            request.getChangedRequestWithValidatedBodyData(validatedBodyData);

        return validatedRequestHandler(changedRequest);
      };
}
