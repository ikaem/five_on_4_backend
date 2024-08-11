import 'dart:io';

import 'package:five_on_4_backend/src/features/core/utils/extensions/request_extension.dart';
import 'package:five_on_4_backend/src/features/core/utils/helpers/response_generator.dart';
import 'package:five_on_4_backend/src/features/core/utils/validators/request_validator.dart';
import 'package:five_on_4_backend/src/features/matches/utils/mixins/string_checker_mixin.dart';
import 'package:five_on_4_backend/src/features/players/utils/constants/get_player_request_url_params_key_constants.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class GetPlayerRequestValidator
// TODO not needed for now
    // with StringCheckerMixin
    implements
        RequestValidator {
  @override
  ValidationHandler validate({
    required ValidatedRequestHandler validatedRequestHandler,
  }) {
    // TODO: implement validate

    Future<Response> validator(Request request) async {
      // final urlParams = request.params;
      // // TODO we will make some parser here on request

      // print("urlParams: $urlParams");

      final playerId = request.getUrlParameter(
        parameterName: GetPlayerRequestUrlParamsKeyConstants.ID,
        parser: (value) => int.tryParse(value),
      );

      if (playerId == null) {
        final response = ResponseGenerator.failure(
          message: "Invalid player id provided.",
          statusCode: HttpStatus.badRequest,
        );
        return response;
      }

      final validatedUrlParametersData = {
        GetPlayerRequestUrlParamsKeyConstants.ID: playerId,
      };
      final changedRequest =
          request.getChangedRequestWithValidatedUrlParametersData(
              validatedUrlParametersData);

      return validatedRequestHandler(changedRequest);

      // return Response(200);
    }

    return validator;
  }
}
