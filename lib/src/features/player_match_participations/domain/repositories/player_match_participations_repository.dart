import 'package:five_on_4_backend/src/features/player_match_participations/domain/values/store_player_match_participation_value.dart';

abstract interface class PlayerMatchParticipationsRepository {
  Future<int> storeParticipation({
    required StorePlayerMatchParticipationValue value,
  });

  // TODO we should have option to store multiple participations at once
  // in this case, we would store it for multiple players, but for the same match
  // also, it would only be for one type of status - for now
  // TODO this is after, not needed right now, and maybe not needed at all
}
