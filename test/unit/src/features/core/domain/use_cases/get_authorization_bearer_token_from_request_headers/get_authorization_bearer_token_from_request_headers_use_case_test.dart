import 'dart:io';

import 'package:test/test.dart';

import '../../../../../../../../bin/src/features/core/domain/use_cases/get_authorization_bearer_token_from_request_headers/get_authorization_bearer_token_from_request_headers_use_case.dart';

void main() {
  // TODO tested class
  final getAuthorizationBearerTokenUseCase =
      GetAuthorizationBearerTokenFromRequestHeadersUseCase();

  group("$GetAuthorizationBearerTokenFromRequestHeadersUseCase", () {
    group(".call()", () {
      // should return null when no authorization header is found
      test(
        "given request headers without an authorization header"
        "when .call() is called"
        "then should return null",
        () async {
          // setup

          // given
          final headers = <String, String>{};

          // when
          final result = getAuthorizationBearerTokenUseCase(
            headers: headers,
          );

          // then
          expect(result, isNull);

          // cleanup
        },
      );

      // should return null when authorization header is not a bearer token
      test(
        "given request headers with an authorization header that is not a bearer token"
        "when .call() is called"
        "then should return null",
        () async {
          // setup

          // given
          final headers = <String, String>{
            HttpHeaders.authorizationHeader: "not_a_b"
          };

          // when
          final result = getAuthorizationBearerTokenUseCase(
            headers: headers,
          );

          // then
          expect(result, isNull);

          // cleanup
        },
      );

      // should return the bearer token when authorization header is a bearer token
      test(
        "given request headers with an authorization header that is a bearer token"
        "when .call() is called"
        "then should return the bearer token",
        () async {
          // setup

          // given
          final headers = <String, String>{
            HttpHeaders.authorizationHeader: "Bearer token"
          };

          // when
          final result = getAuthorizationBearerTokenUseCase(
            headers: headers,
          );

          // then
          expect(result, equals("token"));

          // cleanup
        },
      );
    });
  });
}
