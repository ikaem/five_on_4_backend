import 'package:drift/drift.dart' hide isNull;
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/core/utils/extensions/date_time_extension.dart';
import '../../../../../../../bin/src/features/players/data/data_sources/players_data_source.dart';
import '../../../../../../../bin/src/features/players/data/data_sources/players_data_source_impl.dart';
import '../../../../../../../bin/src/wrappers/libraries/drift/app_database.dart';
import '../../../../../../helpers/database/test_database.dart';

void main() {
  late TestDatabaseWrapper testDatabaseWrapper;

  // tested class
  late PlayersDataSource playersDataSource;

  setUp(() async {
    testDatabaseWrapper = await getTestDatabaseWrapper();

    playersDataSource = PlayersDataSourceImpl(
      databaseWrapper: testDatabaseWrapper.databaseWrapper,
    );
  });

  tearDown(() async {
    await testDatabaseWrapper.databaseWrapper.close();
  });

  group("$PlayersDataSource", () {
    group(".getPlayerById()", () {
      test(
        "given an invalid id "
        "when .getPlayerById() is called "
        "then should return null",
        () async {
          // setup

          // given
          final id = 1;

          // when
          final player = await playersDataSource.getPlayerById(
            id: id,
          );

          // then
          expect(player, isNull);

          // cleanup
        },
      );

      test(
        "given a valid id "
        "when .getPlayerById() is called "
        "then should return expected player entity data",
        () async {
          // setup
          await testDatabaseWrapper.databaseWrapper.playersRepo
              .insertOne(testPlayerCompanion);

          // given
          final playerId = testPlayerCompanion.id.value;

          // when
          final player = await playersDataSource.getPlayerById(
            id: playerId,
          );

          // then
          expect(player, equals(testPlayerEntityData));

          // cleanup
        },
      );
    });

    group(".getPlayerByAuthId()", () {
      test(
        "given player for an authId does not exist in db "
        "when .getPlayerByAuthId() is called with the authId "
        "then should return null",
        () async {
          // setup
          final authId = 1;

          // given

          // when
          final player = await playersDataSource.getPlayerByAuthId(
            authId: authId,
          );

          // then
          expect(player, isNull);

          // cleanup
        },
      );

      test(
        "given player for an authId exists in db "
        "when .getPlayerByAuthId() is called with the authId "
        "then should return the player",
        () async {
          // setup
          final authId = 1;

          // given

          final playerCompanion = PlayerEntityCompanion.insert(
            firstName: "firstName",
            lastName: "lastName",
            nickname: "nickname",
            createdAt: DateTime.now().normalizedToSeconds,
            updatedAt: DateTime.now().normalizedToSeconds,
            authId: authId,
          );

          await testDatabaseWrapper.databaseWrapper.playersRepo
              .insertOne(playerCompanion);

          // when
          final player = await playersDataSource.getPlayerByAuthId(
            authId: authId,
          );

          // then
          final expectedPlayer = PlayerEntityData(
            id: 1,
            authId: authId,
            firstName: playerCompanion.firstName.value,
            lastName: playerCompanion.lastName.value,
            nickname: playerCompanion.nickname.value,
            createdAt: playerCompanion.createdAt.value,
            updatedAt: playerCompanion.updatedAt.value,
            teamId: playerCompanion.teamId.value,
          );

          expect(player, equals(expectedPlayer));

          // cleanup
        },
      );
    });
  });
}

final testPlayerCompanion = PlayerEntityCompanion.insert(
  id: Value(1),
  firstName: "firstName",
  lastName: "lastName",
  nickname: "nickname",
  createdAt: DateTime.now().normalizedToSeconds,
  updatedAt: DateTime.now().normalizedToSeconds,
  authId: 1,
);

final testPlayerEntityData = PlayerEntityData(
  id: testPlayerCompanion.id.value,
  firstName: testPlayerCompanion.firstName.value,
  lastName: testPlayerCompanion.lastName.value,
  nickname: testPlayerCompanion.nickname.value,
  createdAt: testPlayerCompanion.createdAt.value,
  updatedAt: testPlayerCompanion.updatedAt.value,
  authId: testPlayerCompanion.authId.value,
);
