import 'package:equatable/equatable.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/data/entities/player_match_participation_entity.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/values/store_player_match_participation_value.dart';

abstract interface class PlayerMatchParticipationsDataSource {
  // TODO deprecated
  // Future<int> createParticipation({
  //   required CreatePlayerMatchParticipationValue value,
  // });

  // TODO create storeParticipation - it should be upsert, and it should use that unique combination to always write on the same one? right? not sure?
  Future<int> storeParticipation({
    required StorePlayerMatchParticipationValue value,
  });
}

// TODO not needed yet
// TODO move to values later

// TODO move to values


// TODO not needed
// class CreatePlayerMatchParticipationValue {
//   CreatePlayerMatchParticipationValue({
//     required this.playerId,
//     required this.matchId,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   final int playerId;
//   final int matchId;
//   // TODO this could possibly have a default value
//   final int createdAt;
//   final int updatedAt;
// }
