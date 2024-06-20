import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/matches/domain/models/match_model.dart';
import '../../../../../../../bin/src/features/matches/domain/repositories/matches_repository.dart';
import '../../../../../../../bin/src/features/matches/domain/use_cases/get_player_matches_overview/get_player_matches_overview_use_case.dart';

void main() {
  final matchesRepository = _MockMatchesRepository();

  // tested class
  final useCase =
      GetPlayerMatchesOverviewUseCase(matchesRepository: matchesRepository);

  tearDown(() {
    reset(matchesRepository);
  });

  group("$GetPlayerMatchesOverviewUseCase", () {
    group(
      ".call()",
      () {
        test(
          "given player is a participant in matches "
          "when call() is called "
          "then should return expected list of matches",
          () async {
            // setup
            final matches = List.generate(3, (index) {
              return MatchModel(
                dateAndTime: DateTime.now().millisecondsSinceEpoch,
                description: "description",
                id: index + 1,
                location: "location",
                title: "title",
              );
            });

            // given
            when(
              () => matchesRepository.getPlayerMatchesOverview(
                playerId: any(named: "playerId"),
              ),
            ).thenAnswer((i) async => matches);

            // when
            final result = await useCase.call(playerId: 1);

            // then
            final expectedMatches = matches;
            expect(result, equals(expectedMatches));

            // cleanup
          },
        );

        // TODO there should be handled if player id is bad - but maybe controller should be handling that instead
      },
    );
  });
}

class _MockMatchesRepository extends Mock implements MatchesRepository {}
