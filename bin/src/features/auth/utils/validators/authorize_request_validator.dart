// TODO make some abstract Validator class?
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../core/domain/use_cases/get_authorization_bearer_token_from_request_headers/get_authorization_bearer_token_from_request_headers_use_case.dart';
import '../../../core/utils/helpers/response_generator.dart';
import '../../../core/utils/validators/request_validator.dart';
import '../../domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../../../core/domain/use_cases/get_access_token_data_from_access_jwt/get_access_token_data_from_access_jwt_use_case.dart';
import '../../../core/domain/values/access_token_data_value.dart';

// TODO this middleware and validator should be used on logout too

// TODO this needs to be tested
// TODO create validator interface somewhere
class AuthorizeRequestValidator implements RequestValidator {
  const AuthorizeRequestValidator({
    required GetAuthorizationBearerTokenFromRequestHeadersUseCase
        getAuthorizationBearerTokenFromRequestHeadersUseCase,
    required GetAccessTokenDataFromAccessJwtUseCase
        getAccessTokenDataFromAccessJwtUseCase,
    required GetPlayerByIdUseCase getPlayerByIdUseCase,
    required GetAuthByIdUseCase getAuthByIdUseCase,
  })  : _getAuthorizationBearerTokenFromRequestHeadersUseCase =
            getAuthorizationBearerTokenFromRequestHeadersUseCase,
        _getAccessTokenDataFromAccessJwtUseCase =
            getAccessTokenDataFromAccessJwtUseCase,
        _getPlayerByIdUseCase = getPlayerByIdUseCase,
        _getAuthByIdUseCase = getAuthByIdUseCase;
  final GetAuthorizationBearerTokenFromRequestHeadersUseCase
      _getAuthorizationBearerTokenFromRequestHeadersUseCase;
  final GetAccessTokenDataFromAccessJwtUseCase
      _getAccessTokenDataFromAccessJwtUseCase;
  final GetPlayerByIdUseCase _getPlayerByIdUseCase;
  final GetAuthByIdUseCase _getAuthByIdUseCase;

  @override
  ValidationHandler validate({
    required ValidatedRequestHandler validatedRequestHandler,
  }) =>
      (Request request) async {
        final accessToken =
            _getAuthorizationBearerTokenFromRequestHeadersUseCase(
          headers: request.headers,
        );

        if (accessToken == null) {
          final response = ResponseGenerator.failure(
            message: "No access token found in request.",
            // TODO make it all unauthorized to make sure client can logout
            statusCode: HttpStatus.unauthorized,
          );
          return response;
        }
        final accessTokenData =
            _getAccessTokenDataFromAccessJwtUseCase(jwt: accessToken);

        if (accessTokenData is AccessTokenDataValueInvalid) {
          // TODO dont forget to log all of these so we can see what is happening
          final response = ResponseGenerator.failure(
            message: "Invalid auth token in header.",
            statusCode: HttpStatus.unauthorized,
          );
          return response;
        }

        if (accessTokenData is AccessTokenDataValueExpired) {
          final response = ResponseGenerator.failure(
            message: "Expired auth token in header.",
            statusCode: HttpStatus.unauthorized,
          );
          return response;
        }

        final validAccessTokenData =
            accessTokenData as AccessTokenDataValueValid;

        final authId = validAccessTokenData.authId;
        final auth = await _getAuthByIdUseCase(id: authId);
        if (auth == null) {
          final response = ResponseGenerator.failure(
            message: "Auth not found.",
            statusCode: HttpStatus.unauthorized,
          );
          return response;
        }

        final playerId = validAccessTokenData.playerId;
        final player = await _getPlayerByIdUseCase(id: playerId);
        if (player == null) {
          final response = ResponseGenerator.failure(
            message: "Player not found.",
            statusCode: HttpStatus.unauthorized,
          );
          return response;
        }

        final doPlayerAndAuthMatch = player.authId == auth.id;
        if (!doPlayerAndAuthMatch) {
          final response = ResponseGenerator.failure(
            message: "Found player does not match auth id.",
            statusCode: HttpStatus.unauthorized,
          );
          return response;
        }

        return validatedRequestHandler(request);
      };
}
