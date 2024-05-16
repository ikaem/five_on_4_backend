import '../../../../../wrappers/libraries/dart_jsonwebtoken/dart_jsonwebtoken_wrapper.dart';
import '../../../utils/constants/jwt_duration_constants.dart';

class CreateAccessJwtUseCase {
  const CreateAccessJwtUseCase({
    required DartJsonWebTokenWrapper dartJsonWebTokenWrapper,
  }) : _dartJsonWebTokenWrapper = dartJsonWebTokenWrapper;

  final DartJsonWebTokenWrapper _dartJsonWebTokenWrapper;

  String call({
    required String authId,
    required String playerId,
    Duration? expiresIn,
  }) {
    final expiresInValue =
        expiresIn ?? JwtDurationConstants.ACCESS_TOKEN_DURATION.value;

    final jwt = _dartJsonWebTokenWrapper.sign(
      payload: {
        "authId": authId,
        "playerId": playerId,
      },
      expiresIn: expiresInValue,
    );

    return jwt;
  }
}
