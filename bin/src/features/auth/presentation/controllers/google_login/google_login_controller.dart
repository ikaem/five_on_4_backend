import 'dart:convert';
import 'dart:developer';

import 'package:shelf/shelf.dart';

import '../../../../core/domain/use_cases/create_jwt_access_token_cookie/create_jwt_access_token_cookie_use_case.dart';
import '../../../../core/utils/extensions/request_extension.dart';
import '../../../../players/domain/use_cases/get_player_by_auth_id/get_player_by_auth_id_use_case.dart';
import '../../../domain/use_cases/google_login/google_login_use_case.dart';

class GoogleLoginController {
  GoogleLoginController({
    required GoogleLoginUseCase googleLoginUseCase,
    required GetPlayerByAuthIdUseCase getPlayerByAuthIdUseCase,
    required CreateJWTAccessTokenCookieUseCase
        createJWTAccessTokenCookieUseCase,
  })  : _googleLoginUseCase = googleLoginUseCase,
        _getPlayerByAuthIdUseCase = getPlayerByAuthIdUseCase,
        _createJWTAccessTokenCookieUseCase = createJWTAccessTokenCookieUseCase;

  final GoogleLoginUseCase _googleLoginUseCase;
  final GetPlayerByAuthIdUseCase _getPlayerByAuthIdUseCase;
  final CreateJWTAccessTokenCookieUseCase _createJWTAccessTokenCookieUseCase;

  Future<Response> call(Request request) async {
    final bodyMap = await request.parseBody();

    final idToken = bodyMap["idToken"] as String?;
    if (idToken == null) {
      // TODcreate proper response for this
      // TODO type all responses somehow so they are all uniform
      return Response(400,
          body: jsonEncode({
            "ok": false,
            "message": "Invalid payload provided. Google idToken is required.",
          }));
    }

    // now we have the idToken, we can call the use case
    final authId = await _googleLoginUseCase(idToken: idToken);
    if (authId == null) {
      return Response(
        400,
        body: jsonEncode(
          {
            "ok": false,
            "message": "Invalid Google idToken provided.",
          },
        ),
      );
    }

    final player = await _getPlayerByAuthIdUseCase(authId: authId);
    if (player == null) {
      // TODO this should log somewhere - this is a critical error
      log("Authenticated player not found", name: "GoogleLoginController");

      return Response(404,
          body: jsonEncode({
            "ok": false,
            "message": "Authenticated player not found",
          }));
    }

    final authAccessTokenPayload = _generateAuthAccessTokenPayload(
      authId: authId,
      playerId: player.id,
    );
    final authCookie = _createJWTAccessTokenCookieUseCase(
      payload: authAccessTokenPayload,
      expiresIn: Duration(days: 7),
    );

    final responsePayload = _generateResponsePayload(
      ok: true,
      playerId: player.id,
      playerName: player.name,
      playerNickname: player.nickname,
    );

    return Response.ok(
      jsonEncode(responsePayload),
      headers: {
        "Content-Type": "application/json",
        "Set-Cookie": [
          authCookie.toString(),
        ],
      },
    );
  }

  Map<String, dynamic> _generateAuthAccessTokenPayload({
    required int authId,
    required int playerId,
  }) {
    return {
      "authId": authId,
      "playerId": playerId,
    };
  }

  Map<String, dynamic> _generateResponsePayload({
    required bool ok,
    required int playerId,
    required String playerName,
    required String playerNickname,
  }) {
    return {
      "ok": ok,
      "data": {
        "id": playerId,
        "name": playerName,
        "nickname": playerNickname,
      },
      "message": "User authenticated successfully.",
    };
  }
}
