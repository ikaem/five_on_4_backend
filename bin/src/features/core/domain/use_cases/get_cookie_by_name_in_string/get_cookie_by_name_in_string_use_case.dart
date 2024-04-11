import 'dart:io';

import '../../../../../wrappers/local/cookies_handler/cookies_handler_wrapper.dart';

class GetCookieByNameInStringUseCase {
  GetCookieByNameInStringUseCase({
    required CookiesHandlerWrapper cookiesHandlerWrapper,
  }) : _cookiesHandlerWrapper = cookiesHandlerWrapper;

  final CookiesHandlerWrapper _cookiesHandlerWrapper;

  Cookie? call({
    required String cookiesString,
    required String cookieName,
  }) {
    return _cookiesHandlerWrapper.findCookieByNameInString(
      cookiesString: cookiesString,
      cookieName: cookieName,
    );
  }
}
