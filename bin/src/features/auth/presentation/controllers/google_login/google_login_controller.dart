import 'dart:developer';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../../core/utils/extensions/request_extension.dart';
import '../../../../core/utils/helpers/response_generator.dart';
import '../../../../players/domain/use_cases/get_player_by_auth_id/get_player_by_auth_id_use_case.dart';
import '../../../domain/use_cases/create_access_jwt/create_access_jwt_use_case.dart';
import '../../../domain/use_cases/create_refresh_jwt_cookie/create_refresh_jwt_cookie_use_case.dart';
import '../../../domain/use_cases/google_login/google_login_use_case.dart';
import '../../../utils/constants/authenticate_with_google_request_body_key_constants.dart';
import '../../../utils/helpers/generate_auth_response_payload.dart';

class GoogleLoginController {
  GoogleLoginController({
    required GoogleLoginUseCase googleLoginUseCase,
    required GetPlayerByAuthIdUseCase getPlayerByAuthIdUseCase,
    required CreateAccessJwtUseCase createAccessJwtUseCase,
    required CreateRefreshJwtCookieUseCase createRefreshJwtCookieUseCase,
  })  : _googleLoginUseCase = googleLoginUseCase,
        _getPlayerByAuthIdUseCase = getPlayerByAuthIdUseCase,
        _createAccessJwtUseCase = createAccessJwtUseCase,
        _createRefreshJwtCookieUseCase = createRefreshJwtCookieUseCase;

  final GoogleLoginUseCase _googleLoginUseCase;
  final GetPlayerByAuthIdUseCase _getPlayerByAuthIdUseCase;
  final CreateAccessJwtUseCase _createAccessJwtUseCase;
  final CreateRefreshJwtCookieUseCase _createRefreshJwtCookieUseCase;

  Future<Response> call(Request request) async {
    final validatedBodyData = request.getValidatedBodyData();
    if (validatedBodyData == null) {
      // TODO might be good to abstract this because it is repeated in many placed
      // TODO might be good to log this
      final response = ResponseGenerator.failure(
        message: "Request body not validated.",
        statusCode: HttpStatus.internalServerError,
      );

      return response;
    }

    final idToken = validatedBodyData[
        AuthenticateWithGoogleRequestBodyKeyConstants.ID_TOKEN.value] as String;

    final authId = await _googleLoginUseCase(idToken: idToken);
    // TODO this could return full auth model probably, like register and login to
    if (authId == null) {
      final response = ResponseGenerator.failure(
        message: "Invalid Google idToken provided.",
        statusCode: HttpStatus.unauthorized,
      );
      return response;
    }

    final player = await _getPlayerByAuthIdUseCase(authId: authId);
    if (player == null) {
      // TODO this should log somewhere - this is a critical error - maybe even delete auth
      log("Authenticated player not found", name: "GoogleLoginController");

      final response = ResponseGenerator.failure(
        message: "Authenticated player not found.",
        statusCode: HttpStatus.notFound,
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
      message: "User authenticated successfully.",
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
