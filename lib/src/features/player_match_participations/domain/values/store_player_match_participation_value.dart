import 'package:equatable/equatable.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/data/entities/player_match_participation_entity.dart';

class StorePlayerMatchParticipationValue extends Equatable {
  const StorePlayerMatchParticipationValue({
    required this.playerId,
    required this.matchId,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  final int playerId;
  final int matchId;
  // TODO this could possibly have a default value
  final int createdAt;
  final int updatedAt;
  final PlayerMatchParticipationStatus status;

  @override
  // TODO: implement props
  List<Object?> get props => [
        playerId,
        matchId,
        createdAt,
        updatedAt,
        status,
      ];
}
