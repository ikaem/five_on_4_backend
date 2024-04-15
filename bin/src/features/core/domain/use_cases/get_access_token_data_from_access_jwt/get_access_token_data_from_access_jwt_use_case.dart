import '../../../../../wrappers/libraries/dart_jsonwebtoken/dart_jsonwebtoken_wrapper.dart';
import '../../exceptions/jwt_exceptions.dart';
import '../../values/access_token_data_value.dart';

class GetAccessTokenDataFromAccessJwtUseCase {
  GetAccessTokenDataFromAccessJwtUseCase({
    required DartJsonWebTokenWrapper dartJsonWebTokenWrapper,
  }) : _dartJsonWebTokenWrapper = dartJsonWebTokenWrapper;

  final DartJsonWebTokenWrapper _dartJsonWebTokenWrapper;

  AccessTokenDataValue call({
    required String jwt,
  }) {
    try {
      final jwtPayload = _dartJsonWebTokenWrapper.verify<Map<String, dynamic>>(
        token: jwt,
      );
      final playerId = jwtPayload['playerId'] as int?;
      final authId = jwtPayload['authId'] as int?;

      final isValid = playerId != null && authId != null;
      if (!isValid) {
        throw JsonWebTokenInvalidException(jwt);
      }

      return AccessTokenDataValueValid(
        playerId: playerId,
        authId: authId,
      );
    } on JsonWebTokenExpiredException {
      return AccessTokenDataValueExpired(jwt: jwt);
    } catch (e) {
      return AccessTokenDataValueInvalid(jwt: jwt);
    }
  }
}
