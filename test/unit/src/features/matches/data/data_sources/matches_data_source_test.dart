import 'package:drift/drift.dart' hide isNull;
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/core/utils/extensions/date_time_extension.dart';
import '../../../../../../../bin/src/features/matches/data/data_sources/matches_data_source.dart';
import '../../../../../../../bin/src/features/matches/data/data_sources/matches_data_source_impl.dart';
import '../../../../../../../bin/src/wrappers/libraries/drift/app_database.dart';
import '../../../../../../helpers/database/test_database.dart';

void main() {
  late TestDatabaseWrapper testDatabaseWrapper;

  // tested class
  late MatchesDataSource matchesDataSource;

  setUp(() async {
    testDatabaseWrapper = await getTestDatabaseWrapper();
    matchesDataSource = MatchesDataSourceImpl(
      databaseWrapper: testDatabaseWrapper.databaseWrapper,
    );
  });

  tearDown(() async {
    await testDatabaseWrapper.databaseWrapper.close();
  });

  group("$MatchesDataSource", () {
    group(".getMatch()", () {
      test(
        "given match does not exist in db "
        "when .getMatch() is called with matchId "
        "then should return null",
        () async {
          // setup
          final matchId = 1;

          // given

          // when
          final match = await matchesDataSource.getMatch(matchId: matchId);

          // then
          expect(match, isNull);

          // cleanup
        },
      );

      test(
        "given match exists in db "
        "when .getMatch() is called with matchId"
        "then should return expected match entity data",
        () async {
          // setup

          // given
          final matchCompanion = MatchEntityCompanion.insert(
            dateAndTime: DateTime.now().normalizedToSeconds,
            location: "location",
            description: "description",
            createdAt: DateTime.now().normalizedToSeconds,
            updatedAt: DateTime.now().normalizedToSeconds,
          );
          final id = await testDatabaseWrapper.databaseWrapper.matchesRepo
              .insertOne(matchCompanion);

          // when
          final match = await matchesDataSource.getMatch(matchId: id);

          // then
          final expectedMatch = MatchEntityData(
            id: id,
            dateAndTime: matchCompanion.dateAndTime.value,
            location: matchCompanion.location.value,
            description: matchCompanion.description.value,
            createdAt: matchCompanion.createdAt.value,
            updatedAt: matchCompanion.updatedAt.value,
          );

          expect(
            match,
            equals(expectedMatch),
          );

          // cleanup
          print("TODO cleanup");
        },
      );
    });
  });
}
