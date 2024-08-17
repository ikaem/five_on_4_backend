import 'package:five_on_4_backend/src/features/player_match_participations/domain/values/store_player_match_participation_value.dart';

abstract interface class PlayerMatchParticipationsRepository {
  Future<int> storeParticipation({
    required StorePlayerMatchParticipationValue value,
  });
}
