import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../../core/domain/use_cases/get_hashed_value/get_hashed_value_use_case.dart';
import '../../../../core/utils/extensions/request_extension.dart';
import '../../../../core/utils/helpers/response_generator.dart';
import '../../../../players/domain/use_cases/get_player_by_auth_id/get_player_by_auth_id_use_case.dart';
import '../../../domain/use_cases/get_auth_by_email/get_auth_by_email_use_case.dart';
import '../../../domain/use_cases/register_with_email_and_password/register_with_email_and_password_use_case.dart';
import '../../../utils/constants/register_with_email_and_password_request_body_key_constants.dart';

class RegisterWithEmailAndPasswordController {
  RegisterWithEmailAndPasswordController({
    required GetAuthByEmailUseCase getAuthByEmailUseCase,
    required GetHashedValueUseCase getHashedValueUseCase,
    required RegisterWithEmailAndPasswordUseCase
        registerWithEmailAndPasswordUseCase,
    required GetPlayerByAuthIdUseCase getPlayerByAuthIdUseCase,
  })  : _getAuthByEmailUseCase = getAuthByEmailUseCase,
        _getHashedValueUseCase = getHashedValueUseCase,
        _registerWithEmailAndPasswordUseCase =
            registerWithEmailAndPasswordUseCase,
        _getPlayerByAuthIdUseCase = getPlayerByAuthIdUseCase;

  final GetAuthByEmailUseCase _getAuthByEmailUseCase;
  final GetHashedValueUseCase _getHashedValueUseCase;
  final RegisterWithEmailAndPasswordUseCase
      _registerWithEmailAndPasswordUseCase;
  final GetPlayerByAuthIdUseCase _getPlayerByAuthIdUseCase;

  Future<Response> call(
    Request request,
    // String id,
  ) async {
    final bodyMap = await request.parseBody();
    final email =
        bodyMap[RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value]
            as String;

    final auth = await _getAuthByEmailUseCase(email: email);

    if (auth != null) {
      return generateResponse(
        statusCode: HttpStatus.badRequest,
        isOk: false,
        message: "Invalid request - email already in use.",
      );
    }

    final password = bodyMap[RegisterWithEmailAndPasswordRequestBodyKeyConstants
        .PASSWORD.value] as String;
    final firstName = bodyMap[
        RegisterWithEmailAndPasswordRequestBodyKeyConstants
            .FIRST_NAME.value] as String;
    final lastName = bodyMap[RegisterWithEmailAndPasswordRequestBodyKeyConstants
        .LAST_NAME.value] as String;
    final nickname = bodyMap[RegisterWithEmailAndPasswordRequestBodyKeyConstants
        .NICKNAME.value] as String;

    final hashedPassword = _getHashedValueUseCase(value: password);

    final authId = await _registerWithEmailAndPasswordUseCase(
      email: email,
      password: hashedPassword,
      firstName: firstName,
      lastName: lastName,
      nickname: nickname,
    );

    final player = await _getPlayerByAuthIdUseCase(authId: authId);
    if (player == null) {
      // TODO this is major error - log it, and test it, and do something about it
      return generateResponse(
        statusCode: HttpStatus.notFound,
        isOk: false,
        message: "Authenticated player not found.",
      );
    }

    // return Response(200, body: "Success");
  }
}
