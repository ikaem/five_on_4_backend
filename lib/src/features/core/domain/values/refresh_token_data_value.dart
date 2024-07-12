import 'package:equatable/equatable.dart';

sealed class RefreshTokenDataValue {
  const RefreshTokenDataValue();
}

class RefreshTokenDataValueExpired extends RefreshTokenDataValue
    with EquatableMixin {
  const RefreshTokenDataValueExpired({
    required this.jwt,
  });

  final String jwt;

  @override
  List<Object?> get props => [
        jwt,
      ];
}

class RefreshTokenDataValueInvalid extends RefreshTokenDataValue
    with EquatableMixin {
  const RefreshTokenDataValueInvalid({
    required this.jwt,
  });

  final String jwt;

  @override
  List<Object?> get props => [
        jwt,
      ];
}

class RefreshTokenDataValueValid extends RefreshTokenDataValue
    with EquatableMixin {
  const RefreshTokenDataValueValid({
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
