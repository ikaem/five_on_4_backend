import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../../core/utils/extensions/request_extension.dart';
import '../constants/match_create_request_body_constants.dart';

class MatchCreateRequestValidator {
  const MatchCreateRequestValidator();

  FutureOr<Response?> validate(Request request) async {
    final body = await request.parseBody();

    final title = body[MatchCreateRequestBodyConstants.TITLE.value];
    if (title is! String) {
      final typeOfTitle = title.runtimeType;
      return _generateBadRequestResponse(
        responseMessage: "Title is required.",
      );
    }

    final description = body[MatchCreateRequestBodyConstants.DESCRIPTION.value];
    if (description is! String) {
      return _generateBadRequestResponse(
        responseMessage: "Description is required.",
      );
    }

    final dateAndTime =
        body[MatchCreateRequestBodyConstants.DATE_AND_TIME.value];
    if (dateAndTime is! int) {
      return _generateBadRequestResponse(
        responseMessage: "Date and time is required.",
      );
    }

    // TODO maybe validate if dateAndTime is in the future
    final matchDate = DateTime.fromMillisecondsSinceEpoch(dateAndTime);
    if (matchDate.isBefore(DateTime.now())) {
      return _generateBadRequestResponse(
        responseMessage: "Date and time must be in the future.",
      );
    }

    final location = body[MatchCreateRequestBodyConstants.LOCATION.value];
    if (location is! String) {
      return _generateBadRequestResponse(
        responseMessage: "Location is required.",
      );
    }

    return null;
  }
}

// TODO maybe is possible to abstract this and make it generic and reuslable by all validators - or to live in some base middleware class
Response _generateBadRequestResponse({
  required String responseMessage,
}) {
  final response = Response.badRequest(
    body: jsonEncode(
      {
        "ok": false,
        "message": responseMessage,
      },
    ),
    headers: {
      "Content-Type": "application/json",
    },
  );

  return response;
}
