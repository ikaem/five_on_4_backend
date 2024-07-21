import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:five_on_4_backend/src/features/matches/domain/models/match_model.dart';
import 'package:five_on_4_backend/src/features/matches/domain/repositories/matches_repository.dart';
import 'package:five_on_4_backend/src/features/matches/domain/use_cases/get_match/get_match_use_case.dart';

void main() {
  final matchesRepository = _MockMatchesRepository();

// tested class
  final getMatchUseCase = GetMatchUseCase(
    matchesRepository: matchesRepository,
  );

  tearDown(() {
    reset(matchesRepository);
  });

  group("$GetMatchUseCase", () {
    group(".call()", () {
      test(
        "given invalid match id "
        "when call() is called "
        "then should return null",
        () async {
          // setup

          // given
          final matchId = 1;

          when(() => matchesRepository.getMatch(matchId: matchId))
              .thenAnswer((i) async => null);

          // when
          final match = await getMatchUseCase.call(matchId: matchId);

          // then
          expect(match, isNull);

          // cleanup
        },
      );

      test(
        "given valid match id "
        "when call() is called "
        "then should return match",
        () async {
          // setup
          final matchId = 1;

          // given
          when(() => matchesRepository.getMatch(matchId: matchId))
              .thenAnswer((i) async => testMatchModel);

          // when
          final match = await getMatchUseCase.call(matchId: matchId);

          // then
          expect(match, testMatchModel);
        },
      );
    });
  });
}

class _MockMatchesRepository extends Mock implements MatchesRepository {}

final testMatchModel = MatchModel(
  dateAndTime: DateTime.now().microsecondsSinceEpoch,
  description: "description",
  id: 1,
  location: "location",
  title: "title",
);
