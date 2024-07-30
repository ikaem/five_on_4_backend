import 'package:five_on_4_backend/src/features/players/data/data_sources/players_data_source_impl.dart';

import '../../../../wrappers/libraries/drift/app_database.dart';

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
