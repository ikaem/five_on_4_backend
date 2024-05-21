import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../core/domain/values/response_body_value.dart';
import '../../../core/utils/extensions/date_time_extension.dart';
import '../../../core/utils/extensions/request_extension.dart';
import '../../../core/utils/helpers/generate_response.dart';
import '../../../core/utils/helpers/response_generator.dart';
import '../../domain/use_cases/create_match/create_match_use_case.dart';
import '../../utils/constants/match_create_request_body_key_constants.dart';

class CreateMatchController {
  CreateMatchController({
    required CreateMatchUseCase createMatchUseCase,
  }) : _createMatchUseCase = createMatchUseCase;

  final CreateMatchUseCase _createMatchUseCase;

  Future<Response> call(
    Request request,
  ) async {
    // TODO validation will be done by CreateMatchValidatorMiddleware
    // final bodyMap = await request.parseBody();
    final validatedBodyData = request.getValidatedBodyData();
    if (validatedBodyData == null) {
      final response = ResponseGenerator.failure(
        message: "Request body not validated.",
        statusCode: HttpStatus.internalServerError,
      );
      return response;
      // final responseBody = ResponseBodyValue(
      //   message: "Request body not validated.",
      //   ok: false,
      // );
      // return generateResponse(
      //   statusCode: HttpStatus.internalServerError,
      //   body: responseBody,
      //   // cookies: cookies,
      //   // TODO will need cookies
      //   cookies: [],
      // );
    }

    final title =
        validatedBodyData[MatchCreateRequestBodyKeyConstants.TITLE.value]
            as String;
    final dateAndTime = validatedBodyData[
        MatchCreateRequestBodyKeyConstants.DATE_AND_TIME.value] as int;
    final location =
        validatedBodyData[MatchCreateRequestBodyKeyConstants.LOCATION.value]
            as String;
    final description =
        validatedBodyData[MatchCreateRequestBodyKeyConstants.DESCRIPTION.value]
            as String;

    final nowDate = DateTime.now().normalizedToSeconds.millisecondsSinceEpoch;
    final createdAt = nowDate;
    final updatedAt = nowDate;

    final matchId = await _createMatchUseCase(
      title: title,
      dateAndTime: dateAndTime,
      location: location,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    // return _generateSuccessResponse(
    //   matchId: matchId,
    // );

    final response = ResponseGenerator.success(
      message: "Match created successfully.",
      data: {
        "matchId": matchId,
      },
    );
    return response;
  }
}

// Response _generateSuccessResponse({
//   required int matchId,
// }) {
//   return Response.ok(
//     jsonEncode(
//       {
//         "ok": true,
//         "matchId": matchId,
//         "message": "Match created successfully.",
//       },
//     ),
//     headers: {
//       // TODO this needs updating the cookie too - the access token cookie
//       "content-type": "application/json",
//     },
//   );
// }
