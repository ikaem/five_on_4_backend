import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../../core/utils/extensions/date_time_extension.dart';
import '../../../core/utils/extensions/request_extension.dart';
import '../../domain/use_cases/create_match/create_match_use_case.dart';

class CreateMatchController {
  CreateMatchController({
    required CreateMatchUseCase createMatchUseCase,
  }) : _createMatchUseCase = createMatchUseCase;

  final CreateMatchUseCase _createMatchUseCase;

  Future<Response> call(
    Request request,
  ) async {
    // TODO validation will be done by CreateMatchValidatorMiddleware
    final bodyMap = await request.parseBody();

    final title = bodyMap["title"] as String;
    final dateAndTime = bodyMap["dateAndTime"] as int;
    final location = bodyMap["location"] as String;
    final description = bodyMap["description"] as String;

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

    return _generateSuccessResponse(
      matchId: matchId,
    );
  }
}

Response _generateSuccessResponse({
  required int matchId,
}) {
  return Response.ok(
    jsonEncode(
      {
        "ok": true,
        "matchId": matchId,
        "message": "Match created successfully.",
      },
    ),
    headers: {
      "content-type": "application/json",
    },
  );
}
