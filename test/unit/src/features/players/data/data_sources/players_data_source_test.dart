import 'package:drift/drift.dart' hide isNull;
import 'package:five_on_4_backend/src/features/auth/domain/values/new_auth_data_value.dart';
import 'package:five_on_4_backend/src/features/auth/utils/constants/auth_type_constants.dart';

import 'package:five_on_4_backend/src/features/players/domain/values/players_search_filter_value.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/core/utils/extensions/date_time_extension.dart';
import 'package:five_on_4_backend/src/features/players/data/data_sources/players_data_source.dart';
import 'package:five_on_4_backend/src/features/players/data/data_sources/players_data_source_impl.dart';
import 'package:five_on_4_backend/src/wrappers/libraries/drift/app_database.dart';

import '../../../../../../helpers/database/test_database.dart';

void main() {
  late TestDatabaseWrapper testDatabaseWrapper;

  // tested class
  late PlayersDataSource playersDataSource;

  setUp(() async {
    // testDatabaseWrapper = await getTestMemoryDatabaseWrapper();
    testDatabaseWrapper = await getTestPostgresDatabaseWrapper();

    playersDataSource = PlayersDataSourceImpl(
      databaseWrapper: testDatabaseWrapper.databaseWrapper,
    );
  });

  tearDown(() async {
    await testDatabaseWrapper.clearAll();
    await testDatabaseWrapper.databaseWrapper.close();
  });

  group("$PlayersDataSource", () {
    group(
      ".searchPlayers",
      () {
        test(
          "given existing players in db "
          "when .searchPlayers() is called with a [nameTerm] filter "
          "then should return  players that match the filter",
          () async {
            // setup
            final PlayersSearchFilterValue filter = PlayersSearchFilterValue(
              nameTerm: "ronaldo",
            );

            // given
            await testDatabaseWrapper.databaseWrapper.transaction(
              () async {
                for (final authEntityData in _authEntitiesData) {
                  await testDatabaseWrapper.databaseWrapper.authsRepo
                      .insertOne(authEntityData);
                }

                for (final playerEntityData in _playerEntitiesData) {
                  await testDatabaseWrapper.databaseWrapper.playersRepo
                      .insertOne(playerEntityData);
                }
              },
            );

            // when
            final foundPlayers =
                await playersDataSource.searchPlayers(filter: filter);

            // then
            final expectedPlayers = [
              _playerEntitiesData[0],
              _playerEntitiesData[1],
              _playerEntitiesData[2],
              _playerEntitiesData[3],
            ];

            expect(foundPlayers, equals(expectedPlayers));

            // cleanup
          },
        );

        test(
          "given existing players in db "
          "when .searchPlayers() is called with no filters "
          "then should return no found matches",
          () async {
            // setup
            final PlayersSearchFilterValue filter = PlayersSearchFilterValue();

            // given
            await testDatabaseWrapper.databaseWrapper.transaction(
              () async {
                for (final authEntityData in _authEntitiesData) {
                  await testDatabaseWrapper.databaseWrapper.authsRepo
                      .insertOne(authEntityData);
                }

                for (final playerEntityData in _playerEntitiesData) {
                  await testDatabaseWrapper.databaseWrapper.playersRepo
                      .insertOne(playerEntityData);
                }
              },
            );

            // when
            final foundPlayers =
                await playersDataSource.searchPlayers(filter: filter);

            // then
            expect(foundPlayers, isEmpty);

            // cleanup
          },
        );
      },
    );

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
          await testDatabaseWrapper.databaseWrapper.authsRepo.insertOne(
            testAuthCompanion,
          );
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
          final authCompanion = AuthEntityCompanion.insert(
            id: Value(authId),
            email: "email",
            password: Value("password"),
            authType: AuthTypeConstants.emailPassword.name,
            createdAt: DateTime.now().normalizedToSeconds,
            updatedAt: DateTime.now().normalizedToSeconds,
          );

          final playerCompanion = PlayerEntityCompanion.insert(
            id: Value(1),
            firstName: "firstName",
            lastName: "lastName",
            nickname: "nickname",
            createdAt: DateTime.now().normalizedToSeconds,
            updatedAt: DateTime.now().normalizedToSeconds,
            authId: authId,
          );

          await testDatabaseWrapper.databaseWrapper.authsRepo
              .insertOne(authCompanion);

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

final testAuthCompanion = AuthEntityCompanion.insert(
  id: Value(1),
  email: "email",
  password: Value("password"),
  authType: AuthTypeConstants.emailPassword.name,
  createdAt: DateTime.now().normalizedToSeconds,
  updatedAt: DateTime.now().normalizedToSeconds,
);

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

final _authValues = [
  NewAuthDataValueEmailPassword(
    email: "email1",
    hashedPassword: "hashedPassword1",
    firstName: "Ivan",
    lastName: "Lokavić",
    nickname: "ronaldo",
  ),
  NewAuthDataValueEmailPassword(
    email: "email2",
    hashedPassword: "hashedPassword2",
    firstName: "Ovan",
    lastName: "Lokvić",
    nickname: "ronaldinho",
  ),
  NewAuthDataValueEmailPassword(
    email: "email3",
    hashedPassword: "hashedPassword3",
    firstName: "Pvan",
    lastName: "Lovrić",
    nickname: "romuldo",
  ),
  NewAuthDataValueEmailPassword(
    email: "email4",
    hashedPassword: "hashedPassword4",
    firstName: "Qvan",
    lastName: "Livić",
    nickname: "rivaldo",
  ),
  NewAuthDataValueEmailPassword(
    email: "email5",
    hashedPassword: "hashedPassword5",
    firstName: "Rvan",
    lastName: "Lović",
    nickname: "bebeto",
  ),
  NewAuthDataValueEmailPassword(
    email: "email6",
    hashedPassword: "hashedPassword6",
    firstName: "Svan",
    lastName: "Lovać",
    nickname: "raul",
  ),
  NewAuthDataValueEmailPassword(
    email: "email7",
    hashedPassword: "hashedPassword7",
    firstName: "Tvan",
    lastName: "Lorvić",
    nickname: "cristiano",
  ),
  NewAuthDataValueEmailPassword(
    email: "email8",
    hashedPassword: "hashedPassword8",
    firstName: "Uvan",
    lastName: "Lovkić",
    nickname: "messi",
  ),
];

final _authEntitiesData = _authValues.map(
  (authValue) {
    return AuthEntityData(
      id: _authValues.indexOf(authValue) + 1,
      email: authValue.email,
      password: authValue.hashedPassword,
      authType: authValue.authType.name,
      createdAt: DateTime.now().normalizedToSeconds,
      updatedAt: DateTime.now().normalizedToSeconds,
    );
  },
).toList();

final _playerEntitiesData = _authValues.map(
  (authValue) {
    return PlayerEntityData(
      id: _authValues.indexOf(authValue) + 1,
      authId: _authValues.indexOf(authValue) + 1,
      firstName: authValue.firstName,
      lastName: authValue.lastName,
      nickname: authValue.nickname,
      createdAt: DateTime.now().normalizedToSeconds,
      updatedAt: DateTime.now().normalizedToSeconds,
      teamId: null,
    );
  },
).toList();
