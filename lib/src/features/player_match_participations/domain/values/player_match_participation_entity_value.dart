import 'package:equatable/equatable.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/data/entities/player_match_participation_entity.dart';

class PlayerMatchParticipationEntityValue extends Equatable {
  const PlayerMatchParticipationEntityValue({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.playerId,
    required this.matchId,
    this.playerNickname,
  });

  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PlayerMatchParticipationStatus status;
  final int playerId;
  final int matchId;

  // TODO this is not in the table, but lets put it here - we will join when needed
  final String? playerNickname;

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        status,
        playerId,
        matchId,
        playerNickname,
      ];
}
