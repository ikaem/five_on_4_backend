import 'dart:io';

import '../../../../../wrappers/libraries/dart_jsonwebtoken/dart_jsonwebtoken_wrapper.dart';
import '../../../utils/constants/jwt_duration_constants.dart';

class CreateRefreshJwtCookieUseCase {
  CreateRefreshJwtCookieUseCase({
    required DartJsonWebTokenWrapper dartJsonWebTokenWrapper,
  }) : _dartJsonWebTokenWrapper = dartJsonWebTokenWrapper;

  final DartJsonWebTokenWrapper _dartJsonWebTokenWrapper;

  Cookie call({
    required int authId,
    required int playerId,
    Duration? expiresIn,
  }) {
    final expiresInValue =
        expiresIn ?? JwtDurationConstants.REFRESH_TOKEN_DURATION.value;

    final jwt = _dartJsonWebTokenWrapper.sign(
      payload: {
        "authId": authId,
        "playerId": playerId,
      },
      expiresIn: expiresInValue,
    );

    final httpOnly = "HttpOnly";
    final secure = "Secure";
    final name = "refreshToken";
    // TODO what is path
    final path = "/";

    final cookieString = "$name=$jwt; $httpOnly; $secure; Path=$path";
    final cookie = Cookie.fromSetCookieValue(cookieString);

    return cookie;
  }
}
