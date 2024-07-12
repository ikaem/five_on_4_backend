import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../../../bin/src/features/matches/domain/models/match_model.dart';
import '../../../../../../../../bin/src/features/matches/domain/repositories/matches_repository.dart';
import '../../../../../../../../bin/src/features/matches/domain/values/match_search_filter_value.dart';

void main() {
  final matchesRepository = _MockMatchesRepository();

  // tested class

  final useCase = SearchMatchesUseCase(matchesRepository: matchesRepository);

  tearDown(() {
    reset(matchesRepository);
  });

  group("$SearchMatchesUseCase", () {
    // given repository returns searched matches
    test(
      "given given MatchesRepository.searchMatches returns searched matches"
      "when .call() is called "
      "then should return expected matches",
      () async {
        // setup
        final matchModels = List.generate(3, (index) {
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
          () => matchesRepository.searchMatches(
            filter: any(named: "filter"),
          ),
        ).thenAnswer((i) async => matchModels);

        // when
        final result = await useCase.call(
          filter: MatchSearchFilterValue(
            matchTitle: "title",
          ),
        );

        // then
        expect(result, equals(matchModels));

        // cleanup
      },
    );
  });
}

class _MockMatchesRepository extends Mock implements MatchesRepository {}
