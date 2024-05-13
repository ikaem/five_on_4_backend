// TODO make some abstract Validator class?
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../core/domain/values/response_body_value.dart';
import '../../../core/utils/helpers/generate_response.dart';
import '../../../core/utils/validators/request_validator.dart';
import '../../domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
import '../../../players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../../../core/domain/use_cases/get_access_token_data_from_access_jwt/get_access_token_data_from_access_jwt_use_case.dart';
import '../../../core/domain/use_cases/get_cookie_by_name_in_string/get_cookie_by_name_in_string_use_case.dart';
import '../../../core/domain/values/access_token_data_value.dart';

// TODO this middleware and validator should be used on logout too

// TODO this needs to be tested
// TODO create validator interface somewhere
class AuthorizeRequestValidator implements RequestValidator {
  const AuthorizeRequestValidator({
    required GetCookieByNameInStringUseCase getCookieByNameInStringUseCase,
    required GetAccessTokenDataFromAccessJwtUseCase
        getAccessTokenDataFromAccessJwtUseCase,
    required GetPlayerByIdUseCase getPlayerByIdUseCase,
    required GetAuthByIdUseCase getAuthByIdUseCase,
  })  : _getCookieByNameInStringUseCase = getCookieByNameInStringUseCase,
        _getAccessTokenDataFromAccessJwtUseCase =
            getAccessTokenDataFromAccessJwtUseCase,
        _getPlayerByIdUseCase = getPlayerByIdUseCase,
        _getAuthByIdUseCase = getAuthByIdUseCase;

  final GetCookieByNameInStringUseCase _getCookieByNameInStringUseCase;
  final GetAccessTokenDataFromAccessJwtUseCase
      _getAccessTokenDataFromAccessJwtUseCase;
  final GetPlayerByIdUseCase _getPlayerByIdUseCase;
  final GetAuthByIdUseCase _getAuthByIdUseCase;

  @override
  ValidationHandler validate({
    required ValidatedRequestHandler validatedRequestHandler,
  }) =>
      (Request request) async {
        final requestCookies = request.headers[HttpHeaders.cookieHeader];
        if (requestCookies == null) {
          final responseBody = ResponseBodyValue(
            message: "No cookies found in request.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            cookies: null,
          );
        }

        final accessTokenCookie = _getCookieByNameInStringUseCase(
          cookiesString: requestCookies,
          // TODO make constants out of this
          cookieName: "accessToken",
        );
        if (accessTokenCookie == null) {
          final responseBody = ResponseBodyValue(
            message: "No accessToken cookie found in request.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            // TODO this should have other cookies that the request came with
            // TODO will need another use case that should convert the string to cookies to send back
            cookies: null,
          );
        }

        final accessToken = accessTokenCookie.value;
        final accessTokenData =
            _getAccessTokenDataFromAccessJwtUseCase(jwt: accessToken);

        if (accessTokenData is AccessTokenDataValueInvalid) {
          final responseBody = ResponseBodyValue(
            message: "Invalid auth token in cookie.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            cookies: null,
          );
        }

        if (accessTokenData is AccessTokenDataValueExpired) {
          final responseBody = ResponseBodyValue(
            message: "Expired auth token in cookie.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            cookies: null,
          );
        }

        final validAccessTokenData =
            accessTokenData as AccessTokenDataValueValid;

        final authId = validAccessTokenData.authId;
        final auth = await _getAuthByIdUseCase(id: authId);
        if (auth == null) {
          final responseBody = ResponseBodyValue(
            message: "Auth not found.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.notFound,
            body: responseBody,
            cookies: null,
          );
        }

        final playerId = validAccessTokenData.playerId;
        final player = await _getPlayerByIdUseCase(id: playerId);
        if (player == null) {
          final responseBody = ResponseBodyValue(
            message: "Player not found.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.notFound,
            body: responseBody,
            cookies: null,
          );
        }

        final doPlayerAndAuthMatch = player.authId == auth.id;
        if (!doPlayerAndAuthMatch) {
          final responseBody = ResponseBodyValue(
            message: "Found player does not match auth id.",
            ok: false,
          );
          return generateResponse(
            statusCode: HttpStatus.badRequest,
            body: responseBody,
            cookies: null,
          );
        }

        return validatedRequestHandler(request);
      };

  // FutureOr<Response?> validate(Request request) async {
  //   final requestCookies = request.headers[HttpHeaders.cookieHeader];
  //   if (requestCookies == null) {
  //     return _generateBadRequestResponse(
  //       responseMessage: "No cookies found in request.",
  //     );
  //   }

  //   final accessTokenCookie = _getCookieByNameInStringUseCase(
  //     cookiesString: requestCookies,
  //     // TODO make constants out of this
  //     cookieName: "accessToken",
  //   );
  //   if (accessTokenCookie == null) {
  //     // TODO this should never retrun cookie because this is not authoirized then anyway
  //     return _generateBadRequestResponse(
  //       responseMessage: "No accessToken cookie found in request.",
  //     );
  //   }

  //   final accessToken = accessTokenCookie.value;
  //   // now we need to pass value to use case to decode jwt
  //   final accessTokenData =
  //       _getAccessTokenDataFromAccessJwtUseCase(jwt: accessToken);

  //   if (accessTokenData is AccessTokenDataValueInvalid) {
  //     return _generateBadRequestResponse(
  //       responseMessage: "Invalid auth token in cookie.",
  //     );
  //   }

  //   if (accessTokenData is AccessTokenDataValueExpired) {
  //     return _generateBadRequestResponse(
  //       responseMessage: "Expired auth token in cookie.",
  //     );
  //   }

  //   final validAccessTokenData = accessTokenData as AccessTokenDataValueValid;

  //   // get auth id from access token
  //   final authId = validAccessTokenData.authId;
  //   final auth = await _getAuthByIdUseCase(id: authId);
  //   if (auth == null) {
  //     return _generateNonExistentResponse(
  //       responseMessage: "Auth not found.",
  //     );
  //   }

  //   // get player id from access token
  //   final playerId = validAccessTokenData.playerId;
  //   final player = await _getPlayerByIdUseCase(id: playerId);
  //   if (player == null) {
  //     return _generateNonExistentResponse(
  //       responseMessage: "Player not found.",
  //     );
  //   }

  //   final doPlayerAndAuthMatch = player.authId == auth.id;
  //   if (!doPlayerAndAuthMatch) {
  //     return _generateBadRequestResponse(
  //       responseMessage: "Found player does not match auth id.",
  //     );
  //   }

  //   return null;
  // }

  // Response _generateBadRequestResponse({
  //   required String responseMessage,
  // }) {
  //   final response = Response.badRequest(
  //     body: jsonEncode(
  //       {
  //         "ok": false,
  //         "message": "Invalid request - $responseMessage.",
  //       },
  //     ),
  //     headers: {
  //       "Content-Type": "application/json",
  //     },
  //   );

  //   return response;
  // }

  // Response _generateNonExistentResponse({
  //   required String responseMessage,
  // }) {
  //   final response = Response.notFound(
  //     jsonEncode(
  //       {
  //         "ok": false,
  //         "message": "Resource not found - $responseMessage.",
  //       },
  //     ),
  //     headers: {
  //       "Content-Type": "application/json",
  //     },
  //   );

  //   return response;
  // }
}
