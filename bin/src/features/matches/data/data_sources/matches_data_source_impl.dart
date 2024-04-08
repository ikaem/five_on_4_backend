import 'package:drift/drift.dart';

import '../../../../wrappers/libraries/drift/app_database.dart';
import '../../../../wrappers/local/database/database_wrapper.dart';
import 'matches_data_source.dart';

class MatchesDataSourceImpl implements MatchesDataSource {
  MatchesDataSourceImpl({
    required DatabaseWrapper databaseWrapper,
  }) : _databaseWrapper = databaseWrapper;

  final DatabaseWrapper _databaseWrapper;

  @override
  Future<MatchEntityData?> getMatch({
    required int matchId,
  }) async {
    final select = _databaseWrapper.matchesRepo.select();
    final findMatch = select..where((tbl) => tbl.id.equals(matchId));

    final match = await findMatch.getSingleOrNull();
    return match;
  }
}
