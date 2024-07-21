import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/players/domain/models/player_model.dart';
import 'package:five_on_4_backend/src/features/players/domain/repositories/players_repository.dart';
import 'package:five_on_4_backend/src/features/players/domain/use_cases/get_player_by_auth_id/get_player_by_auth_id_use_case.dart';

void main() {
  final playersRepository = _MockPlayersRepository();

  // tested class
  final getPlayersByAuthIdUseCase = GetPlayerByAuthIdUseCase(
    playersRepository: playersRepository,
  );

  tearDown(() {
    reset(playersRepository);
  });

  group("$GetPlayerByAuthIdUseCase", () {
    group(".call()", () {
      test(
        "given authId and non-existing matching player in db"
        "when .call() is called "
        "then should return null",
        () async {
          // setup

          // given
          final authId = 1;
          when(() => playersRepository.getPlayerByAuthId(authId: authId))
              .thenAnswer((i) async => null);

          // when
          final player = await getPlayersByAuthIdUseCase.call(
            authId: authId,
          );

          // then
          expect(player, isNull);

          // cleanup
        },
      );

      test(
        "given authId and existing matching player in db"
        "when .call() is called "
        "then should return the player",
        () async {
          // setup

          // given
          final authId = 1;
          when(() => playersRepository.getPlayerByAuthId(authId: authId))
              .thenAnswer((i) async => testPlayerModel);

          // when
          final player = await getPlayersByAuthIdUseCase.call(
            authId: authId,
          );

          // then
          expect(player, equals(testPlayerModel));
        },
      );
    });
  });
}

class _MockPlayersRepository extends Mock implements PlayersRepository {}

final testPlayerModel = PlayerModel(
  id: 1,
  name: "name",
  nickname: "nickname",
  authId: 1,
);
