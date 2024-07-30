import 'package:drift/drift.dart';

import '../../../../wrappers/libraries/drift/app_database.dart';
import '../../../../wrappers/local/database/database_wrapper.dart';
import 'players_data_source.dart';

// TODO move to values
class PlayersSearchFilterValue {
  PlayersSearchFilterValue({
    this.nameTerm,
  });

  final String? nameTerm;
}

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
    // TODO we should not search if there is not filters at all - just return empty stuff - we dont want to search all
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
      final nameTermVariable = Variable.withString(nameTerm);
      final isSimilarFirstNameExpression = CustomExpression<bool>(
        // TODO maybe levenhstein is not that good for this - maybe there is better
        "LEVENSHTEIN(first_name, '${nameTermVariable.value}') <= 3",
        // precedence: Precedence.primary,
      );

      final isSimilarLastNameNameExpression = CustomExpression<bool>(
        // TODO maybe levenhstein is not that good for this - maybe there is better
        "LEVENSHTEIN(last_name, '${nameTermVariable.value}') <= 3",
        // precedence: Precedence.primary,
      );

      final isSimilarNickNameExpression = CustomExpression<bool>(
        // TODO maybe levenhstein is not that good for this - maybe there is better
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

    // final isSimilarFirstNameExpression = CustomExpression<bool>(
    //   "LEVENSHTEIN(first_name, ?) < 2",
    //   [searchTerm],
    // );

    // findPlayers = findPlayers
    //   ..where((tbl) {
    //     // TODO note the I
    //     return isSimilarFirstNameExpression |
    //         isSimilarLastNameNameExpression |
    //         isSimilarNickNameExpression;
    //   });

    final players = await (findPlayers..limit(5)).get();

    return players;

    // conditional stuff here
  }
}
