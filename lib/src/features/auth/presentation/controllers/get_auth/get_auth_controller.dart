import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../../core/domain/use_cases/get_authorization_bearer_token_from_request/get_authorization_bearer_token_from_request_use_case.dart';
import '../../../../core/domain/use_cases/get_refresh_token_data_from_access_jwt/get_refresh_token_data_from_access_jwt_use_case.dart';
import '../../../../core/domain/values/access_token_data_value.dart';
import '../../../../core/utils/helpers/response_generator.dart';
import '../../../../players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../../../domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../utils/helpers/generate_auth_response_payload.dart';

class GetAuthController {
  const GetAuthController({
    required GetAuthorizationBearerTokenFromRequestHeadersUseCase
        getAuthorizationBearerTokenFromRequestHeadersUseCase,
    required GetAccessTokenDataFromAccessJwtUseCase
        getAccessTokenDataFromAccessJwtUseCase,
    required GetAuthByIdUseCase getAuthByIdUseCase,
    required GetPlayerByIdUseCase getPlayerByIdUseCase,
  })  : _getAuthorizationBearerTokenFromRequestHeadersUseCase =
            getAuthorizationBearerTokenFromRequestHeadersUseCase,
        _getAccessTokenDataFromAccessJwtUseCase =
            getAccessTokenDataFromAccessJwtUseCase,
        _getAuthByIdUseCase = getAuthByIdUseCase,
        _getPlayerByIdUseCase = getPlayerByIdUseCase;

  final GetAuthorizationBearerTokenFromRequestHeadersUseCase
      _getAuthorizationBearerTokenFromRequestHeadersUseCase;
  final GetAccessTokenDataFromAccessJwtUseCase
      _getAccessTokenDataFromAccessJwtUseCase;
  final GetAuthByIdUseCase _getAuthByIdUseCase;
  final GetPlayerByIdUseCase _getPlayerByIdUseCase;

  Future<Response> call(Request request) async {
    final accessToken = _getAuthorizationBearerTokenFromRequestHeadersUseCase(
      request: request,
    );
    if (accessToken == null) {
      return ResponseGenerator.failure(
        message: "No access token found in request.",
        statusCode: HttpStatus.unauthorized,
      );
    }

    final accessTokenData = _getAccessTokenDataFromAccessJwtUseCase(
      jwt: accessToken,
    );

    switch (accessTokenData) {
      case AccessTokenDataValueInvalid():
        return ResponseGenerator.failure(
          message: "Invalid access token.",
          statusCode: HttpStatus.unauthorized,
        );
      case AccessTokenDataValueExpired():
        return ResponseGenerator.failure(
          message: "Expired access token.",
          statusCode: HttpStatus.unauthorized,
        );
      case AccessTokenDataValueValid():

        // TODO move this to a function

        final authid = accessTokenData.authId;
        final auth = await _getAuthByIdUseCase(id: authid);
        if (auth == null) {
          return ResponseGenerator.failure(
            message: "Auth not found.",
            statusCode: HttpStatus.unauthorized,
          );
        }

        final playerId = accessTokenData.playerId;
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

        return ResponseGenerator.success(
          message: "User authentication retrieved successfully.",
          data: generateAuthOkResponseData(
            playerId: player.id,
            // TODO was here before
            // playerName: player.name,
            // TODO temp solution
            playerName: '${player.firstName} ${player.lastName}',
            playerNickname: player.nickname,
          ),
        );
    }
  }
}
