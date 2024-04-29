import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../../wrappers/local/custom_middleware/custom_middleware_wrapper.dart';
import '../controllers/create_match_controller.dart';
import '../controllers/get_match_controller.dart';

class MatchesRouter {
  MatchesRouter({
    required GetMatchController getMatchController,
    required CreateMatchController createMatchController,
    required CustomMiddlewareWrapper requestAuthorizationMiddleware,
    required CustomMiddlewareWrapper matchCreateRequestMiddleware,
  }) {
    final matchesRouter = Router();

    matchesRouter.post(
      "/",
      Pipeline()
          .addMiddleware(requestAuthorizationMiddleware())
          .addMiddleware(matchCreateRequestMiddleware())
          .addHandler(createMatchController.call),
    );

    matchesRouter.get(
      "/<id>",
      Pipeline()
          .addMiddleware(requestAuthorizationMiddleware())
          .addHandler(getMatchController.call),
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
