// nickname does not exist on particpation, but we will join player tzo get it

import 'package:equatable/equatable.dart';

class PlayerMatchParticipationModel extends Equatable {
  const PlayerMatchParticipationModel({
    required this.id,
    required this.status,
    required this.playerId,
    required this.matchId,
    this.playerNickname,
  });

  final int id;
  final String status;
  final int playerId;
  final int matchId;
  final String? playerNickname;

  @override
  List<Object?> get props => [
        id,
        status,
        playerId,
        matchId,
        playerNickname,
      ];
}
