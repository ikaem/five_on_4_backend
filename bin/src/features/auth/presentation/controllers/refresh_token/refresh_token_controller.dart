import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../../core/domain/use_cases/get_access_token_data_from_access_jwt/get_access_token_data_from_access_jwt_use_case.dart';
import '../../../../core/domain/use_cases/get_cookie_by_name_in_request/get_cookie_by_name_in_request_use_case.dart';
import '../../../../core/domain/values/refresh_token_data_value.dart';
import '../../../../core/utils/helpers/response_generator.dart';
import '../../../../players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../../../domain/use_cases/create_access_jwt/create_access_jwt_use_case.dart';
import '../../../domain/use_cases/create_refresh_jwt_cookie/create_refresh_jwt_cookie_use_case.dart';
import '../../../domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';

// TODO maybe in future, some of the logic here should be moved to a middleware
class RefreshTokenController {
  const RefreshTokenController({
    required GetCookieByNameInRequestUseCase getCookieByNameInRequestUseCase,
    required GetRefreshTokenDataFromAccessJwtUseCase
        getRefreshTokenDataFromAccessJwtUseCase,
    required GetAuthByIdUseCase getAuthByIdUseCase,
    required GetPlayerByIdUseCase getPlayerByIdUseCase,
    required CreateAccessJwtUseCase createAccessJwtUseCase,
    required CreateRefreshJwtCookieUseCase createRefreshJwtCookieUseCase,
  })  : _getCookieByNameInRequestUseCase = getCookieByNameInRequestUseCase,
        _getRefreshTokenDataFromAccessJwtUseCase =
            getRefreshTokenDataFromAccessJwtUseCase,
        _getAuthByIdUseCase = getAuthByIdUseCase,
        _getPlayerByIdUseCase = getPlayerByIdUseCase,
        _createAccessJwtUseCase = createAccessJwtUseCase,
        _createRefreshJwtCookieUseCase = createRefreshJwtCookieUseCase;

  final GetCookieByNameInRequestUseCase _getCookieByNameInRequestUseCase;
  final GetRefreshTokenDataFromAccessJwtUseCase
      _getRefreshTokenDataFromAccessJwtUseCase;
  final GetAuthByIdUseCase _getAuthByIdUseCase;
  final GetPlayerByIdUseCase _getPlayerByIdUseCase;
  final CreateAccessJwtUseCase _createAccessJwtUseCase;
  final CreateRefreshJwtCookieUseCase _createRefreshJwtCookieUseCase;

  Future<Response> call(Request request) async {
    final cookie = _getCookieByNameInRequestUseCase(
      request: request,
      cookieName: "refresh_token",
    );

    if (cookie == null) {
      final response = ResponseGenerator.failure(
        message: "No cookie found in the request.",
        statusCode: HttpStatus.badRequest,
      );

      return response;
    }

    final refreshTokenData = _getRefreshTokenDataFromAccessJwtUseCase(
      jwt: cookie.value,
    );

    switch (refreshTokenData) {
      case RefreshTokenDataValueInvalid():
        return ResponseGenerator.failure(
          message: "Refresh token invalid.",
          statusCode: HttpStatus.unauthorized,
        );
      case RefreshTokenDataValueExpired():
        return ResponseGenerator.failure(
          message: "Refresh token expired.",
          statusCode: HttpStatus.unauthorized,
        );
      case RefreshTokenDataValueValid():
// TODO abstract this to private function

        final authid = refreshTokenData.authId;
        final auth = await _getAuthByIdUseCase(id: authid);
        if (auth == null) {
          return ResponseGenerator.failure(
            message: "Auth not found.",
            statusCode: HttpStatus.unauthorized,
          );
        }

        final playerId = refreshTokenData.playerId;
        final player = await _getPlayerByIdUseCase(id: playerId);
        if (player == null) {
          return ResponseGenerator.failure(
            message: "Player not found.",
            statusCode: HttpStatus.unauthorized,
          );
        }

        final doPlayerAndAuthMatch = player.authId == auth.id;
        if (!doPlayerAndAuthMatch) {
          return ResponseGenerator.failure(
            message: "Player and auth do not match.",
            statusCode: HttpStatus.unauthorized,
          );
        }

        final accessToken = _createAccessJwtUseCase(
          authId: auth.id,
          playerId: player.id,
        );
        final refreshTokenCookie = _createRefreshJwtCookieUseCase(
          authId: auth.id,
          playerId: player.id,
        );

        return ResponseGenerator.auth(
          message: "Token refreshed successfully.",
          statusCode: HttpStatus.ok,
          // TODO maybe later we can make sure that this can be mull
          data: {},
          accessToken: accessToken,
          refreshTokenCookie: refreshTokenCookie,
        );
    }
  }
}
