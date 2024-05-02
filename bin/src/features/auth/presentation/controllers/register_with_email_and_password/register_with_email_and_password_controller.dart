import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../../core/utils/extensions/request_extension.dart';
import '../../../../core/utils/helpers/response_generator.dart';
import '../../../domain/use_cases/get_auth_by_email/get_auth_by_email_use_case.dart';
import '../../../utils/constants/register_with_email_and_password_request_body_key_constants.dart';

class RegisterWithEmailAndPasswordController {
  RegisterWithEmailAndPasswordController({
    required GetAuthByEmailUseCase getAuthByEmailUseCase,
  }) : _getAuthByEmailUseCase = getAuthByEmailUseCase;

  final GetAuthByEmailUseCase _getAuthByEmailUseCase;

  Future<Response> call(
    Request request,
    // String id,
  ) async {
    final bodyMap = await request.parseBody();
    final email =
        bodyMap[RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value]
            as String;

    final auth = await _getAuthByEmailUseCase(email: email);

    return generateResponse(
      statusCode: HttpStatus.badRequest,
      isOk: false,
      message: "Invalid request - email already in use.",
    );
  }
}
