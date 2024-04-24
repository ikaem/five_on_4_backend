import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
// import '../../../../wrappers/local/custom_middleware/custom_middleware.dart';
import '../../../auth/domain/use_cases/get_auth_by_id/get_auth_by_id_use_case.dart';
// import '../../../auth/utils/middlewares/another_authorization_middleware.dart';
// import '../../../auth/utils/middlewares/authorization_middleware.dart';
import '../../../core/domain/use_cases/get_access_token_data_from_access_jwt/get_access_token_data_from_access_jwt_use_case.dart';
import '../../../core/domain/use_cases/get_cookie_by_name_in_string/get_cookie_by_name_in_string_use_case.dart';
import '../../../core/domain/values/access_token_data_value.dart';
import '../../../../wrappers/local/custom_middleware/custom_middleware_wrapper.dart';
import '../../../players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';
import '../controllers/get_match_controller.dart';

class MatchesRouter {
  MatchesRouter({
    required GetMatchController getMatchController,
    // required AuthorizationMiddleware authorizationMiddleware,
    // required AnotherAuthorizationMiddleware anotherAuthorizationMiddleware,
    required CustomMiddlewareWrapper requestAuthorizationMiddleware,
  }) {
    final matchesRouter = Router();

    // matchesRouter.get("/<id>", getMatchController.call);
    matchesRouter.get(
      "/<id>",

      Pipeline()
          // .addMiddleware(authorizationMiddleware())
          // .addMiddleware(someRandomMiddleware())
          // .addMiddleware(anotherAuthorizationMiddleware())
          .addMiddleware(requestAuthorizationMiddleware())
          .addHandler(getMatchController.call),
      // Pipeline().addMiddleware((request) {
      //   manualMiddlere() {}

      //   // final middleware = authorizationMiddleware()(request);

      //   // return middleware;

      //   // final middw = createMiddleware();
      //   // return middw(request);

      //   // final what =  middw(request);

      //   // return what();
      // })

      // .addHandler(getMatchController.call),
      // (Request request) async {
      //   final response = await getMatchController.call(request);
      //   return response;
      // },
    );

    _router = matchesRouter;
  }

  late final Router _router;
  Router get router => _router;
}

Middleware someRandomMiddleware() => (innerHandler) {
      return (request) {
        // TODO here we can validate? and return responses
        return Future.sync(() {
          return innerHandler(request);
        }).then((response) {
          print("request here: $request");
          print("inner handler here: $innerHandler");
          return response;
        });
      };
    };

// TODO move this somewhere
// TODO maybe make interface for validators?
// TODO this should live in utils - or in domain?
// or in presentation - because it could directly return response to user
// class AuthorizationMiddleware {
//   const AuthorizationMiddleware({
//     required GetPlayerByIdUseCase getPlayerByIdUseCase,
//     required GetAuthByIdUseCase getAuthByIdUseCase,
//     required GetCookieByNameInStringUseCase getCookieByNameInStringUseCase,
//     required GetAccessTokenDataFromAccessJwtUseCase
//         getAccessTokenDataFromAccessJwtUseCase,
//   })  : _getPlayerByIdUseCase = getPlayerByIdUseCase,
//         _getAuthByIdUseCase = getAuthByIdUseCase,
//         _getCookieByNameInStringUseCase = getCookieByNameInStringUseCase,
//         _getAccessTokenDataFromAccessJwtUseCase =
//             getAccessTokenDataFromAccessJwtUseCase;

//   final GetCookieByNameInStringUseCase _getCookieByNameInStringUseCase;
//   final GetAccessTokenDataFromAccessJwtUseCase
//       _getAccessTokenDataFromAccessJwtUseCase;
//   final GetPlayerByIdUseCase _getPlayerByIdUseCase;
//   final GetAuthByIdUseCase _getAuthByIdUseCase;

//   Middleware call() {
//     // TODO test this
//     final middleware = createMiddleware(
//       requestHandler: (Request request) async {
//         final requestCookies = request.headers[HttpHeaders.cookieHeader];
//         if (requestCookies == null) {
//           return _generateBadRequestResponse(
//             logMessage: "No cookies found in request.",
//             responseMessage: "No cookies found in request.",
//           );
//         }

//         // we have cookie now - we need to parse it and get the access token
//         final accessTokenCookie = _getCookieByNameInStringUseCase(
//           cookiesString: requestCookies,
//           // TODO make constants out of this
//           cookieName: "accessToken",
//         );
//         if (accessTokenCookie == null) {
//           return _generateBadRequestResponse(
//             logMessage: "No accessToken cookie found in request.",
//             responseMessage: "No accessToken cookie found in request.",
//           );
//         }

//         final accessToken = accessTokenCookie.value;
//         // now we need to pass value to use case to decode jwt
//         final accessTokenData =
//             _getAccessTokenDataFromAccessJwtUseCase(jwt: accessToken);

//         if (accessTokenData is AccessTokenDataValueInvalid) {
//           return _generateBadRequestResponse(
//             logMessage: "Invalid auth token in cookie.",
//             responseMessage: "Invalid auth token in cookie.",
//           );
//         }

//         if (accessTokenData is AccessTokenDataValueExpired) {
//           return _generateBadRequestResponse(
//             logMessage: "Expired auth token in cookie.",
//             responseMessage: "Expired auth token in cookie.",
//           );
//         }

//         final validAccessTokenData =
//             accessTokenData as AccessTokenDataValueValid;

//         // get auth id from access token
//         final authId = validAccessTokenData.authId;
//         final auth = await _getAuthByIdUseCase(id: authId);
//         if (auth == null) {
//           return _generateNonExistentResponse(
//             logMessage: "Auth not found.",
//             responseMessage: "Auth not found.",
//           );
//         }

//         // get player id from access token
//         final playerId = validAccessTokenData.playerId;
//         final player = await _getPlayerByIdUseCase(id: playerId);
//         if (player == null) {
//           return _generateNonExistentResponse(
//             logMessage: "Player not found.",
//             responseMessage: "Player not found.",
//           );
//         }

//         final doPlayerAndAuthMatch = player.authId == auth.id;
//         if (!doPlayerAndAuthMatch) {
//           return _generateBadRequestResponse(
//             logMessage: "Found player does not match auth id.",
//             responseMessage: "Found player does not match auth id.",
//           );
//         }

//         return null;
//       },
//     );

//     return middleware;
//   }

//   Response _generateBadRequestResponse({
//     required String logMessage,
//     required String responseMessage,
//   }) {
//     log(
//       logMessage,
//       name: "GetMatchController",
//     );
//     final response = Response.badRequest(
//       body: jsonEncode(
//         {
//           "ok": false,
//           "message": "Invalid request - $responseMessage.",
//         },
//       ),
//       headers: {
//         "Content-Type": "application/json",
//       },
//     );

//     return response;
//   }

//   Response _generateNonExistentResponse({
//     required String logMessage,
//     required String responseMessage,
//   }) {
//     log(
//       logMessage,
//       name: "GetMatchController",
//     );

//     final response = Response.notFound(
//       jsonEncode(
//         {
//           "ok": false,
//           "message": "Resource not found - $responseMessage.",
//         },
//       ),
//       headers: {
//         "Content-Type": "application/json",
//       },
//     );

//     return response;
//   }
// }
