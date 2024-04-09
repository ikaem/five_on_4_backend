import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../../bin/src/features/core/utils/extensions/date_time_extension.dart';
import '../../../../../../../bin/src/features/matches/data/data_sources/matches_data_source.dart';
import '../../../../../../../bin/src/features/matches/domain/models/match_model.dart';
import '../../../../../../../bin/src/features/matches/domain/repositories/matches_repository.dart';
import '../../../../../../../bin/src/features/matches/domain/repositories/matches_repository_impl.dart';
import '../../../../../../../bin/src/features/matches/utils/converters/matches_converters.dart';
import '../../../../../../../bin/src/wrappers/libraries/drift/app_database.dart';

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
          final result = await matchesRepositoryImpl.getMatch(matchId: matchId);

          // then
          expect(result, isNull);

          // cleanup
          print("cleanup");
        },
      );

      test(
        "given match exists in data source "
        "when .getMatch() is called with matchId "
        "then should return match",
        () async {
          // setup
          final matchId = 1;

          // given
          when(() => matchesDataSource.getMatch(matchId: matchId))
              .thenAnswer((i) async => testMatchEntityData);

          // when
          final result = await matchesRepositoryImpl.getMatch(matchId: matchId);

          // then
          final expectedMatch =
              MatchesConverter.modelFromEntity(entity: testMatchEntityData);
          expect(result, expectedMatch);

          // cleanup
          print("cleanup");
        },
      );
    });
  });
}

class _MockMatchesDataSource extends Mock implements MatchesDataSource {}

final testMatchEntityData = MatchEntityData(
  id: 1,
  title: "title",
  dateAndTime: DateTime.now().normalizedToSeconds,
  location: "location",
  description: "description",
  createdAt: DateTime.now().normalizedToSeconds,
  updatedAt: DateTime.now().normalizedToSeconds,
);
