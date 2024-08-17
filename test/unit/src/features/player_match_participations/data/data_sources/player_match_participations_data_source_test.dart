import 'package:drift/drift.dart';
import 'package:five_on_4_backend/src/features/core/utils/extensions/date_time_extension.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/data/data_sources/player_match_participations_data_source.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/data/data_sources/player_match_participations_data_source_impl.dart';
import 'package:five_on_4_backend/src/features/player_match_participations/data/entities/player_match_participation_entity.dart';
import 'package:five_on_4_backend/src/server.dart';
import 'package:five_on_4_backend/src/wrappers/libraries/drift/app_database.dart';
import 'package:postgres/postgres.dart';
import 'package:test/test.dart';

import '../../../../../../helpers/database/test_database.dart';

void main() {
  late TestDatabaseWrapper testDatabaseWrapper;

  // tested class
  late PlayerMatchParticipationsDataSource playerMatchParticipationsDataSource;

  setUp(() async {
    testDatabaseWrapper = await getTestPostgresDatabaseWrapper();
    playerMatchParticipationsDataSource =
        PlayerMatchParticipationsDataSourceImpl(
      databaseWrapper: testDatabaseWrapper.databaseWrapper,
    );
  });

  tearDown(() async {
    await testDatabaseWrapper.clearAll();
    // TODO close should be on testDatabaseWrapper too - we should never be able to close main database in production
    await testDatabaseWrapper.databaseWrapper.close();
  });

  group("$PlayerMatchParticipationsDataSource", () {
    group(
      ".createParticipation",
      () {
        final playerId = 1;
        final matchId = 1;

        setUp(() async {
          // // need to add player and match to the database - to have refs
          // // TODO maybe add this to setup
          final AuthEntityCompanion authCompanion = AuthEntityCompanion.insert(
            id: Value(1),
            email: "email",
            authType: "authType",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          final PlayerEntityCompanion playerCompanion =
              PlayerEntityCompanion.insert(
            id: Value(playerId),
            firstName: "firstName",
            lastName: "lastName",
            nickname: "nickname",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            authId: 1,
          );
          final MatchEntityCompanion matchCompanion =
              MatchEntityCompanion.insert(
            id: Value(matchId),
            title: "title",
            description: "description",
            dateAndTime: DateTime.now(),
            location: "location",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await testDatabaseWrapper.databaseWrapper.authsRepo.insertOne(
            authCompanion,
          );
          await testDatabaseWrapper.databaseWrapper.playersRepo.insertOne(
            playerCompanion,
          );
          await testDatabaseWrapper.databaseWrapper.matchesRepo.insertOne(
            matchCompanion,
          );
        });

        // shoud return expected id - check db that it has exaclty one item, and it has that id
        test(
          "given valid [CreatePlayerMatchParticipationValue]"
          "when [.createParticipation()] is called"
          "then should return the id of the created participation",
          () async {
            // setup

            // given
            final CreatePlayerMatchParticipationValue createValue =
                CreatePlayerMatchParticipationValue(
              playerId: playerId,
              matchId: matchId,
              createdAt:
                  DateTime.now().normalizedToSeconds.millisecondsSinceEpoch,
              updatedAt:
                  DateTime.now().normalizedToSeconds.millisecondsSinceEpoch,
            );

            // when
            final id =
                await playerMatchParticipationsDataSource.createParticipation(
              value: createValue,
            );

            // then
            // get all participations - there should be one
            final select = testDatabaseWrapper
                .databaseWrapper.playerMatchParticipationsRepo
                .select();
            final participations = await select.get();

            expect(participations.length, equals(1));
            expect(participations.first.id, equals(id));

            // cleanup
          },
        );

        // should store in db
        test(
          "given valid [CreatePlayerMatchParticipationValue]"
          "when [.createParticipation()] is called"
          "then should store the participation in the databse ",
          () async {
            // setup

            // given

            final CreatePlayerMatchParticipationValue createValue =
                CreatePlayerMatchParticipationValue(
              playerId: playerId,
              matchId: matchId,
              createdAt:
                  DateTime.now().normalizedToSeconds.millisecondsSinceEpoch,
              updatedAt:
                  DateTime.now().normalizedToSeconds.millisecondsSinceEpoch,
            );

            // when

            final id =
                await playerMatchParticipationsDataSource.createParticipation(
              value: createValue,
            );

            // then

            final expectedMatch = PlayerMatchParticipationEntityData(
              id: id,
              createdAt:
                  DateTime.fromMillisecondsSinceEpoch(createValue.createdAt),
              updatedAt:
                  DateTime.fromMillisecondsSinceEpoch(createValue.updatedAt),
              playerId: playerId,
              matchId: matchId,
              status: PlayerMatchParticipationStatus.pendingDecision,
            );

            final select = testDatabaseWrapper
                .databaseWrapper.playerMatchParticipationsRepo
                .select();
            final findParticipationSelect = select
              ..where((tbl) => tbl.id.equals(id));

            final participation =
                await findParticipationSelect.getSingleOrNull();

            expect(participation, equals(expectedMatch));

            // cleanup
          },
        );

// should not allow to create duplicate participation for the same player and match
// TODO this should probably involve some table constraints - that the combination of player and match is unique

        test(
          "given a participation for a player a match exists"
          "when call to [.createParticipation()] is made with the same player and match"
          "then should throw an exception",
          () async {
            // setup
            final CreatePlayerMatchParticipationValue createValue =
                CreatePlayerMatchParticipationValue(
              playerId: playerId,
              matchId: matchId,
              createdAt:
                  DateTime.now().normalizedToSeconds.millisecondsSinceEpoch,
              updatedAt:
                  DateTime.now().normalizedToSeconds.millisecondsSinceEpoch,
            );

            // given
            await playerMatchParticipationsDataSource.createParticipation(
              value: createValue,
            );

            expect(
              () => playerMatchParticipationsDataSource.createParticipation(
                value: createValue,
              ),
              throwsA(predicate((e) {
                if (e is! ServerException) return false;

                final message = e.message;

                final isExpected = message ==
                    'duplicate key value violates unique constraint "player_match_participation_entity_player_id_match_id_key"';

                return isExpected;
              })),
            );

            // then

            // cleanup
          },
        );
      },
    );
  });
}
