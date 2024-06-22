import 'package:drift/drift.dart' hide isNull;
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/core/utils/extensions/date_time_extension.dart';
import '../../../../../../../bin/src/features/matches/data/data_sources/matches_data_source.dart';
import '../../../../../../../bin/src/features/matches/data/data_sources/matches_data_source_impl.dart';
import '../../../../../../../bin/src/features/matches/domain/values/create_match_value.dart';
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
    group(".getPlayerMatchesOverview", () {
      // should get 5 upcoming matches
      test(
        "given player has multiple today matches "
        "when .getPlayerMatchesOverview() is called "
        "then should return response with max 5 today matches in expected order",
        () async {
          // setup
          final matchEntitiesData = List.generate(10, (index) {
            return MatchEntityData(
              id: index + 1,
              title: "title $index",
              // dateAndTime: DateTime.now().normalizedToSeconds,
              dateAndTime: DateTime.now()
                  .add(Duration(minutes: index + 1))
                  .normalizedToSeconds,
              location: "location $index",
              description: "description $index",
              createdAt: DateTime.now().normalizedToSeconds,
              updatedAt: DateTime.now().normalizedToSeconds,
            );
          });

          // given
          await testDatabaseWrapper.databaseWrapper.transaction(() async {
            for (final matchEntityData in matchEntitiesData) {
              await testDatabaseWrapper.databaseWrapper.matchesRepo.insertOne(
                matchEntityData,
              );
            }
          });

          // when
          final response = await matchesDataSource.getPlayerMatchesOverview(
            playerId: 1,
          );

          // then
          final closest5MatchesToNow = matchEntitiesData.sublist(0, 5);
          expect(response, equals(closest5MatchesToNow));
        },
      );

      // should get 5 upcoming matches
      test(
        "given player has multiple upcoming matches "
        "when .getPlayerMatchesOverview() is called "
        "then should return response with max 5 upcoming matches in expected order",
        () async {
          // setup
          final matchEntitiesData = List.generate(10, (index) {
            return MatchEntityData(
              id: index + 1,
              title: "title $index",
              dateAndTime: DateTime.now()
                  .add(Duration(days: index + 1))
                  .add(Duration(minutes: index + 1))
                  .normalizedToSeconds,
              location: "location $index",
              description: "description $index",
              createdAt: DateTime.now().normalizedToSeconds,
              updatedAt: DateTime.now().normalizedToSeconds,
            );
          });

          // given
          await testDatabaseWrapper.databaseWrapper.transaction(() async {
            for (final matchEntityData in matchEntitiesData) {
              await testDatabaseWrapper.databaseWrapper.matchesRepo.insertOne(
                matchEntityData,
              );
            }
          });

          // when
          final response = await matchesDataSource.getPlayerMatchesOverview(
            playerId: 1,
          );

          // then
          final closest5MatchesToNow = matchEntitiesData.sublist(0, 5);
          expect(response, equals(closest5MatchesToNow));
        },
      );

      // should get 5 past matches
      test(
        "given player has multiple past matches "
        "when .getPlayerMatchesOverview() is called "
        "then should return response with max 5 past matches in expected order",
        () async {
          // setup
          final matchEntitiesData = List.generate(10, (index) {
            return MatchEntityData(
              id: index + 1,
              title: "title $index",
              dateAndTime: DateTime.now()
                  .subtract(Duration(days: index + 1))
                  .subtract(Duration(minutes: index + 1))
                  // .add(Duration(minutes: index + 1))
                  .normalizedToSeconds,
              location: "location $index",
              description: "description $index",
              createdAt: DateTime.now().normalizedToSeconds,
              updatedAt: DateTime.now().normalizedToSeconds,
            );
          });

          // given
          await testDatabaseWrapper.databaseWrapper.transaction(() async {
            for (final matchEntityData in matchEntitiesData) {
              await testDatabaseWrapper.databaseWrapper.matchesRepo.insertOne(
                matchEntityData,
              );
            }
          });

          // when
          final response = await matchesDataSource.getPlayerMatchesOverview(
            playerId: 1,
          );

          // then
          final closest5MatchesToNow = matchEntitiesData.sublist(0, 5);
          expect(response, equals(closest5MatchesToNow));
        },
      );

      // should get max 5 of each upcoming, today and past
      test(
        "given player has multiple upcoming, today and past matches "
        "when .getPlayerMatchesOverview() is called "
        "then should return response with max 5 of each upcoming, today, and past matches in expected order",
        () async {
          // setup
          final todayMatchEntitiesData = List.generate(10, (index) {
            return MatchEntityData(
              id: index + 1,
              title: "title $index",
              dateAndTime: DateTime.now()
                  .add(Duration(minutes: index + 1))
                  .normalizedToSeconds,
              location: "location $index",
              description: "description $index",
              createdAt: DateTime.now().normalizedToSeconds,
              updatedAt: DateTime.now().normalizedToSeconds,
            );
          });
          final upcomingMatchEntitiesData = List.generate(10, (index) {
            return MatchEntityData(
              id: index + 11,
              title: "title $index",
              dateAndTime: DateTime.now()
                  .add(Duration(days: index + 1))
                  .add(Duration(minutes: index + 1))
                  .normalizedToSeconds,
              location: "location $index",
              description: "description $index",
              createdAt: DateTime.now().normalizedToSeconds,
              updatedAt: DateTime.now().normalizedToSeconds,
            );
          });
          final pastMatchEntitiesData = List.generate(10, (index) {
            return MatchEntityData(
              id: index + 21,
              title: "title $index",
              dateAndTime: DateTime.now()
                  .subtract(Duration(days: index + 1))
                  .subtract(Duration(minutes: index + 1))
                  .normalizedToSeconds,
              location: "location $index",
              description: "description $index",
              createdAt: DateTime.now().normalizedToSeconds,
              updatedAt: DateTime.now().normalizedToSeconds,
            );
          });

          // given
          await testDatabaseWrapper.databaseWrapper.transaction(() async {
            for (final matchEntityData in todayMatchEntitiesData) {
              await testDatabaseWrapper.databaseWrapper.matchesRepo.insertOne(
                matchEntityData,
              );
            }
            for (final matchEntityData in upcomingMatchEntitiesData) {
              await testDatabaseWrapper.databaseWrapper.matchesRepo.insertOne(
                matchEntityData,
              );
            }
            for (final matchEntityData in pastMatchEntitiesData) {
              await testDatabaseWrapper.databaseWrapper.matchesRepo.insertOne(
                matchEntityData,
              );
            }
          });

          // when
          final response = await matchesDataSource.getPlayerMatchesOverview(
            playerId: 1,
          );

          // then
          final closest5TodayMatchesToNow =
              todayMatchEntitiesData.sublist(0, 5);
          final closest5UpcomingMatchesToNow =
              upcomingMatchEntitiesData.sublist(0, 5);
          final closest5PastMatchesToNow = pastMatchEntitiesData.sublist(0, 5);

          final expectedResponse = [
            ...closest5TodayMatchesToNow,
            ...closest5UpcomingMatchesToNow,
            ...closest5PastMatchesToNow,
          ];

          expect(response, equals(expectedResponse));

          // cleanup
        },
      );

      // TODO: should make sure that all matches are with the player as a participant
    });

    group(".createMatch()", () {
      test(
        "given valid create match value "
        "when .createMatch() is called  "
        "then should return expected match id",
        () async {
          // setup

          // given
          final createMatchValue = CreateMatchValue(
            description: "description",
            title: "title",
            dateAndTime: DateTime.now().millisecondsSinceEpoch,
            location: "location",
            createdAt: DateTime.now().millisecondsSinceEpoch,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          );

          // when
          final matchId = await matchesDataSource.createMatch(
            createMatchValue: createMatchValue,
          );

          // then
          expect(matchId, equals(1));

          // cleanup
          print("TODO cleanup");
        },
      );

      test(
        "given valid create match value "
        "when .createMatch() is called  "
        "then should store expected match in db",
        () async {
          // setup

          // given
          final createMatchValue = CreateMatchValue(
            description: "description",
            title: "title",
            dateAndTime:
                DateTime.now().normalizedToSeconds.millisecondsSinceEpoch,
            location: "location",
            createdAt:
                DateTime.now().normalizedToSeconds.millisecondsSinceEpoch,
            updatedAt:
                DateTime.now().normalizedToSeconds.millisecondsSinceEpoch,
          );

          // when
          final matchId = await matchesDataSource.createMatch(
            createMatchValue: createMatchValue,
          );

          // then
          final expectedMatch = MatchEntityData(
            id: matchId,
            title: createMatchValue.title,
            dateAndTime: DateTime.fromMillisecondsSinceEpoch(
                createMatchValue.dateAndTime),
            location: createMatchValue.location,
            description: createMatchValue.description,
            createdAt:
                DateTime.fromMillisecondsSinceEpoch(createMatchValue.createdAt),
            updatedAt:
                DateTime.fromMillisecondsSinceEpoch(createMatchValue.updatedAt),
          );

          final select =
              testDatabaseWrapper.databaseWrapper.matchesRepo.select();
          final findMatch = select..where((tbl) => tbl.id.equals(matchId));

          final match = await findMatch.getSingleOrNull();

          expect(match, equals(expectedMatch));

          // cleanup
          print("TODO cleanup");
        },
      );
    });

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
            title: "title",
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
            title: matchCompanion.title.value,
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
