import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/core/utils/extensions/date_time_extension.dart';
import '../../../../../../../bin/src/features/players/data/data_sources/players_data_source.dart';
import '../../../../../../../bin/src/features/players/domain/models/player_model.dart';
import '../../../../../../../bin/src/features/players/domain/repositories/players_repository.dart';
import '../../../../../../../bin/src/features/players/domain/repositories/players_repository_impl.dart';
import '../../../../../../../bin/src/features/players/utils/converters/players_converter.dart';
import '../../../../../../../bin/src/wrappers/libraries/drift/app_database.dart';

void main() {
  final playersDataSource = _MockPlayersDataSource();

  // tested class
  final playersRepository = PlayersRepositoryImpl(
    playersDataSource: playersDataSource,
  );

  tearDown(() {
    reset(playersDataSource);
  });

  group("$PlayersRepository", () {
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
            name:
                "${testPlayerEntityData.firstName} ${testPlayerEntityData.lastName}",
            nickname: testPlayerEntityData.nickname,
          );
          expect(player, equals(expectedPlayer));

          // cleanup
        },
      );
    });
  });
}

class _MockPlayersDataSource extends Mock implements PlayersDataSource {}

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
