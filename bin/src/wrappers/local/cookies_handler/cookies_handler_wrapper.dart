import 'dart:io';

import 'package:collection/collection.dart';

class CookiesHandlerWrapper {
  const CookiesHandlerWrapper();

  // find cookie by name in string
  Cookie? findCookieByNameInString({
    required String cookiesString,
    required String cookieName,
  }) {
    // split all cookies into a list
    // TODO this might not be correct - but this should be habndling cookies from "cookie" header, not from "set-cookie" header, so maybe it is ok. we will see
    final cookiesStrings = cookiesString.split(";");
    // trim result so no empty spaces
    final trimmedCookiesStrings =
        cookiesStrings.map((cookie) => cookie.trim()).toList();

    // now need to find the cookie with the name
    final cookieString = trimmedCookiesStrings.firstWhereOrNull(
      (cookie) => cookie.startsWith(cookieName),
    );
    if (cookieString == null) return null;

    final cookie = Cookie.fromSetCookieValue(cookieString);

    return cookie;
  }
}
