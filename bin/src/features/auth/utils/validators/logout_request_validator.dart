import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../core/domain/use_cases/get_access_token_data_from_access_jwt/get_access_token_data_from_access_jwt_use_case.dart';
import '../../../core/domain/use_cases/get_cookie_by_name_in_string/get_cookie_by_name_in_string_use_case.dart';
import '../../../core/domain/values/access_token_data_value.dart';
import '../../../core/domain/values/response_body_value.dart';
import '../../../core/utils/helpers/response_generator.dart';
import '../../../core/utils/validators/request_validator.dart';

// TODO this is porbably not needed - this and matching middleware can be repalced by exiting authoriuzeRequest middleware and validator
class LogoutRequestValidator implements RequestValidator {
  const LogoutRequestValidator({
    required GetCookieByNameInStringUseCase getCookieByNameInStringUseCase,
    required GetAccessTokenDataFromAccessJwtUseCase
        getAccessTokenDataFromAccessJwtUseCase,
  })  : _getCookieByNameInStringUseCase = getCookieByNameInStringUseCase,
        _getAccessTokenDataFromAccessJwtUseCase =
            getAccessTokenDataFromAccessJwtUseCase;

  final GetCookieByNameInStringUseCase _getCookieByNameInStringUseCase;
  final GetAccessTokenDataFromAccessJwtUseCase
      _getAccessTokenDataFromAccessJwtUseCase;

  @override
  ValidationHandler validate(
          {required ValidatedRequestHandler validatedRequestHandler}) =>
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
            cookies: [],
          );
        }

        final accessTokenCookie = _getCookieByNameInStringUseCase(
          cookiesString: requestCookies,
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
            cookies: [],
          );
        }

        // now we have accessToken cookie
        final accessTokenData = _getAccessTokenDataFromAccessJwtUseCase(
          jwt: accessTokenCookie.value,
        );

        switch (accessTokenData) {
          case AccessTokenDataValueExpired():
            {
              final responseBody = ResponseBodyValue(
                message: "Expired auth token in cookie.",
                ok: false,
              );
              return generateResponse(
                statusCode: HttpStatus.badRequest,
                body: responseBody,
                cookies: [],
              );
            }
          case AccessTokenDataValueInvalid():
            {
              final responseBody = ResponseBodyValue(
                message: "Invalid auth token in cookie.",
                ok: false,
              );
              return generateResponse(
                statusCode: HttpStatus.badRequest,
                body: responseBody,
                cookies: [],
              );
            }
          case AccessTokenDataValueValid():
            {
              return validatedRequestHandler(request);
            }
        }
      };

  // FutureOr<Response?> validate(
  //   Request request,
  // ) async {
  //   final requestCookies = request.headers[HttpHeaders.cookieHeader];
  //   if (requestCookies == null) {
  //     final responseBody = ResponseBodyValue(
  //       message: "No cookies found in request.",
  //       ok: false,
  //     );
  //     return generateResponse(
  //       statusCode: HttpStatus.badRequest,
  //       body: responseBody,
  //       cookies: [],
  //     );
  //   }

  //   final accessTokenCookie = _getCookieByNameInStringUseCase(
  //     cookiesString: requestCookies,
  //     cookieName: "accessToken",
  //   );
  //   if (accessTokenCookie == null) {
  //     final responseBody = ResponseBodyValue(
  //       message: "No accessToken cookie found in request.",
  //       ok: false,
  //     );
  //     return generateResponse(
  //       statusCode: HttpStatus.badRequest,
  //       body: responseBody,
  //       cookies: [],
  //     );
  //   }

  //   // now we have accessToken cookie
  //   final accessTokenData = _getAccessTokenDataFromAccessJwtUseCase(
  //     jwt: accessTokenCookie.value,
  //   );

  //   switch (accessTokenData) {
  //     case AccessTokenDataValueExpired():
  //       {
  //         final responseBody = ResponseBodyValue(
  //           message: "Expired auth token in cookie.",
  //           ok: false,
  //         );
  //         return generateResponse(
  //           statusCode: HttpStatus.badRequest,
  //           body: responseBody,
  //           cookies: [],
  //         );
  //       }
  //     case AccessTokenDataValueInvalid():
  //       {
  //         final responseBody = ResponseBodyValue(
  //           message: "Invalid auth token in cookie.",
  //           ok: false,
  //         );
  //         return generateResponse(
  //           statusCode: HttpStatus.badRequest,
  //           body: responseBody,
  //           cookies: [],
  //         );
  //       }
  //     case AccessTokenDataValueValid():
  //       {
  //         return null;
  //       }
  //   }
  // }
}
