import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/players/domain/models/player_model.dart';
import 'package:five_on_4_backend/src/features/players/domain/repositories/players_repository.dart';
import 'package:five_on_4_backend/src/features/players/domain/use_cases/get_player_by_id/get_player_by_id_use_case.dart';

void main() {
  final playersRepository = _MockPlayersRepository();

  // tested class
  final getPlayerByIdUseCase = GetPlayerByIdUseCase(
    playersRepository: playersRepository,
  );

  tearDown(() {
    reset(playersRepository);
  });

  group("$GetPlayerByIdUseCase", () {
    group(".call()", () {
      test(
        "given invalid id "
        "when .call() is called "
        "then should return null",
        () async {
          // setup
          when(() => playersRepository.getPlayerById(id: any(named: "id")))
              .thenAnswer((i) async => null);

          // given
          final id = 1;

          // when
          final player = await getPlayerByIdUseCase.call(
            id: id,
          );

          // then
          expect(player, isNull);

          // cleanup
        },
      );

      test(
        "given valid id "
        "when .call() is called "
        "then should return the expected player",
        () async {
          // setup
          when(() => playersRepository.getPlayerById(id: any(named: "id")))
              .thenAnswer((i) async => testPlayerModel);

          // given
          final id = 1;

          // when
          final player = await getPlayerByIdUseCase.call(
            id: id,
          );

          // then
          expect(player, testPlayerModel);
        },
      );
    });
  });
}

class _MockPlayersRepository extends Mock implements PlayersRepository {}

final testPlayerModel = PlayerModel(
  id: 1,
  // name: "name",
  firstName: "firstName",
  lastName: "lastName",
  nickname: "nickname",
  authId: 1,
);
