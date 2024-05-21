import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../../../../wrappers/local/cookies_handler/cookies_handler_wrapper.dart';

class GetCookieByNameInRequestUseCase {
  GetCookieByNameInRequestUseCase({
    required CookiesHandlerWrapper cookiesHandlerWrapper,
  }) : _cookiesHandlerWrapper = cookiesHandlerWrapper;

  final CookiesHandlerWrapper _cookiesHandlerWrapper;

  Cookie? call({
    required Request request,
    required String cookieName,
  }) {
    return _cookiesHandlerWrapper.findCookieByNameInRequest(
      request: request,
      cookieName: cookieName,
    );
  }
}
