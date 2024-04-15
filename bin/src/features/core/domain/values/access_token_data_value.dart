import 'package:equatable/equatable.dart';

class AccessTokenDataValue extends Equatable {
  const AccessTokenDataValue({
    required this.playerId,
    required this.authId,
  });

  final int playerId;
  final int authId;

  @override
  List<Object?> get props => [
        playerId,
        authId,
      ];
}
