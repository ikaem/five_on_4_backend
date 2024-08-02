import 'package:five_on_4_backend/src/features/players/domain/values/players_search_filter_value.dart';
import 'package:five_on_4_backend/src/wrappers/libraries/drift/app_database.dart';

abstract class PlayersDataSource {
  Future<PlayerEntityData?> getPlayerByAuthId({
    required int authId,
  });

  Future<PlayerEntityData?> getPlayerById({
    required int id,
  });

  // TODO this will need later a filter and pagination
  Future<List<PlayerEntityData>> searchPlayers({
    required PlayersSearchFilterValue filter,
  });
}
