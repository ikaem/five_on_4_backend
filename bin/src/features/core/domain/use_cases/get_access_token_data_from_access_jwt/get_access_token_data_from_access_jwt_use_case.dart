import '../../../../../wrappers/libraries/dart_jsonwebtoken/dart_jsonwebtoken_wrapper.dart';
import '../../values/access_token_data_value.dart';

class GetAccessTokenDataFromAccessJwtUseCase {
  GetAccessTokenDataFromAccessJwtUseCase({
    required DartJsonWebTokenWrapper dartJsonWebTokenWrapper,
  }) : _dartJsonWebTokenWrapper = dartJsonWebTokenWrapper;

  final DartJsonWebTokenWrapper _dartJsonWebTokenWrapper;

  AccessTokenDataValue? call({
    required String jwt,
  }) {
    final jwtPayload = _dartJsonWebTokenWrapper.verify(
      token: jwt,
    );

    if (jwtPayload.isInvalid) {
      return null;
    }

    if (jwtPayload.isExpired) {
      // TODO we should probably refresh the token here
      return null;
    }

    // TODO this could have easily been a string
    final playerId = jwtPayload.data['playerId'] as int?;
    final authId = jwtPayload.data['authId'] as int?;

    final isValid = playerId != null && authId != null;
    if (!isValid) {
      return null;
    }

    return AccessTokenDataValue(
      playerId: playerId,
      authId: authId,
    );
  }
}
