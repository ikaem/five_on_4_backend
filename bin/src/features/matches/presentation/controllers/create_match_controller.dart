import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../core/utils/extensions/date_time_extension.dart';
import '../../../core/utils/extensions/request_extension.dart';
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
    final validatedBodyData = request.getValidatedBodyData();
    if (validatedBodyData == null) {
      final response = ResponseGenerator.failure(
        message: "Request body not validated.",
        statusCode: HttpStatus.internalServerError,
      );
      return response;
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

    final response = ResponseGenerator.success(
      message: "Match created successfully.",
      data: {
        "matchId": matchId,
      },
    );
    return response;
  }
}
