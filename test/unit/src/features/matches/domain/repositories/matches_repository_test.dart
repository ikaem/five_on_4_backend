import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/matches/data/data_sources/matches_data_source.dart';

void main() {
  final matchesDataSource = _MockMatchesDataSource();

  // tested class
  final matchesRepositoryImpl = MatchesRepositoryImpl(
    matchesDataSource: matchesDataSource,
  );

  tearDown(() {
    reset(matchesDataSource);
  });

  group("$MatchesRepository", () {
    group(".getMatch()", () {
      test(
        "given match does not exist in data source "
        "when .getMatch() is called with matchId "
        "then should return null",
        () async {
          // setup
          final matchId = 1;

          // given
          // TODO test if this is enough without verifying the call
          when(() => matchesDataSource.getMatch(matchId: matchId))
              .thenAnswer((i) async => null);

          // when

          // then

          // cleanup
          print("cleanup");
        },
      );
    });
  });
}

class _MockMatchesDataSource extends Mock implements MatchesDataSource {}
