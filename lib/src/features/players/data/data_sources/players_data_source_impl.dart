import 'package:drift/drift.dart';

import '../../../../wrappers/libraries/drift/app_database.dart';
import '../../../../wrappers/local/database/database_wrapper.dart';
import 'players_data_source.dart';

class PlayersDataSourceImpl implements PlayersDataSource {
  PlayersDataSourceImpl({
    required DatabaseWrapper databaseWrapper,
  }) : _databaseWrapper = databaseWrapper;

  final DatabaseWrapper _databaseWrapper;

  @override
  Future<PlayerEntityData?> getPlayerByAuthId({
    required int authId,
  }) async {
    final select = _databaseWrapper.playersRepo.select();
    final findPlayer = select..where((tbl) => tbl.authId.equals(authId));

    final player = await findPlayer.getSingleOrNull();

    return player;
  }

  @override
  Future<PlayerEntityData?> getPlayerById({
    required int id,
  }) async {
    final select = _databaseWrapper.playersRepo.select();
    final findPlayer = select..where((tbl) => tbl.id.equals(id));

    final player = await findPlayer.getSingleOrNull();

    return player;
  }
}
