import 'package:five_on_4_backend/src/features/players/domain/values/players_search_filter_value.dart';

import '../models/player_model.dart';

abstract interface class PlayersRepository {
  Future<PlayerModel?> getPlayerByAuthId({
    required int authId,
  });

  Future<PlayerModel?> getPlayerById({
    required int id,
  });

  Future<List<PlayerModel>> searchPlayers({
    required PlayersSearchFilterValue filter,
  });
}
