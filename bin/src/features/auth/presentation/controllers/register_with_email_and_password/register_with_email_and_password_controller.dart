import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../../core/domain/use_cases/create_jwt_access_token_cookie/create_jwt_access_token_cookie_use_case.dart';
import '../../../../core/domain/use_cases/get_hashed_value/get_hashed_value_use_case.dart';
import '../../../../core/domain/values/response_body_value.dart';
import '../../../../core/utils/extensions/request_extension.dart';
import '../../../../core/utils/helpers/generate_response.dart';
import '../../../../core/utils/helpers/response_generator.dart';
import '../../../../players/domain/use_cases/get_player_by_auth_id/get_player_by_auth_id_use_case.dart';
import '../../../domain/use_cases/create_access_jwt/create_access_jwt_use_case.dart';
import '../../../domain/use_cases/create_refresh_jwt_cookie/create_refresh_jwt_cookie_use_case.dart';
import '../../../domain/use_cases/get_auth_by_email/get_auth_by_email_use_case.dart';
import '../../../domain/use_cases/register_with_email_and_password/register_with_email_and_password_use_case.dart';
import '../../../utils/constants/register_with_email_and_password_request_body_key_constants.dart';
import '../../../utils/helpers/generate_auth_access_token_payload.dart';
import '../../../utils/helpers/generate_auth_response_payload.dart';

class RegisterWithEmailAndPasswordController {
  RegisterWithEmailAndPasswordController({
    required GetAuthByEmailUseCase getAuthByEmailUseCase,
    required GetHashedValueUseCase getHashedValueUseCase,
    required RegisterWithEmailAndPasswordUseCase
        registerWithEmailAndPasswordUseCase,
    required GetPlayerByAuthIdUseCase getPlayerByAuthIdUseCase,
    required CreateAccessJwtUseCase createAccessJwtUseCase,
    required CreateRefreshJwtCookieUseCase createRefreshJwtCookieUseCase,
    // required CreateJWTAccessTokenCookieUseCase
    //     createJWTAccessTokenCookieUseCase,
  })  : _getAuthByEmailUseCase = getAuthByEmailUseCase,
        _getHashedValueUseCase = getHashedValueUseCase,
        _registerWithEmailAndPasswordUseCase =
            registerWithEmailAndPasswordUseCase,
        _getPlayerByAuthIdUseCase = getPlayerByAuthIdUseCase,
        _createAccessJwtUseCase = createAccessJwtUseCase,
        _createRefreshJwtCookieUseCase = createRefreshJwtCookieUseCase;

  // _createJWTAccessTokenCookieUseCase = createJWTAccessTokenCookieUseCase;

  final GetAuthByEmailUseCase _getAuthByEmailUseCase;
  final GetHashedValueUseCase _getHashedValueUseCase;
  final RegisterWithEmailAndPasswordUseCase
      _registerWithEmailAndPasswordUseCase;
  final GetPlayerByAuthIdUseCase _getPlayerByAuthIdUseCase;
  // final CreateJWTAccessTokenCookieUseCase _createJWTAccessTokenCookieUseCase;
  final CreateAccessJwtUseCase _createAccessJwtUseCase;
  final CreateRefreshJwtCookieUseCase _createRefreshJwtCookieUseCase;

  Future<Response> call(
    Request request,
    // String id,
  ) async {
    // final bodyMap = await request.parseBody();
    // final email =
    //     bodyMap[RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value]
    //         as String;

    final validatedBodyData = request.getValidatedBodyData();
    if (validatedBodyData == null) {
      final response = ResponseGenerator.failure(
        message: "Request body not validated.",
        statusCode: HttpStatus.internalServerError,
      );

      return response;
    }

    final email = validatedBodyData[
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.EMAIL.value]
        as String;

    final auth = await _getAuthByEmailUseCase(email: email);
    if (auth != null) {
      final response = ResponseGenerator.failure(
        message: "Invalid request - email already in use.",
        statusCode: HttpStatus.badRequest,
      );
      return response;
    }

    final password = validatedBodyData[
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.PASSWORD.value]
        as String;
    final firstName = validatedBodyData[
        RegisterWithEmailAndPasswordRequestBodyKeyConstants
            .FIRST_NAME.value] as String;
    final lastName = validatedBodyData[
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.LAST_NAME.value]
        as String;
    final nickname = validatedBodyData[
            RegisterWithEmailAndPasswordRequestBodyKeyConstants.NICKNAME.value]
        as String;

    final hashedPassword = _getHashedValueUseCase(value: password);

    final authId = await _registerWithEmailAndPasswordUseCase(
      email: email,
      hashedPassword: hashedPassword,
      firstName: firstName,
      lastName: lastName,
      nickname: nickname,
    );

    final player = await _getPlayerByAuthIdUseCase(authId: authId);
    if (player == null) {
      // TODO this is major error - log it, and test it, and do something about it
      final response = ResponseGenerator.failure(
        message: "Authenticated player not found.",
        statusCode: HttpStatus.internalServerError,
      );
      return response;
    }

    final accessToken = _createAccessJwtUseCase(
      authId: authId,
      playerId: player.id,
    );
    final refreshTokenCookie = _createRefreshJwtCookieUseCase(
      authId: authId,
      playerId: player.id,
    );

    final response = ResponseGenerator.auth(
      message: "User registered successfully",
      data: generateAuthOkResponseData(
        playerId: player.id,
        playerName: player.name,
        playerNickname: player.nickname,
      ),
      accessToken: accessToken,
      refreshTokenCookie: refreshTokenCookie,
    );

    return response;

    // final authAcessTokenPayload = generateAuthAccessTokenPayload(
    //   authId: authId,
    //   playerId: player.id,
    // );
    // final authCookie = _createJWTAccessTokenCookieUseCase(
    //   payload: authAcessTokenPayload,
    //   // TODO this is liable to mistake when used in different places - abstract it better
    //   expiresIn: const Duration(days: 7),
    // );

    // final responseBody = ResponseBodyValue(
    //   message: "User authenticated successfully.",
    //   ok: true,
    //   data: generateAuthOkResponseData(
    //     playerId: player.id,
    //     playerName: player.name,
    //     playerNickname: player.nickname,
    //   ),
    // );

    // return generateResponse(
    //   statusCode: HttpStatus.ok,
    //   body: responseBody,
    //   // TODO this will need proper cookies
    //   cookies: [authCookie],
    // );
  }
}
