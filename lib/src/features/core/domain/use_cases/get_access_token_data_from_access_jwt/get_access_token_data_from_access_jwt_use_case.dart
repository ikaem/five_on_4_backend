import '../../../../../wrappers/libraries/dart_jsonwebtoken/dart_jsonwebtoken_wrapper.dart';
import '../../exceptions/jwt_exceptions.dart';
import '../../values/refresh_token_data_value.dart';

class GetRefreshTokenDataFromAccessJwtUseCase {
  GetRefreshTokenDataFromAccessJwtUseCase({
    required DartJsonWebTokenWrapper dartJsonWebTokenWrapper,
  }) : _dartJsonWebTokenWrapper = dartJsonWebTokenWrapper;

  final DartJsonWebTokenWrapper _dartJsonWebTokenWrapper;

  RefreshTokenDataValue call({
    required String jwt,
  }) {
    try {
      final jwtPayload = _dartJsonWebTokenWrapper.verify<Map<String, dynamic>>(
        token: jwt,
      );
      // TODO move these to constants
      final playerId = jwtPayload['playerId'] as int?;
      final authId = jwtPayload['authId'] as int?;

      final isValid = playerId != null && authId != null;
      if (!isValid) {
        throw JsonWebTokenInvalidException(jwt);
      }

      return RefreshTokenDataValueValid(
        playerId: playerId,
        authId: authId,
      );
    } on JsonWebTokenExpiredException {
      return RefreshTokenDataValueExpired(jwt: jwt);
    } catch (e) {
      return RefreshTokenDataValueInvalid(jwt: jwt);
    }
  }
}
