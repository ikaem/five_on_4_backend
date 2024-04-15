import 'package:equatable/equatable.dart';

sealed class AccessTokenDataValue {
  const AccessTokenDataValue();
}

class AccessTokenDataValueExpired extends AccessTokenDataValue
    with EquatableMixin {
  const AccessTokenDataValueExpired({
    required this.jwt,
  });

  final String jwt;

  @override
  List<Object?> get props => [
        jwt,
      ];
}

class AccessTokenDataValueInvalid extends AccessTokenDataValue
    with EquatableMixin {
  const AccessTokenDataValueInvalid({
    required this.jwt,
  });

  final String jwt;

  @override
  List<Object?> get props => [
        jwt,
      ];
}

class AccessTokenDataValueValid extends AccessTokenDataValue
    with EquatableMixin {
  const AccessTokenDataValueValid({
    required this.playerId,
    required this.authId,
  });

  final int playerId;
  final int authId;

  @override
  // TODO: implement props
  List<Object?> get props => [
        playerId,
        authId,
      ];
}
