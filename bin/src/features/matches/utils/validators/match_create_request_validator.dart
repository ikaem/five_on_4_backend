import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../core/utils/extensions/request_extension.dart';
import '../../../core/utils/helpers/response_generator.dart';
import '../../../core/utils/validators/request_validator.dart';
import '../constants/match_create_request_body_key_constants.dart';

class MatchCreateRequestValidator implements RequestValidator {
  const MatchCreateRequestValidator();

  @override
  ValidationHandler validate({
    required ValidatedRequestHandler validatedRequestHandler,
  }) =>
      (Request request) async {
        final requestBody = await request.parseBody();

        final title =
            requestBody[MatchCreateRequestBodyKeyConstants.TITLE.value];
        // TODO these checks should be better later - do the same like in login request validator
        if (title is! String) {
          final response = ResponseGenerator.failure(
            message: "Title is required.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
          // final responseBody = ResponseBodyValue(
          //   message: "Title is required.",
          //   ok: false,
          // );
          // return generateResponse(
          //   statusCode: HttpStatus.badRequest,
          //   body: responseBody,
          //   // TODO this is incorrect  - cookies should be updated in the repsonse
          //   cookies: [],
          // );
        }

        final description =
            requestBody[MatchCreateRequestBodyKeyConstants.DESCRIPTION.value];
        if (description is! String) {
          final response = ResponseGenerator.failure(
            message: "Description is required.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
          // final responseBody = ResponseBodyValue(
          //   message: "Description is required.",
          //   ok: false,
          // );
          // return generateResponse(
          //   statusCode: HttpStatus.badRequest,
          //   body: responseBody,
          //   cookies: [],
          // );
        }

        final dateAndTime =
            requestBody[MatchCreateRequestBodyKeyConstants.DATE_AND_TIME.value];
        if (dateAndTime is! int) {
          final response = ResponseGenerator.failure(
            message: "Date and time is required.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
          // final responseBody = ResponseBodyValue(
          //   message: "Date and time is required.",
          //   ok: false,
          // );
          // return generateResponse(
          //   statusCode: HttpStatus.badRequest,
          //   body: responseBody,
          //   cookies: [],
          // );
        }

        final matchDate = DateTime.fromMillisecondsSinceEpoch(dateAndTime);
        if (matchDate.isBefore(DateTime.now())) {
          final response = ResponseGenerator.failure(
            message: "Date and time must be in the future.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
          // final responseBody = ResponseBodyValue(
          //   message: "Date and time must be in the future.",
          //   ok: false,
          // );
          // return generateResponse(
          //   statusCode: HttpStatus.badRequest,
          //   body: responseBody,
          //   cookies: [],
          // );
        }

        final location =
            requestBody[MatchCreateRequestBodyKeyConstants.LOCATION.value];
        if (location is! String) {
          final response = ResponseGenerator.failure(
            message: "Location is required.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
          // final responseBody = ResponseBodyValue(
          //   message: "Location is required.",
          //   ok: false,
          // );
          // return generateResponse(
          //   statusCode: HttpStatus.badRequest,
          //   body: responseBody,
          //   cookies: [],
          // );
        }

        final validatedBodyData = {
          MatchCreateRequestBodyKeyConstants.TITLE.value: title,
          MatchCreateRequestBodyKeyConstants.DESCRIPTION.value: description,
          MatchCreateRequestBodyKeyConstants.DATE_AND_TIME.value: dateAndTime,
          MatchCreateRequestBodyKeyConstants.LOCATION.value: location,
        };
        final changedRequest = request.getChangedRequestWithValidatedBodyData(
          validatedBodyData,
        );

        return validatedRequestHandler(changedRequest);
      };

  // FutureOr<Response?> validate(Request request) async {
  //   final body = await request.parseBody();

  //   final title = body[MatchCreateRequestBodyKeyConstants.TITLE.value];
  //   if (title is! String) {
  //     final responseBody = ResponseBodyValue(
  //       message: "Title is required.",
  //       ok: false,
  //     );
  //     return generateResponse(
  //       statusCode: HttpStatus.badRequest,
  //       body: responseBody,
  //       // TODD come back to this - maybe it is not needed on validation for cookies to be updated
  //       // TODO but then frontend will need to check if cookies exist
  //       cookies: [],
  //     );

  //     // return _generateBadRequestResponse(
  //     //   responseMessage: "Title is required.",
  //     // );
  //   }

  //   final description =
  //       body[MatchCreateRequestBodyKeyConstants.DESCRIPTION.value];
  //   if (description is! String) {
  //     final responseBody = ResponseBodyValue(
  //       message: "Description is required.",
  //       ok: false,
  //     );
  //     return generateResponse(
  //       statusCode: HttpStatus.badRequest,
  //       body: responseBody,
  //       cookies: [],
  //     );

  //     // return _generateBadRequestResponse(
  //     //   responseMessage: "Description is required.",
  //     // );
  //   }

  //   final dateAndTime =
  //       body[MatchCreateRequestBodyKeyConstants.DATE_AND_TIME.value];
  //   if (dateAndTime is! int) {
  //     final responseBody = ResponseBodyValue(
  //       message: "Date and time is required.",
  //       ok: false,
  //     );
  //     return generateResponse(
  //       statusCode: HttpStatus.badRequest,
  //       body: responseBody,
  //       cookies: [],
  //     );
  //     // return _generateBadRequestResponse(
  //     //   responseMessage: "Date and time is required.",
  //     // );
  //   }

  //   // TODO maybe validate if dateAndTime is in the future
  //   final matchDate = DateTime.fromMillisecondsSinceEpoch(dateAndTime);
  //   if (matchDate.isBefore(DateTime.now())) {
  //     final responseBody = ResponseBodyValue(
  //       message: "Date and time must be in the future.",
  //       ok: false,
  //     );
  //     return generateResponse(
  //       statusCode: HttpStatus.badRequest,
  //       body: responseBody,
  //       cookies: [],
  //     );

  //     // return _generateBadRequestResponse(
  //     //   responseMessage: "Date and time must be in the future.",
  //     // );
  //   }

  //   final location = body[MatchCreateRequestBodyKeyConstants.LOCATION.value];
  //   if (location is! String) {
  //     final responseBody = ResponseBodyValue(
  //       message: "Location is required.",
  //       ok: false,
  //     );
  //     return generateResponse(
  //       statusCode: HttpStatus.badRequest,
  //       body: responseBody,
  //       cookies: [],
  //     );
  //     // return _generateBadRequestResponse(
  //     //   responseMessage: "Location is required.",
  //     // );
  //   }

  //   return null;
  // }
}

// TODO maybe is possible to abstract this and make it generic and reuslable by all validators - or to live in some base middleware class
// Response _generateBadRequestResponse({
//   required String responseMessage,
// }) {
//   final response = Response.badRequest(
//     body: jsonEncode(
//       {
//         "ok": false,
//         "message": responseMessage,
//       },
//     ),
//     headers: {
//       "Content-Type": "application/json",
//     },
//   );

//   return response;
// }
