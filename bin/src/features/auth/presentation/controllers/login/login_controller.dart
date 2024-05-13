import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../../core/domain/use_cases/create_jwt_access_token_cookie/create_jwt_access_token_cookie_use_case.dart';
import '../../../../core/domain/use_cases/get_hashed_value/get_hashed_value_use_case.dart';
import '../../../../core/domain/values/response_body_value.dart';
import '../../../../core/utils/extensions/request_extension.dart';
import '../../../../core/utils/helpers/generate_response.dart';
import '../../../../players/domain/use_cases/get_player_by_auth_id/get_player_by_auth_id_use_case.dart';
import '../../../domain/use_cases/get_auth_by_email_and_hashed_password/get_auth_by_email_and_hashed_password_use_case.dart';
import '../../../utils/constants/login_request_body_key_constants.dart';
import '../../../utils/helpers/generate_auth_access_token_payload.dart';
import '../../../utils/helpers/generate_auth_response_payload.dart';

class LoginController {
  const LoginController({
    required GetAuthByEmailAndHashedPasswordUseCase
        getAuthByEmailAndHashedPasswordUseCase,
    required GetPlayerByAuthIdUseCase getPlayerByAuthIdUseCase,
    required GetHashedValueUseCase getHashedValueUseCase,
    required CreateJWTAccessTokenCookieUseCase
        createJWTAccessTokenCookieUseCase,
  })  : _getAuthByEmailAndHashedPasswordUseCase =
            getAuthByEmailAndHashedPasswordUseCase,
        _getPlayerByAuthIdUseCase = getPlayerByAuthIdUseCase,
        _getHashedValueUseCase = getHashedValueUseCase,
        _createJWTAccessTokenCookieUseCase = createJWTAccessTokenCookieUseCase;

  final GetAuthByEmailAndHashedPasswordUseCase
      _getAuthByEmailAndHashedPasswordUseCase;
  final GetPlayerByAuthIdUseCase _getPlayerByAuthIdUseCase;
  final GetHashedValueUseCase _getHashedValueUseCase;
  final CreateJWTAccessTokenCookieUseCase _createJWTAccessTokenCookieUseCase;

  Future<Response> call(Request request) async {
    final validatedBodyData = request.getValidatedBodyData();
    if (validatedBodyData == null) {
      final responseBody = ResponseBodyValue(
        message: "Request body not validated.",
        ok: false,
      );
      return generateResponse(
        statusCode: HttpStatus.internalServerError,
        body: responseBody,
        cookies: null,
      );
    }

    final email =
        validatedBodyData[LoginRequestBodyKeyConstants.EMAIL.value] as String;
    final password =
        validatedBodyData[LoginRequestBodyKeyConstants.PASSWORD.value]
            as String;

    final hashedPassword = _getHashedValueUseCase(value: password);

    final auth = await _getAuthByEmailAndHashedPasswordUseCase(
      email: email,
      hashedPassword: hashedPassword,
    );
    if (auth == null) {
      final responseBody =
          ResponseBodyValue(message: "Invalid credentials", ok: false);
      return generateResponse(
        statusCode: HttpStatus.unauthorized,
        body: responseBody,
        cookies: null,
      );
    }

    final player = await _getPlayerByAuthIdUseCase(authId: auth.id);
    if (player == null) {
      final responseBody = ResponseBodyValue(
          message: "Authenticated player not found.", ok: false);
      return generateResponse(
        statusCode: HttpStatus.notFound,
        body: responseBody,
        cookies: null,
      );
    }

    final authAccessTokenPayload = generateAuthAccessTokenPayload(
      authId: auth.id,
      playerId: player.id,
    );
    final authCookie = _createJWTAccessTokenCookieUseCase(
      payload: authAccessTokenPayload,
      expiresIn: const Duration(days: 7),
    );

    final responseBody = ResponseBodyValue(
      message: "User logged in successfully",
      ok: true,
      data: generateAuthOkResponseData(
        playerId: player.id,
        playerName: player.name,
        playerNickname: player.nickname,
      ),
    );

    return generateResponse(
      statusCode: HttpStatus.ok,
      body: responseBody,
      cookies: [authCookie],
    );
  }
}
