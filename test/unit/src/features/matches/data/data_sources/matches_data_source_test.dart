import 'package:drift/drift.dart' hide isNull;
import 'package:five_on_4_backend/src/features/auth/utils/constants/auth_type_constants.dart';
import 'package:five_on_4_backend/src/features/matches/domain/values/match_entity_value.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/data/entities/player_match_participation_entity.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/domain/values/player_match_participation_entity_value.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/core/utils/extensions/date_time_extension.dart';
import 'package:five_on_4_backend/src/features/matches/data/data_sources/matches_data_source.dart';
import 'package:five_on_4_backend/src/features/matches/data/data_sources/matches_data_source_impl.dart';
import 'package:five_on_4_backend/src/features/matches/domain/values/create_match_value.dart';
import 'package:five_on_4_backend/src/features/matches/domain/values/match_search_filter_value.dart';
import 'package:five_on_4_backend/src/wrappers/libraries/drift/app_database.dart';
import '../../../../../../helpers/database/test_database.dart';

void main() {
  late TestDatabaseWrapper testDatabaseWrapper;

  // tested class
  late MatchesDataSource matchesDataSource;

  setUp(() async {
    // testDatabaseWrapper = await getTestMemoryDatabaseWrapper();
    testDatabaseWrapper = await getTestPostgresDatabaseWrapper();
    matchesDataSource = MatchesDataSourceImpl(
      databaseWrapper: testDatabaseWrapper.databaseWrapper,
    );
  });

  tearDown(() async {
    // TODO test only
    await testDatabaseWrapper.clearAll();
    await testDatabaseWrapper.databaseWrapper.close();
  });

  group(".getMatch()", () {
    test(
      "given match with participations exists in db "
      "when [.getMatch()] is called with [matchId] "
      "then should return expected result",
      () async {
        // setup

        // given
        await _insertMatchWithParticipations(
          testDatabaseWrapper: testDatabaseWrapper,
        );

        // when
        final match = await matchesDataSource.getMatch(matchId: 1);

        // then
        final expectedMatch = MatchEntityValue(
          id: _match.id,
          title: _match.title,
          dateAndTime: _match.dateAndTime,
          location: _match.location,
          description: _match.description,
          createdAt: _match.createdAt,
          updatedAt: _match.updatedAt,
          participtions: _participations
              .map(
                (participation) => PlayerMatchParticipationEntityValue(
                  id: participation.id,
                  playerId: participation.playerId,
                  matchId: participation.matchId,
                  status: participation.status,
                  createdAt: participation.createdAt,
                  updatedAt: participation.updatedAt,
                  playerNickname: _players
                      .firstWhere(
                        (player) => player.id == participation.playerId,
                      )
                      .nickname,
                ),
              )
              .toList(),
        );

        expect(match, equals(expectedMatch));

        // cleanup
      },
    );

    test(
      "given match without participations exists in db "
      "when .getMatch() is called with matchId"
      "then should return expected match entity data",
      () async {
        // setup

        // given
        final id =
            await testDatabaseWrapper.databaseWrapper.matchesRepo.insertOne(
          _match,
        );

        // when
        final match = await matchesDataSource.getMatch(matchId: id);

        // then
        final expectedMatch = MatchEntityValue(
          id: _match.id,
          title: _match.title,
          dateAndTime: _match.dateAndTime,
          location: _match.location,
          description: _match.description,
          createdAt: _match.createdAt,
          updatedAt: _match.updatedAt,
          participtions: [],
        );

        expect(
          match,
          equals(expectedMatch),
        );

        // cleanup
        print("TODO cleanup");
      },
    );

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
  });

  group("$MatchesDataSource", () {
    group(
      ".searchMatches()",
      () {
        // TODO try
        final matchEntityData1 = MatchEntityData(
          id: 1,
          title: "Ivan",
          dateAndTime: DateTime.now().normalizedToSeconds,
          location: "location",
          description: "description",
          createdAt: DateTime.now().normalizedToSeconds,
          updatedAt: DateTime.now().normalizedToSeconds,
        );
        final matchEntityData2 = MatchEntityData(
          id: 2,
          title: "Ovan",
          dateAndTime: DateTime.now().normalizedToSeconds,
          location: "location",
          description: "description",
          createdAt: DateTime.now().normalizedToSeconds,
          updatedAt: DateTime.now().normalizedToSeconds,
        );
        final matchEntityData3 = MatchEntityData(
          id: 3,
          title: "Ivanović",
          dateAndTime: DateTime.now().normalizedToSeconds,
          location: "location",
          description: "description",
          createdAt: DateTime.now().normalizedToSeconds,
          updatedAt: DateTime.now().normalizedToSeconds,
        );
        final matchEntityData4 = MatchEntityData(
          id: 4,
          title: "Ovo",
          dateAndTime: DateTime.now().normalizedToSeconds,
          location: "location",
          description: "description",
          createdAt: DateTime.now().normalizedToSeconds,
          updatedAt: DateTime.now().normalizedToSeconds,
        );
        final matchEntitieData5 = MatchEntityData(
          id: 5,
          title: "Ivo",
          dateAndTime: DateTime.now().normalizedToSeconds,
          location: "location",
          description: "description",
          createdAt: DateTime.now().normalizedToSeconds,
          updatedAt: DateTime.now().normalizedToSeconds,
        );
        final matchEntitieData6 = MatchEntityData(
          id: 6,
          title: "Pivo",
          dateAndTime: DateTime.now().normalizedToSeconds,
          location: "location",
          description: "description",
          createdAt: DateTime.now().normalizedToSeconds,
          updatedAt: DateTime.now().normalizedToSeconds,
        );

        final matchEntitiesData = [
          matchEntityData1,
          matchEntityData2,
          matchEntityData3,
          matchEntityData4,
          matchEntitieData5,
          matchEntitieData6,
        ];
        test(
          "given existing matches in db "
          "when .searchMatches() is called with specific matchName filter "
          "then should return expected matches",
          () async {
            // setup
            final MatchSearchFilterValue filter = MatchSearchFilterValue(
              matchTitle: "Iv",
            );

            // given
            await testDatabaseWrapper.databaseWrapper.transaction(() async {
              for (final matchEntityData in matchEntitiesData) {
                await testDatabaseWrapper.databaseWrapper.matchesRepo.insertOne(
                  matchEntityData,
                );
              }
            });

            // when
            final foundMatches = await matchesDataSource.searchMatches(
              filter: filter,
            );

            // then
            final expectedMatches = [
              matchEntityData1,
              matchEntityData4,
              matchEntitieData5,
            ];

            expect(foundMatches, equals(expectedMatches));

            print("what");

            // cleanup
          },
        );

        test(
          "given existing matches in db"
          "when .searchMatches() is called without specific matchName filter"
          "then should return expected matches",
          () async {
            // setup
            final MatchSearchFilterValue filter = MatchSearchFilterValue();

            // given
            await testDatabaseWrapper.databaseWrapper.transaction(() async {
              for (final matchEntityData in matchEntitiesData) {
                await testDatabaseWrapper.databaseWrapper.matchesRepo.insertOne(
                  matchEntityData,
                );
              }
            });

            // when
            final foundMatches = await matchesDataSource.searchMatches(
              filter: filter,
            );

            // then
            final expectedMatches = matchEntitiesData.getRange(0, 5);

            expect(foundMatches, equals(expectedMatches));

            // cleanup
          },
        );
      },
    );

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
  });
}

Future<void> _insertMatchWithParticipations({
  required TestDatabaseWrapper testDatabaseWrapper,
}) async {
  // insert all
  await testDatabaseWrapper.databaseWrapper.transaction(() async {
    for (final auth in _auths) {
      await testDatabaseWrapper.databaseWrapper.authsRepo.insertOne(auth);
    }
    for (final player in _players) {
      await testDatabaseWrapper.databaseWrapper.playersRepo.insertOne(player);
    }
    await testDatabaseWrapper.databaseWrapper.matchesRepo.insertOne(_match);
    for (final participation in _participations) {
      await testDatabaseWrapper.databaseWrapper.playerMatchParticipationsRepo
          .insertOne(participation);
    }
  });
}

final _auths = List.generate(2, (index) {
  return AuthEntityData(
    id: index + 1,
    email: "email$index",
    password: "password$index",
    createdAt: DateTime.now().normalizedToSeconds,
    updatedAt: DateTime.now().normalizedToSeconds,
    authType: AuthTypeConstants.emailPassword.name,
  );
});

// insert players
final _players = List.generate(2, (index) {
  return PlayerEntityData(
    id: index + 1,
    authId: index + 1,
    firstName: "firstName$index",
    lastName: "lastName$index",
    nickname: "nickname$index",
    createdAt: DateTime.now().normalizedToSeconds,
    updatedAt: DateTime.now().normalizedToSeconds,
  );
});

// insert match
final _match = MatchEntityData(
  id: 1,
  title: "title",
  dateAndTime: DateTime.now().normalizedToSeconds,
  location: "location",
  description: "description",
  createdAt: DateTime.now().normalizedToSeconds,
  updatedAt: DateTime.now().normalizedToSeconds,
);

// insert participations - two
final _participations = List.generate(2, (index) {
  return PlayerMatchParticipationEntityData(
    id: index + 1,
    playerId: index + 1,
    matchId: 1,
    createdAt: DateTime.now().normalizedToSeconds,
    updatedAt: DateTime.now().normalizedToSeconds,
    status: PlayerMatchParticipationStatus.values[index],
  );
});
