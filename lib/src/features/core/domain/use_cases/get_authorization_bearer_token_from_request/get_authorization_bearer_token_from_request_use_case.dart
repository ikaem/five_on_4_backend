import 'dart:io';

import 'package:shelf/shelf.dart';

class GetAuthorizationBearerTokenFromRequestHeadersUseCase {
  const GetAuthorizationBearerTokenFromRequestHeadersUseCase();

  String? call({
    // required Map<String, String> headers,
    required Request request,
  }) {
    final headers = request.headers;
    final authorizationHeader = headers[HttpHeaders.authorizationHeader];
    if (authorizationHeader == null) {
      return null;
    }

    final authorizationHeaderParts = authorizationHeader.split(" ");
    if (authorizationHeaderParts.length != 2) {
      return null;
    }

    final authorizationType = authorizationHeaderParts[0];
    if (authorizationType != "Bearer") {
      return null;
    }

    return authorizationHeaderParts[1];
  }
}
