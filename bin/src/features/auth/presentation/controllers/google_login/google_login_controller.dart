// TODO make interface for controllers

import 'dart:convert';
import 'dart:developer';

import 'package:shelf/shelf.dart';

import '../../../../core/utils/extensions/request_extension.dart';
import '../../../../players/domain/use_cases/get_player_by_auth_id.dart';
import '../../../domain/use_cases/google_login/google_login_use_case.dart';

class GoogleLoginController {
  GoogleLoginController({
    required GoogleLoginUseCase googleLoginUseCase,
    required GetPlayerByAuthIdUseCase getPlayerByAuthIdUseCase,
  })  : _googleLoginUseCase = googleLoginUseCase,
        _getPlayerByAuthIdUseCase = getPlayerByAuthIdUseCase;

  final GoogleLoginUseCase _googleLoginUseCase;
  final GetPlayerByAuthIdUseCase _getPlayerByAuthIdUseCase;

  Future<Response> call(Request request) async {
    // TODO lets create use case for this
    final bodyMap = await request.parseBody();

    final idToken = bodyMap["idToken"] as String?;
    if (idToken == null) {
      // TODcreate proper response for this
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

    // now we need authenticated user payload
    final player = await _getPlayerByAuthIdUseCase(authId: authId);
    if (player == null) {
      // TODO this should log somewhere - this is a critical error
      log("Authenticated player not found", name: "GoogleLoginController");
      return Response.notFound(jsonEncode({
        "ok": false,
        "message": "Authenticated player not found",
      }));
    }

    // TODO need to create jwt token here

    final responsePayload = jsonEncode({
      "ok": true,
      "data": player,
      "message": "Successfully authenticated user",
    });

    // TODO create classes as types for response payloads
    return Response.ok(jsonEncode(responsePayload), headers: {
      "Content-Type": "application/json",
      // TODO need to set cookie here
    });
  }
}
