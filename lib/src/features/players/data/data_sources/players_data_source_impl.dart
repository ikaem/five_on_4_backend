import 'package:drift/drift.dart';
import 'package:five_on_4_backend/src/features/players/domain/values/players_search_filter_value.dart';
import 'package:five_on_4_backend/src/wrappers/libraries/drift/app_database.dart';
import 'package:five_on_4_backend/src/wrappers/local/database/database_wrapper.dart';

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

  @override
  Future<List<PlayerEntityData>> searchPlayers({
    required PlayersSearchFilterValue filter,
  }) async {
    final nameTerm = filter.nameTerm;

    // TODO this will later have more filters added to this possibly
    final isValidSearchFilter = nameTerm != null;
    if (!isValidSearchFilter) {
      return [];
    }

    final select = _databaseWrapper.playersRepo.select();

    // TODO I hope this will handle sanitization
    SimpleSelectStatement<$PlayerEntityTable, PlayerEntityData> findPlayers =
        select;

    // TODO checking here because there will probably be more filters coming in
    // ignore: unnecessary_null_comparison
    if (nameTerm != null) {
      // TODO maybe levenhstein is not that good for this - maybe there is better
      final nameTermVariable = Variable.withString(nameTerm);
      final isSimilarFirstNameExpression = CustomExpression<bool>(
        "LEVENSHTEIN(first_name, '${nameTermVariable.value}') <= 3",
        // precedence: Precedence.primary,
      );

      final isSimilarLastNameNameExpression = CustomExpression<bool>(
        "LEVENSHTEIN(last_name, '${nameTermVariable.value}') <= 3",
        // precedence: Precedence.primary,
      );

      final isSimilarNickNameExpression = CustomExpression<bool>(
        "LEVENSHTEIN(nickname, '${nameTermVariable.value}') <= 3",
        // precedence: Precedence.primary,
      );

      findPlayers = findPlayers
        ..where((tbl) {
          return isSimilarFirstNameExpression |
              isSimilarLastNameNameExpression |
              isSimilarNickNameExpression;
        });
    }

    final players = await (findPlayers..limit(5)).get();

    return players;
  }
}
