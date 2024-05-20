import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../../core/domain/use_cases/create_jwt_access_token_cookie/create_jwt_access_token_cookie_use_case.dart';
import '../../../../core/domain/values/response_body_value.dart';
import '../../../../core/utils/extensions/request_extension.dart';
import '../../../../core/utils/helpers/generate_response.dart';
import '../../../../core/utils/helpers/response_generator.dart';
import '../../../../players/domain/use_cases/get_player_by_auth_id/get_player_by_auth_id_use_case.dart';
import '../../../domain/use_cases/create_access_jwt/create_access_jwt_use_case.dart';
import '../../../domain/use_cases/create_refresh_jwt_cookie/create_refresh_jwt_cookie_use_case.dart';
import '../../../domain/use_cases/google_login/google_login_use_case.dart';
import '../../../utils/constants/authenticate_with_google_request_body_key_constants.dart';
import '../../../utils/helpers/generate_auth_access_token_payload.dart';
import '../../../utils/helpers/generate_auth_response_payload.dart';

class GoogleLoginController {
  GoogleLoginController({
    required GoogleLoginUseCase googleLoginUseCase,
    required GetPlayerByAuthIdUseCase getPlayerByAuthIdUseCase,
    required CreateAccessJwtUseCase createAccessJwtUseCase,
    required CreateRefreshJwtCookieUseCase createRefreshJwtCookieUseCase,
    // required CreateJWTAccessTokenCookieUseCase
    //     createJWTAccessTokenCookieUseCase,
  })  : _googleLoginUseCase = googleLoginUseCase,
        _getPlayerByAuthIdUseCase = getPlayerByAuthIdUseCase,
        _createAccessJwtUseCase = createAccessJwtUseCase,
        _createRefreshJwtCookieUseCase = createRefreshJwtCookieUseCase;

  // _createJWTAccessTokenCookieUseCase = createJWTAccessTokenCookieUseCase;

  final GoogleLoginUseCase _googleLoginUseCase;
  final GetPlayerByAuthIdUseCase _getPlayerByAuthIdUseCase;
  final CreateAccessJwtUseCase _createAccessJwtUseCase;
  final CreateRefreshJwtCookieUseCase _createRefreshJwtCookieUseCase;
  // final CreateJWTAccessTokenCookieUseCase _createJWTAccessTokenCookieUseCase;

  Future<Response> call(Request request) async {
    // final bodyMap = await request.parseBody();
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
    // if (idToken == null) {
    //   // TODcreate proper response for this
    //   // TODO type all responses somehow so they are all uniform
    //   // return Response(400,
    //   //     body: jsonEncode({
    //   //       "ok": false,
    //   //       "message": "Invalid payload provided. Google idToken is required.",
    //   //     }));
    //   final response = ResponseGenerator.failure(
    //     message: "Invalid payload provided. Google idToken is required.",
    //     statusCode: HttpStatus.badRequest,
    //   );
    //   return response;
    // }

    // now we have the idToken, we can call the use case
    final authId = await _googleLoginUseCase(idToken: idToken);
    // TODO this could return full auth model probably, like register and login to
    if (authId == null) {
      final response = ResponseGenerator.failure(
        message: "Invalid Google idToken provided.",
        statusCode: HttpStatus.unauthorized,
      );
      return response;
      // return Response(
      //   400,
      //   body: jsonEncode(
      //     {
      //       "ok": false,
      //       "message": "Invalid Google idToken provided.",
      //     },
      //   ),
      // );
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

      // return Response(404,
      //     body: jsonEncode({
      //       "ok": false,
      //       "message": "Authenticated player not found",
      //     }));
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

    // final authAccessTokenPayload = generateAuthAccessTokenPayload(
    //   authId: authId,
    //   playerId: player.id,
    // );
    // final authCookie = _createJWTAccessTokenCookieUseCase(
    //   payload: authAccessTokenPayload,
    //   expiresIn: Duration(days: 7),
    // );

    // final responseData = generateAuthOkResponseData(
    //   playerId: player.id,
    //   playerName: player.name,
    //   playerNickname: player.nickname,
    // );

    // final responseBody = ResponseBodyValue(
    //   message: "User authenticated successfully.",
    //   ok: true,
    //   data: generateAuthOkResponseData(
    //     playerId: player.id,
    //     playerNickname: player.nickname,
    //     playerName: player.name,
    //   ),
    // );

    // return generateResponse(
    //   statusCode: HttpStatus.ok,
    //   body: responseBody,
    //   cookies: [authCookie],
    // );

    /* 
    TODO this should work better
          final cookieToString = Cookie("mycookie", "value").toString();
      final cookieToString2 = Cookie("mycookie2", "value2").toString();

      final response2 = Response.ok("hello2", headers: {
        // "set-cookie": "mycookie=test; HttpOnly; SameSite=Strict; Secure",
        // "set-cookie": Cookie("mycookie", "value".toString()),
        "set-cookie": [
          cookieToString,
          cookieToString2,
        ],
      });

      return response2;
    
     */

// TODO leave commented out for now to know how to handle cookies
    // final response = generateResponse(
    //   statusCode: HttpStatus.ok,
    //   isOk: true,
    //   message: message,
    // );

    // return Response.ok(
    //   jsonEncode(responsePayload),
    //   headers: {
    //     "Content-Type": "application/json",
    //     "Set-Cookie": [
    //       authCookie.toString(),
    //     ],
    //   },
    // );
  }
}

  // Map<String, dynamic> _generateAuthAccessTokenPayload({
  //   required int authId,
  //   required int playerId,
  // }) {
  //   return {
  //     "authId": authId,
  //     "playerId": playerId,
  //   };
  // }

//   Map<String, dynamic> _generateResponsePayload({
//     required bool ok,
//     required int playerId,
//     required String playerName,
//     required String playerNickname,
//   }) {
//     return {
//       "ok": ok,
//       "data": {
//         "id": playerId,
//         "name": playerName,
//         "nickname": playerNickname,
//       },
//       "message": "User authenticated successfully.",
//     };
//   }
// }
