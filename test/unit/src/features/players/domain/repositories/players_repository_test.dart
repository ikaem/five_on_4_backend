import 'package:five_on_4_backend/src/features/players/domain/values/players_search_filter_value.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/core/utils/extensions/date_time_extension.dart';
import 'package:five_on_4_backend/src/features/players/data/data_sources/players_data_source.dart';
import 'package:five_on_4_backend/src/features/players/domain/models/player_model.dart';
import 'package:five_on_4_backend/src/features/players/domain/repositories/players_repository.dart';
import 'package:five_on_4_backend/src/features/players/domain/repositories/players_repository_impl.dart';
import 'package:five_on_4_backend/src/features/players/utils/converters/players_converter.dart';
import 'package:five_on_4_backend/src/wrappers/libraries/drift/app_database.dart';

void main() {
  final playersDataSource = _MockPlayersDataSource();

  // tested class
  final playersRepository = PlayersRepositoryImpl(
    playersDataSource: playersDataSource,
  );

  setUpAll(() {
    registerFallbackValue(_FakePlayersSearchFilterValue());
  });

  tearDown(() {
    reset(playersDataSource);
  });

  group("$PlayersRepository", () {
    group(
      ".searchPlayers()",
      () {
        test(
          "given players data source returns search matches"
          "when .searchPlayers() is called "
          "then should return expected players",
          () async {
            // setup
            final playersEntitiesData = List.generate(3, (index) {
              return PlayerEntityData(
                id: index + 1,
                firstName: "firstName",
                lastName: "lastName",
                nickname: "nickname",
                createdAt: DateTime.now().normalizedToSeconds,
                updatedAt: DateTime.now().normalizedToSeconds,
                authId: 1,
              );
            });

            // given
            when(() => playersDataSource.searchPlayers(
                  filter: any(named: "filter"),
                )).thenAnswer((_) => Future.value(playersEntitiesData));

            // when
            final result = await playersRepository.searchPlayers(
              filter: PlayersSearchFilterValue(
                nameTerm: "name",
              ),
            );

            // then
            final expectedPlayerValues = playersEntitiesData
                .map((entity) =>
                    PlayersConverter.modelFromEntity(entity: entity))
                .toList();

            expect(result, equals(expectedPlayerValues));
            verify(() => playersDataSource.searchPlayers(
                  filter: PlayersSearchFilterValue(
                    nameTerm: "name",
                  ),
                ));

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
          when(() => playersDataSource.getPlayerById(id: any(named: "id")))
              .thenAnswer((i) async => null);

          // given
          final id = 1;

          // when
          final player = await playersRepository.getPlayerById(
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
        "then should return expected player",
        () async {
          // setup
          when(() => playersDataSource.getPlayerById(id: any(named: "id")))
              .thenAnswer((i) async => testPlayerEntityData);

          // given
          final id = 1;

          // when
          final player = await playersRepository.getPlayerById(
            id: id,
          );

          // then
          final expectedPlayer =
              PlayersConverter.modelFromEntity(entity: testPlayerEntityData);
          expect(player, equals(expectedPlayer));

          // cleanup
        },
      );
    });
    group(".getPlayerByAuthId()", () {
      test(
        "given authId and non-existing matching player in db"
        "when getPlayerByAuthId() is called "
        "then should return null",
        () async {
          // setup
          final authId = 1;

          // given
          when(() => playersDataSource.getPlayerByAuthId(authId: authId))
              .thenAnswer((i) async => null);

          // when
          final player = await playersRepository.getPlayerByAuthId(
            authId: authId,
          );

          // then
          expect(player, isNull);

          // cleanup
        },
      );

      test(
        "given authId and existing matching player in db"
        "when getPlayerByAuthId() is called "
        "then should return the player",
        () async {
          // setup
          final authId = testPlayerEntityData.authId;

          // given
          when(() => playersDataSource.getPlayerByAuthId(authId: authId))
              .thenAnswer((i) async => testPlayerEntityData);

          // when
          final player = await playersRepository.getPlayerByAuthId(
            authId: authId,
          );

          // then
          final expectedPlayer = PlayerModel(
            id: testPlayerEntityData.id,
            // name:
            //     "${testPlayerEntityData.firstName} ${testPlayerEntityData.lastName}",
            firstName: testPlayerEntityData.firstName,
            lastName: testPlayerEntityData.lastName,
            nickname: testPlayerEntityData.nickname,
            authId: testPlayerEntityData.authId,
          );
          expect(player, equals(expectedPlayer));

          // cleanup
        },
      );
    });
  });
}

class _MockPlayersDataSource extends Mock implements PlayersDataSource {}

class _FakePlayersSearchFilterValue extends Fake
    implements PlayersSearchFilterValue {}

// TODO move somewhere to share in tests possibly
final testPlayerEntityData = PlayerEntityData(
  id: 1,
  firstName: "firstName",
  lastName: "lastName",
  nickname: "nickname",
  createdAt: DateTime.now().normalizedToSeconds,
  updatedAt: DateTime.now().normalizedToSeconds,
  authId: 1,
);
