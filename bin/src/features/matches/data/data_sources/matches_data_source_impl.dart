import 'package:drift/drift.dart';

import '../../../../wrappers/libraries/drift/app_database.dart';
import '../../../../wrappers/local/database/database_wrapper.dart';
import '../../../core/utils/extensions/date_time_extension.dart';
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

  @override
  Future<int> createMatch({required CreateMatchValue createMatchValue}) async {
    final matchDateAndTime = DateTime.fromMillisecondsSinceEpoch(
      createMatchValue.dateAndTime,
    ).normalizedToSeconds;

    final createdAtTime = DateTime.fromMillisecondsSinceEpoch(
      createMatchValue.createdAt,
    ).normalizedToSeconds;
    final updatedAtTime = DateTime.fromMillisecondsSinceEpoch(
      createMatchValue.updatedAt,
    ).normalizedToSeconds;

    final companion = MatchEntityCompanion.insert(
      title: createMatchValue.title,
      dateAndTime: matchDateAndTime,
      location: createMatchValue.location,
      description: createMatchValue.description,
      createdAt: createdAtTime,
      updatedAt: updatedAtTime,
    );

    final id = await _databaseWrapper.matchesRepo.insertOne(companion);

    return id;
  }
}
