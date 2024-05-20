import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../core/utils/extensions/request_extension.dart';
import '../../../core/utils/helpers/response_generator.dart';
import '../../../core/utils/validators/request_validator.dart';
import '../constants/authenticate_with_google_request_body_key_constants.dart';

class AuthenticateWithGoogleRequestValidator implements RequestValidator {
  @override
  ValidationHandler validate({
    required ValidatedRequestHandler validatedRequestHandler,
  }) =>
      (Request request) async {
        final requestBody = await request.parseBody();

        // idToken
        final idToken = requestBody[
            AuthenticateWithGoogleRequestBodyKeyConstants.ID_TOKEN.value];
        if (idToken == null) {
          final response = ResponseGenerator.failure(
            message: "Google idToken is required.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        if (idToken is! String) {
          final response = ResponseGenerator.failure(
            message: "Invalid data type supplied for idToken.",
            statusCode: HttpStatus.badRequest,
          );
          return response;
        }

        final validatedBodyData = {
          AuthenticateWithGoogleRequestBodyKeyConstants.ID_TOKEN.value: idToken,
        };
        final changedRequest = request.getChangedRequestWithValidatedBodyData(
          validatedBodyData,
        );

        return await validatedRequestHandler(changedRequest);
      };
}
