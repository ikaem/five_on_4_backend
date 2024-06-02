import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../../core/domain/use_cases/get_hashed_value/get_hashed_value_use_case.dart';
import '../../../../core/utils/extensions/request_extension.dart';
import '../../../../core/utils/helpers/response_generator.dart';
import '../../../../players/domain/use_cases/get_player_by_auth_id/get_player_by_auth_id_use_case.dart';
import '../../../domain/use_cases/create_access_jwt/create_access_jwt_use_case.dart';
import '../../../domain/use_cases/create_refresh_jwt_cookie/create_refresh_jwt_cookie_use_case.dart';
import '../../../domain/use_cases/get_auth_by_email_and_hashed_password/get_auth_by_email_and_hashed_password_use_case.dart';
import '../../../utils/constants/login_request_body_key_constants.dart';
import '../../../utils/helpers/generate_auth_response_payload.dart';

class LoginController {
  const LoginController({
    required GetAuthByEmailAndHashedPasswordUseCase
        getAuthByEmailAndHashedPasswordUseCase,
    required GetPlayerByAuthIdUseCase getPlayerByAuthIdUseCase,
    required GetHashedValueUseCase getHashedValueUseCase,
    required CreateAccessJwtUseCase createAccessJwtUseCase,
    required CreateRefreshJwtCookieUseCase createRefreshJwtCookieUseCase,
  })  : _getAuthByEmailAndHashedPasswordUseCase =
            getAuthByEmailAndHashedPasswordUseCase,
        _getPlayerByAuthIdUseCase = getPlayerByAuthIdUseCase,
        _createRefreshJwtCookieUseCase = createRefreshJwtCookieUseCase,
        _createAccessJwtUseCase = createAccessJwtUseCase,
        _getHashedValueUseCase = getHashedValueUseCase;

  final GetAuthByEmailAndHashedPasswordUseCase
      _getAuthByEmailAndHashedPasswordUseCase;
  final GetPlayerByAuthIdUseCase _getPlayerByAuthIdUseCase;
  final GetHashedValueUseCase _getHashedValueUseCase;
  final CreateAccessJwtUseCase _createAccessJwtUseCase;
  final CreateRefreshJwtCookieUseCase _createRefreshJwtCookieUseCase;

  Future<Response> call(Request request) async {
    final validatedBodyData = request.getValidatedBodyData();
    if (validatedBodyData == null) {
      final response = ResponseGenerator.failure(
        message: "Request body not validated.",
        statusCode: HttpStatus.internalServerError,
      );

      return response;
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
      final response = ResponseGenerator.failure(
        message: "Invalid credentials",
        statusCode: HttpStatus.unauthorized,
      );
      return response;
    }

    final player = await _getPlayerByAuthIdUseCase(authId: auth.id);
    if (player == null) {
      final response = ResponseGenerator.failure(
        message: "Authenticated player not found.",
        statusCode: HttpStatus.notFound,
      );
      return response;
    }

    final accessToken = _createAccessJwtUseCase(
      authId: auth.id,
      playerId: player.id,
    );
    final refreshTokenCookie = _createRefreshJwtCookieUseCase(
      authId: auth.id,
      playerId: player.id,
    );

// TODO this response data should actuall be a model retruened by some use case - only return models
    final response = ResponseGenerator.auth(
      message: "User logged in successfully",
      data: generateAuthOkResponseData(
        playerId: player.id,
        playerName: player.name,
        playerNickname: player.nickname,
      ),
      accessToken: accessToken,
      refreshTokenCookie: refreshTokenCookie,
    );

    return response;
  }
}
