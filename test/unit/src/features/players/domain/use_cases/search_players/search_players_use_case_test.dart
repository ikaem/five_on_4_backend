import 'package:five_on_4_backend/src/features/players/domain/models/player_model.dart';
import 'package:five_on_4_backend/src/features/players/domain/repositories/players_repository.dart';
import 'package:five_on_4_backend/src/features/players/domain/use_cases/search_players/search_players_use_case.dart';
import 'package:five_on_4_backend/src/features/players/domain/values/players_search_filter_value.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  final playersRepository = _MockPlayersRepository();

  // tested class
  final useCase = SearchPlayersUseCase(playersRepository: playersRepository);

  setUpAll(() {
    registerFallbackValue(PlayersSearchFilterValue());
  });

  tearDown(() {
    reset(playersRepository);
  });

  group("$SearchPlayersUseCase", () {
    group(".call()", () {
      test(
        "given PlayersRepository.searchPlayers returns searched players"
        "when .call() is called "
        "then should return expected players",
        () async {
          // setup
          final playerModels = List.generate(3, (index) {
            return PlayerModel(
              id: index + 1,
              // name: "name",
              firstName: "firstName",
              lastName: "lastName",
              nickname: "nickname",
              authId: 1,
            );
          });

          // given
          when(
            () => playersRepository.searchPlayers(
              filter: any(named: "filter"),
            ),
          ).thenAnswer((i) async => playerModels);

          // when
          final result = await useCase.call(
            filter: PlayersSearchFilterValue(
              nameTerm: "name",
            ),
          );

          // then
          expect(result, equals(playerModels));
          verify(() => playersRepository.searchPlayers(
              filter: PlayersSearchFilterValue(nameTerm: "name"))).called(1);

          // cleanup
        },
      );
    });
  });
}

class _MockPlayersRepository extends Mock implements PlayersRepository {}
