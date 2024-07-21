import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/core/domain/use_cases/get_authorization_bearer_token_from_request/get_authorization_bearer_token_from_request_use_case.dart';

void main() {
  final request = _MockRequest();

  // TODO tested class
  final getAuthorizationBearerTokenUseCase =
      GetAuthorizationBearerTokenFromRequestHeadersUseCase();

  tearDown(() {
    reset(request);
  });

  group("$GetAuthorizationBearerTokenFromRequestHeadersUseCase", () {
    group(".call()", () {
      // should return null when no authorization header is found
      test(
        "given request without an authorization header"
        "when .call() is called"
        "then should return null",
        () async {
          // setup
          final headers = <String, String>{};

          // given
          when(() => request.headers).thenReturn(headers);

          // when
          final result = getAuthorizationBearerTokenUseCase(
            // headers: headers,
            request: request,
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
          final headers = <String, String>{
            HttpHeaders.authorizationHeader: "not_a_b"
          };

          // given
          when(() => request.headers).thenReturn(headers);

          // when
          final result = getAuthorizationBearerTokenUseCase(
            // headers: headers,
            request: request,
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
          final headers = <String, String>{
            HttpHeaders.authorizationHeader: "Bearer token"
          };

          // given
          when(() => request.headers).thenReturn(headers);

          // when
          final result = getAuthorizationBearerTokenUseCase(
            // headers: headers,
            request: request,
          );

          // then
          expect(result, equals("token"));

          // cleanup
        },
      );
    });
  });
}

class _MockRequest extends Mock implements Request {}
